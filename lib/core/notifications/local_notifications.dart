import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationsService {
  LocalNotificationsService();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );
    await _plugin.initialize(settings);
    _initialized = true;
  }

  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime when,
  }) async {
    await initialize();
    final scheduled = tz.TZDateTime.from(when, tz.local);
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminders',
            'Reminders',
            channelDescription: 'PTAssistant reminders',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e, st) {
      debugPrint('schedule reminder failed: $e\n$st');
    }
  }

  Future<void> cancel(int id) => _plugin.cancel(id);
}
