PTASSISTANT - SE 380 Project
============================

PTAssistant is an AI personal trainer app built with Flutter. You chat with an
AI coach that already knows your profile (body metrics, goals, equipment and
injuries) and it builds, edits and activates personal workout programs for you
just by talking, in English or Turkish. You can also build programs by hand,
run guided workout sessions, keep training notes and get a short daily AI tip
on the home screen. The backend is Firebase (Authentication, Cloud Firestore,
Storage, Cloud Messaging and App Check) and the AI coach runs on Google Gemini
through the Firebase AI package.

Video: [PASTE YOUR YOUTUBE URL HERE]

Flutter version used: Flutter 3.41.6 (stable channel), Dart 3.11.4


HOW TO RUN THE PROJECT
----------------------

1. Install Flutter (stable channel) by following the official guide:
   https://docs.flutter.dev/get-started/install
   Run "flutter doctor" and make sure Android reports no problems.

2. Extract the project zip file to a folder.

3. Open the extracted folder with Android Studio (File > Open) or Visual
   Studio Code (File > Open Folder). Open the folder that contains the
   pubspec.yaml file.

4. Open a terminal in the project folder and run:

   flutter pub get

   This downloads all the packages the project uses.

5. Start an Android emulator, or connect a real Android phone with USB
   debugging turned on. The app is portrait only and was tested on Android.

6. Run the app:

   flutter run

   The first build can take a few minutes.

7. When the app opens, tap "Sign Up" and create an account with any email and
   a password of at least 6 characters. Then go through the 3 step onboarding
   (your info, body metrics, goals and equipment). After that you can use
   everything: Home, Programs, AI Coach, Notes and Profile.


NOTES
-----

- The Firebase configuration is already included in the project
  (lib/firebase_options.dart and android/app/google-services.json), so you do
  not need to set up any backend. The app connects to my live Firebase project.

- An internet connection is required, because all data is stored in Firebase
  and the AI coach calls Google Gemini online through Firebase AI.

- The AI coach does not need any API key from you. It runs through the Firebase
  project that ships with the app.

- On Android 13 and newer the app asks for notification permission the first
  time you sign in. This is used for scheduled reminders and the automatic
  "come back" nudges.

- The app passes static analysis with no issues (flutter analyze) and all 39
  tests pass (flutter test).


YouTube video URL: [PASTE YOUR YOUTUBE URL HERE]
