import 'local_notifications.dart';

/// Schedules local "come back" notifications a few days in the future.
///
/// Called on every app open/resume: each call re-schedules the same fixed
/// notification ids, so as long as the user keeps using the app the
/// notifications keep moving forward and never fire. They only fire after
/// the user has stayed away long enough. No server involved.
class InactivityNudgeService {
  InactivityNudgeService(this._notifications);

  final LocalNotificationsService _notifications;

  /// TEST SWITCH: set to true and the nudges fire 30/60/90 SECONDS from now
  /// instead of 3/5/7 days at 19:00. Set back to false before shipping.
  static const testMode = false;

  // Reserved id range; reminder notifications use Firestore-id hashes.
  static const _ids = [910001, 910002, 910003];
  static const _days = [3, 5, 7];
  static const _testSeconds = [30, 60, 90];
  static const _fireHour = 19;

  static const _titles = {
    'tr': 'Antrenman seni bekliyor 💪',
    'en': 'Your workout is waiting 💪',
  };

  static const _bodies = {
    'tr': [
      'Birkaç gündür görüşemedik! Kısa bir antrenman bile fark yaratır.',
      '5 gün oldu... Hedeflerin hâlâ seni bekliyor. Bugün küçük bir adım at!',
      'Bir hafta ara verdin. Geri dönmek için harika bir gün — programın hazır!',
    ],
    'en': [
      "We haven't seen you in a few days! Even a short workout makes a difference.",
      "It's been 5 days... Your goals are still waiting. Take a small step today!",
      'You took a week off. Great day to get back — your program is ready!',
    ],
  };

  Future<void> reschedule({required String languageCode}) async {
    final lang = languageCode == 'tr' ? 'tr' : 'en';
    final title = _titles[lang]!;
    final bodies = _bodies[lang]!;
    final now = DateTime.now();
    final today7pm = DateTime(now.year, now.month, now.day, _fireHour);
    for (var i = 0; i < _ids.length; i++) {
      await _notifications.cancel(_ids[i]);
      await _notifications.schedule(
        id: _ids[i],
        title: title,
        body: bodies[i],
        when: testMode
            ? now.add(Duration(seconds: _testSeconds[i]))
            : today7pm.add(Duration(days: _days[i])),
      );
    }
  }

  Future<void> cancelAll() async {
    for (final id in _ids) {
      await _notifications.cancel(id);
    }
  }
}
