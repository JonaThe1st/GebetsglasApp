import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../models/category.dart';
import '../models/journal_entry.dart';
import '../models/prayer_request.dart';

/// Lokale SQLite-Datenbank (kein Backend).
class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const _dbName = 'gebetsglas.db';
  static const _dbVersion = 1;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dir = await getDatabasesPath();
    _db = await openDatabase(
      p.join(dir, _dbName),
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            description TEXT NOT NULL DEFAULT '',
            created_at INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE requests(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
            name TEXT NOT NULL,
            description TEXT NOT NULL DEFAULT '',
            created_at INTEGER NOT NULL,
            prayed_count INTEGER NOT NULL DEFAULT 0,
            last_prayed_at INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE journal(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            request_id INTEGER NOT NULL REFERENCES requests(id) ON DELETE CASCADE,
            category_id INTEGER NOT NULL,
            prayed_at INTEGER NOT NULL
          )
        ''');
        await db.execute(
            'CREATE INDEX idx_requests_category ON requests(category_id)');
        await db.execute(
            'CREATE INDEX idx_journal_prayed_at ON journal(prayed_at)');
      },
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
    );
    return _db!;
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  // ─── Kategorien ────────────────────────────────────────────────────────────

  Future<List<CategoryWithCount>> getCategories() async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT c.*, (SELECT COUNT(*) FROM requests r WHERE r.category_id = c.id) AS cnt
      FROM categories c
      ORDER BY c.name COLLATE NOCASE
    ''');
    return rows.map(CategoryWithCount.fromRow).toList();
  }

  Future<int> insertCategory(Category category) =>
      database.then((db) => db.insert('categories', category.toMap()));

  Future<void> updateCategory(Category category) async {
    final db = await database;
    await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<void> deleteCategory(int id) async {
    final db = await database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  // ─── Gebetsanliegen ────────────────────────────────────────────────────────

  Future<List<PrayerRequest>> getRequests(int categoryId) async {
    final db = await database;
    final rows = await db.query('requests',
        where: 'category_id = ?',
        whereArgs: [categoryId],
        orderBy: 'name COLLATE NOCASE');
    return rows.map(PrayerRequest.fromMap).toList();
  }

  Future<PrayerRequest?> getRequest(int id) async {
    final db = await database;
    final rows =
        await db.query('requests', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return PrayerRequest.fromMap(rows.first);
  }

  Future<int> insertRequest(PrayerRequest request) =>
      database.then((db) => db.insert('requests', request.toMap()));

  Future<void> updateRequest(PrayerRequest request) async {
    final db = await database;
    await db.update(
      'requests',
      request.toMap(),
      where: 'id = ?',
      whereArgs: [request.id],
    );
  }

  Future<void> deleteRequest(int id) async {
    final db = await database;
    await db.delete('requests', where: 'id = ?', whereArgs: [id]);
  }

  /// Zufälliges Anliegen aus einer Auswahl von Kategorien (oder allen) ziehen.
  Future<PrayerRequest?> drawRandom({List<int>? categoryIds}) async {
    final db = await database;
    final where = categoryIds == null || categoryIds.isEmpty
        ? null
        : 'category_id IN (${List.filled(categoryIds.length, '?').join(',')})';
    final rows = await db.query(
      'requests',
      where: where,
      whereArgs: categoryIds,
      orderBy: 'RANDOM()',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return PrayerRequest.fromMap(rows.first);
  }

  /// Gebet festhalten: Journal-Eintrag + Zähler.
  Future<void> recordPrayer(PrayerRequest request) async {
    final db = await database;
    final now = DateTime.now();
    await db.insert('journal', JournalEntry(
      requestId: request.id!,
      categoryId: request.categoryId,
      prayedAt: now,
    ).toMap());
    await db.update(
      'requests',
      {
        'prayed_count': request.prayedCount + 1,
        'last_prayed_at': now.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [request.id],
    );
  }

  // ─── Tagebuch ──────────────────────────────────────────────────────────────

  Future<List<JournalEntry>> getJournal({int limit = 200}) async {
    final db = await database;
    final rows = await db.query('journal',
        orderBy: 'prayed_at DESC', limit: limit);
    return rows.map(JournalEntry.fromMap).toList();
  }

  /// Journal-Einträge angereichert mit Anliegen- und Kategoriename.
  Future<List<Map<String, Object?>>> getJournalDetail({int limit = 300}) async {
    final db = await database;
    return db.rawQuery('''
      SELECT j.prayed_at, r.name AS request_name, c.name AS category_name
      FROM journal j
      JOIN requests r ON r.id = j.request_id
      JOIN categories c ON c.id = j.category_id
      ORDER BY j.prayed_at DESC
      LIMIT ?
    ''', [limit]);
  }

  /// Streak: aufeinanderfolgende Tage (bis heute) mit mindestens einem Gebet.
  Future<int> getStreak() async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT DISTINCT date(prayed_at / 1000, 'unixepoch', 'localtime') AS day
      FROM journal ORDER BY day DESC LIMIT 1000
    ''');
    if (rows.isEmpty) return 0;
    final days = rows
        .map((r) => DateTime.parse(r['day'] as String))
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();

    var streak = 0;
    final today = DateTime.now();
    var cursor = DateTime(today.year, today.month, today.day);
    if (!days.contains(cursor)) {
      // Heute noch nicht gebetet: Streak zählt bis gestern.
      cursor = cursor.subtract(const Duration(days: 1));
    }
    while (days.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Future<int> getTotalPrayers() async {
    final db = await database;
    final rows = await db
        .rawQuery('SELECT COUNT(*) AS cnt FROM journal');
    return rows.first['cnt'] as int;
  }

  Future<Map<String, int>> getStats() async {
    final db = await database;
    final r = await db.rawQuery('''
      SELECT
        (SELECT COUNT(*) FROM categories) AS categories,
        (SELECT COUNT(*) FROM requests) AS requests,
        (SELECT COUNT(*) FROM journal) AS prayers
    ''');
    final row = r.first;
    return {
      'categories': row['categories'] as int,
      'requests': row['requests'] as int,
      'prayers': row['prayers'] as int,
    };
  }

  /// Kategorien, die aktuell für die Benachrichtigung ausgewählt sind.
  Future<List<Category>> getCategoriesByIds(List<int> ids) async {
    if (ids.isEmpty) return [];
    final db = await database;
    final placeholders = List.filled(ids.length, '?').join(',');
    final rows = await db.query('categories',
        where: 'id IN ($placeholders)', whereArgs: ids);
    return rows.map(Category.fromMap).toList();
  }

  /// Anliegen-Name per ID (für Benachrichtigungs-Vorschau).
  Future<String?> getRequestName(int id) async {
    final req = await getRequest(id);
    return req?.name;
  }
}
