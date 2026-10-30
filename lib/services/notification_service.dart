import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../db/database.dart';
import '../models/category.dart';
import 'settings_service.dart';

/// Lokale tägliche Erinnerung (Push, kein Backend).
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const channelId = 'gebetsglas_channel';
  static const _notificationId = 1001;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );
    await _plugin.initialize(settings: settings);

    final androidImpl =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(const AndroidNotificationChannel(
      channelId,
      'Gebetsglas Erinnerungen',
      description: 'Tägliche Erinnerung an deine Gebetsanliegen',
      importance: Importance.high,
    ));
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    final androidImpl =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final granted = await androidImpl?.requestNotificationsPermission();
    return granted ?? false;
  }

  Future<void> cancelDaily() => _plugin.cancel(id: _notificationId);

  /// Plant die tägliche Benachrichtigung.
  /// Für jede ausgewählte Kategorie wird beim Planen ein zufälliges
  /// Anliegen ausgewählt; die Erinnerung öffnet beim Tippen die App.
  /// Liefert `false`, wenn das Planen fehlschlägt.
  Future<bool> scheduleDaily({
    required int hour,
    required int minute,
    required List<Category> categories,
    String? title,
  }) async {
    await cancelDaily();
    if (categories.isEmpty) return true;

    final db = AppDatabase.instance;
    final now = DateTime.now();
    var next = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute);
    final nowTz = tz.TZDateTime.now(tz.local);
    // Wurde genau um die gewählte Uhrzeit aktiviert (Zeitpunkt liegt in der
    // Vergangenheit oder weniger als 90 s in der Zukunft), startet die
    // Erinnerung am nächsten Tag. Sonst kann der Alarm nie (oder zu knapp)
    // ausgelöst werden.
    if (!next.isAfter(nowTz) ||
        next.difference(nowTz) < const Duration(seconds: 90)) {
      next = next.add(const Duration(days: 1));
    }
    await SettingsService.instance.setNextFire(next.millisecondsSinceEpoch);

    final lines = <String>[];
    for (var i = 0; i < categories.length; i++) {
      final cat = categories[i];
      final req = await db.drawRandom(categoryIds: [cat.id!]);
      final name = req?.name ?? '—';
      lines.add('${i + 1}. ${cat.name}: $name');
    }

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        'Gebetsglas Erinnerungen',
        channelDescription: 'Tägliche Erinnerung an deine Gebetsanliegen',
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(lines.join('\n')),
      ),
      iOS: DarwinNotificationDetails(),
    );

    // Exakter Alarm: USE_EXACT_ALARM ist automatisch erteilt, damit kommt
    // die Erinnerung auch im Energiesparmodus pünktlich. Nur wenn das fehlschlägt
    // (z.B. Gerät verweigert trotzdem), Fallback auf inexakt.
    try {
      await _plugin.zonedSchedule(
        id: _notificationId,
        title: title ?? 'Gebetsglas – Zeit zu beten',
        body: lines.join('\n'),
        scheduledDate: next,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {
      try {
        await _plugin.zonedSchedule(
          id: _notificationId,
          title: title ?? 'Gebetsglas – Zeit zu beten',
          body: lines.join('\n'),
          scheduledDate: next,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (_) {
        return false;
      }
    }
    return true;
  }

  /// Fragt die Berechtigung für exakte Alarme an (Android 12+).
  /// Öffnet bei Bedarf die Systemeinstellung „Alarme & Erinnerungen“.
  Future<bool> requestExactAlarmPermission() async {
    final androidImpl =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl == null) return true;
    if (await androidImpl.canScheduleExactNotifications() ?? false) return true;
    await androidImpl.requestExactAlarmsPermission();
    return await androidImpl.canScheduleExactNotifications() ?? false;
  }

  /// Sofortige Test-Benachrichtigung (prüft Berechtigung + Kanal).
  Future<void> sendTestNotification() async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        'Gebetsglas Erinnerungen',
        channelDescription: 'Tägliche Erinnerung an deine Gebetsanliegen',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.show(
      id: 4242,
      title: 'Gebetsglas – Test 🙏',
      body: 'Benachrichtigungen funktionieren.',
      notificationDetails: details,
    );
  }

  /// Für die Vorschau: ermittelt die aktuell geplanten Anliegen.
  Future<String> previewBody(List<Category> categories) async {
    final db = AppDatabase.instance;
    final lines = <String>[];
    for (var i = 0; i < categories.length; i++) {
      final cat = categories[i];
      final req = await db.drawRandom(categoryIds: [cat.id!]);
      lines.add('${i + 1}. ${cat.name}: ${req?.name ?? '—'}');
    }
    return lines.join('\n');
  }
}
