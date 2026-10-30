import 'package:flutter_test/flutter_test.dart';

import 'package:gebetsglas/models/category.dart';
import 'package:gebetsglas/models/prayer_request.dart';

void main() {
  group('Modelle', () {
    test('Category fromMap/toMap roundtrip', () {
      final now = DateTime(2026, 10, 30, 12, 0);
      final c = Category(
        id: 7,
        name: 'Familie',
        description: 'Meine Familie',
        createdAt: now,
      );
      final back = Category.fromMap(c.toMap());
      expect(back.id, 7);
      expect(back.name, 'Familie');
      expect(back.description, 'Meine Familie');
      expect(back.createdAt, now);
    });

    test('PrayerRequest copyWith erhöht Zähler und setzt Datum', () {
      final r = PrayerRequest(
        id: 3,
        categoryId: 1,
        name: 'Oma',
        createdAt: DateTime(2026, 1, 1),
        prayedCount: 2,
      );
      final prayed = r.copyWith(
        prayedCount: r.prayedCount + 1,
        lastPrayedAt: DateTime(2026, 10, 30, 7, 30),
      );
      expect(prayed.prayedCount, 3);
      expect(prayed.lastPrayedAt!.hour, 7);
      // unverändert:
      expect(prayed.name, 'Oma');
      expect(prayed.categoryId, 1);
    });
  });
}
