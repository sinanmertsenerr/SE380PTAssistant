class FirestorePaths {
  const FirestorePaths._();

  static String user(String uid) => 'users/$uid';
  static String programs(String uid) => 'users/$uid/programs';
  static String program(String uid, String id) => 'users/$uid/programs/$id';
  static String notes(String uid) => 'users/$uid/notes';
  static String note(String uid, String id) => 'users/$uid/notes/$id';
  static String chats(String uid) => 'users/$uid/chats';
  static String chat(String uid, String id) => 'users/$uid/chats/$id';
  static String chatMessages(String uid, String chatId) =>
      'users/$uid/chats/$chatId/messages';
  static String reminders(String uid) => 'users/$uid/reminders';
  static String reminder(String uid, String id) => 'users/$uid/reminders/$id';
  static String weights(String uid) => 'users/$uid/weights';
  static String workoutLogs(String uid) => 'users/$uid/workouts';
  static String fcmTokens(String uid) => 'users/$uid/fcmTokens';
  static String nudges(String uid) => 'users/$uid/nudges';
}
