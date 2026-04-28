import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PTAssistant'**
  String get appTitle;

  /// No description provided for @common_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get common_continue;

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;

  /// No description provided for @common_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get common_edit;

  /// No description provided for @common_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get common_done;

  /// No description provided for @common_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// No description provided for @common_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get common_close;

  /// No description provided for @common_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get common_loading;

  /// No description provided for @common_emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get common_emptyTitle;

  /// No description provided for @common_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get common_search;

  /// No description provided for @common_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get common_today;

  /// No description provided for @common_yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get common_yesterday;

  /// No description provided for @common_required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get common_required;

  /// No description provided for @common_optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get common_optional;

  /// No description provided for @common_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get common_yes;

  /// No description provided for @common_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get common_no;

  /// No description provided for @common_dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get common_dismiss;

  /// No description provided for @common_accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get common_accept;

  /// No description provided for @common_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get common_back;

  /// No description provided for @common_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get common_next;

  /// No description provided for @common_finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get common_finish;

  /// No description provided for @common_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get common_active;

  /// No description provided for @common_chooseImage.
  ///
  /// In en, this message translates to:
  /// **'Choose image'**
  String get common_chooseImage;

  /// No description provided for @common_takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get common_takePhoto;

  /// No description provided for @common_chooseFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Choose from library'**
  String get common_chooseFromLibrary;

  /// No description provided for @common_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get common_remove;

  /// No description provided for @common_undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get common_undo;

  /// No description provided for @auth_signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get auth_signInTitle;

  /// No description provided for @auth_signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue training'**
  String get auth_signInSubtitle;

  /// No description provided for @auth_signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get auth_signUpTitle;

  /// No description provided for @auth_signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your journey with PTAssistant'**
  String get auth_signUpSubtitle;

  /// No description provided for @auth_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get auth_email;

  /// No description provided for @auth_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_password;

  /// No description provided for @auth_signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get auth_signIn;

  /// No description provided for @auth_signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get auth_signUp;

  /// No description provided for @auth_signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get auth_signOut;

  /// No description provided for @auth_googleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get auth_googleSignIn;

  /// No description provided for @auth_haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get auth_haveAccount;

  /// No description provided for @auth_noAccount.
  ///
  /// In en, this message translates to:
  /// **'No account yet?'**
  String get auth_noAccount;

  /// No description provided for @auth_forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get auth_forgotPassword;

  /// No description provided for @auth_resetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent.'**
  String get auth_resetSent;

  /// No description provided for @auth_invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get auth_invalidEmail;

  /// No description provided for @auth_weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get auth_weakPassword;

  /// No description provided for @auth_genericError.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get auth_genericError;

  /// No description provided for @onboarding_title.
  ///
  /// In en, this message translates to:
  /// **'Set up your profile'**
  String get onboarding_title;

  /// No description provided for @onboarding_step1Title.
  ///
  /// In en, this message translates to:
  /// **'Who are you?'**
  String get onboarding_step1Title;

  /// No description provided for @onboarding_step2Title.
  ///
  /// In en, this message translates to:
  /// **'Body metrics'**
  String get onboarding_step2Title;

  /// No description provided for @onboarding_step3Title.
  ///
  /// In en, this message translates to:
  /// **'Goals & equipment'**
  String get onboarding_step3Title;

  /// No description provided for @onboarding_firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get onboarding_firstName;

  /// No description provided for @onboarding_lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get onboarding_lastName;

  /// No description provided for @onboarding_dob.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get onboarding_dob;

  /// No description provided for @onboarding_sex.
  ///
  /// In en, this message translates to:
  /// **'Sex'**
  String get onboarding_sex;

  /// No description provided for @onboarding_sexMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get onboarding_sexMale;

  /// No description provided for @onboarding_sexFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get onboarding_sexFemale;

  /// No description provided for @onboarding_sexOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get onboarding_sexOther;

  /// No description provided for @onboarding_height.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get onboarding_height;

  /// No description provided for @onboarding_weight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get onboarding_weight;

  /// No description provided for @onboarding_experience.
  ///
  /// In en, this message translates to:
  /// **'Experience level'**
  String get onboarding_experience;

  /// No description provided for @onboarding_expBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get onboarding_expBeginner;

  /// No description provided for @onboarding_expIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get onboarding_expIntermediate;

  /// No description provided for @onboarding_expAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get onboarding_expAdvanced;

  /// No description provided for @onboarding_goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get onboarding_goals;

  /// No description provided for @onboarding_goalLoseFat.
  ///
  /// In en, this message translates to:
  /// **'Lose fat'**
  String get onboarding_goalLoseFat;

  /// No description provided for @onboarding_goalBuildMuscle.
  ///
  /// In en, this message translates to:
  /// **'Build muscle'**
  String get onboarding_goalBuildMuscle;

  /// No description provided for @onboarding_goalStrength.
  ///
  /// In en, this message translates to:
  /// **'Get stronger'**
  String get onboarding_goalStrength;

  /// No description provided for @onboarding_goalEndurance.
  ///
  /// In en, this message translates to:
  /// **'Endurance'**
  String get onboarding_goalEndurance;

  /// No description provided for @onboarding_goalMobility.
  ///
  /// In en, this message translates to:
  /// **'Mobility'**
  String get onboarding_goalMobility;

  /// No description provided for @onboarding_goalHealth.
  ///
  /// In en, this message translates to:
  /// **'General health'**
  String get onboarding_goalHealth;

  /// No description provided for @onboarding_equipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get onboarding_equipment;

  /// No description provided for @onboarding_equipmentNone.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight only'**
  String get onboarding_equipmentNone;

  /// No description provided for @onboarding_equipmentDumbbells.
  ///
  /// In en, this message translates to:
  /// **'Dumbbells'**
  String get onboarding_equipmentDumbbells;

  /// No description provided for @onboarding_equipmentBarbell.
  ///
  /// In en, this message translates to:
  /// **'Barbell'**
  String get onboarding_equipmentBarbell;

  /// No description provided for @onboarding_equipmentMachines.
  ///
  /// In en, this message translates to:
  /// **'Machines'**
  String get onboarding_equipmentMachines;

  /// No description provided for @onboarding_equipmentBands.
  ///
  /// In en, this message translates to:
  /// **'Resistance bands'**
  String get onboarding_equipmentBands;

  /// No description provided for @onboarding_equipmentGym.
  ///
  /// In en, this message translates to:
  /// **'Full gym'**
  String get onboarding_equipmentGym;

  /// No description provided for @onboarding_injuries.
  ///
  /// In en, this message translates to:
  /// **'Injuries / limitations'**
  String get onboarding_injuries;

  /// No description provided for @onboarding_injuriesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. left shoulder impingement'**
  String get onboarding_injuriesHint;

  /// No description provided for @onboarding_weeklySessions.
  ///
  /// In en, this message translates to:
  /// **'Weekly sessions'**
  String get onboarding_weeklySessions;

  /// No description provided for @onboarding_finish.
  ///
  /// In en, this message translates to:
  /// **'Finish setup'**
  String get onboarding_finish;

  /// No description provided for @tabs_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabs_home;

  /// No description provided for @tabs_programs.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get tabs_programs;

  /// No description provided for @tabs_chat.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get tabs_chat;

  /// No description provided for @tabs_notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get tabs_notes;

  /// No description provided for @tabs_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabs_profile;

  /// No description provided for @home_greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String home_greetingMorning(String name);

  /// No description provided for @home_greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String home_greetingAfternoon(String name);

  /// No description provided for @home_greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String home_greetingEvening(String name);

  /// No description provided for @home_todaySession.
  ///
  /// In en, this message translates to:
  /// **'Today\'s session'**
  String get home_todaySession;

  /// No description provided for @home_noActiveProgram.
  ///
  /// In en, this message translates to:
  /// **'No active program yet'**
  String get home_noActiveProgram;

  /// No description provided for @home_noActiveProgramHint.
  ///
  /// In en, this message translates to:
  /// **'Ask the AI to build one or create your own.'**
  String get home_noActiveProgramHint;

  /// No description provided for @home_startSession.
  ///
  /// In en, this message translates to:
  /// **'Start session'**
  String get home_startSession;

  /// No description provided for @home_resumeSession.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get home_resumeSession;

  /// No description provided for @home_streakLabel.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get home_streakLabel;

  /// No description provided for @home_streakValue.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String home_streakValue(int days);

  /// No description provided for @home_weeklyVolumeLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly volume'**
  String get home_weeklyVolumeLabel;

  /// No description provided for @home_weightTrendLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight trend'**
  String get home_weightTrendLabel;

  /// No description provided for @home_aiNudgeTitle.
  ///
  /// In en, this message translates to:
  /// **'AI suggestion'**
  String get home_aiNudgeTitle;

  /// No description provided for @home_aiNudgeNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No new suggestion'**
  String get home_aiNudgeNoneTitle;

  /// No description provided for @home_aiNudgeNoneBody.
  ///
  /// In en, this message translates to:
  /// **'Keep your notes updated and the AI will surface new ideas.'**
  String get home_aiNudgeNoneBody;

  /// No description provided for @home_quickLogWeight.
  ///
  /// In en, this message translates to:
  /// **'Log weight'**
  String get home_quickLogWeight;

  /// No description provided for @home_quickNewNote.
  ///
  /// In en, this message translates to:
  /// **'New note'**
  String get home_quickNewNote;

  /// No description provided for @home_quickAskAi.
  ///
  /// In en, this message translates to:
  /// **'Ask AI'**
  String get home_quickAskAi;

  /// No description provided for @home_eyebrowToday.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get home_eyebrowToday;

  /// No description provided for @home_eyebrowReady.
  ///
  /// In en, this message translates to:
  /// **'READY WHEN YOU ARE'**
  String get home_eyebrowReady;

  /// No description provided for @home_dayOf.
  ///
  /// In en, this message translates to:
  /// **'Day {n} of {total}'**
  String home_dayOf(int n, int total);

  /// No description provided for @home_estDuration.
  ///
  /// In en, this message translates to:
  /// **'~{min} min'**
  String home_estDuration(int min);

  /// No description provided for @home_exerciseCount.
  ///
  /// In en, this message translates to:
  /// **'{n} exercises'**
  String home_exerciseCount(int n);

  /// No description provided for @home_aiNudgeEyebrow.
  ///
  /// In en, this message translates to:
  /// **'FOR YOU'**
  String get home_aiNudgeEyebrow;

  /// No description provided for @home_noStreak.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get home_noStreak;

  /// No description provided for @home_noWeight.
  ///
  /// In en, this message translates to:
  /// **'Log to track'**
  String get home_noWeight;

  /// No description provided for @home_noVolume.
  ///
  /// In en, this message translates to:
  /// **'Start logging'**
  String get home_noVolume;

  /// No description provided for @home_streakUnit.
  ///
  /// In en, this message translates to:
  /// **'DAY STREAK'**
  String get home_streakUnit;

  /// No description provided for @home_volumeUnit.
  ///
  /// In en, this message translates to:
  /// **'WEEKLY VOLUME'**
  String get home_volumeUnit;

  /// No description provided for @home_weightUnit.
  ///
  /// In en, this message translates to:
  /// **'BODY WEIGHT'**
  String get home_weightUnit;

  /// No description provided for @programs_title.
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get programs_title;

  /// No description provided for @programs_empty.
  ///
  /// In en, this message translates to:
  /// **'No programs yet'**
  String get programs_empty;

  /// No description provided for @programs_emptyHint.
  ///
  /// In en, this message translates to:
  /// **'Generate one in the AI tab or create manually.'**
  String get programs_emptyHint;

  /// No description provided for @programs_createNew.
  ///
  /// In en, this message translates to:
  /// **'New program'**
  String get programs_createNew;

  /// No description provided for @programs_setActive.
  ///
  /// In en, this message translates to:
  /// **'Set active'**
  String get programs_setActive;

  /// No description provided for @programs_duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get programs_duplicate;

  /// No description provided for @programs_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get programs_active;

  /// No description provided for @programs_sourceAi.
  ///
  /// In en, this message translates to:
  /// **'AI generated'**
  String get programs_sourceAi;

  /// No description provided for @programs_sourceManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get programs_sourceManual;

  /// No description provided for @programs_dayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day {n}'**
  String programs_dayLabel(int n);

  /// No description provided for @programs_setsRepsRest.
  ///
  /// In en, this message translates to:
  /// **'{sets}×{reps} · {rest}s rest'**
  String programs_setsRepsRest(int sets, String reps, int rest);

  /// No description provided for @programs_addedFromChat.
  ///
  /// In en, this message translates to:
  /// **'Added to Programs.'**
  String get programs_addedFromChat;

  /// No description provided for @programs_openInPrograms.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get programs_openInPrograms;

  /// No description provided for @programs_count.
  ///
  /// In en, this message translates to:
  /// **'{n} programs'**
  String programs_count(int n);

  /// No description provided for @programs_countOne.
  ///
  /// In en, this message translates to:
  /// **'1 program'**
  String get programs_countOne;

  /// No description provided for @profile_editGoals.
  ///
  /// In en, this message translates to:
  /// **'Edit goals'**
  String get profile_editGoals;

  /// No description provided for @programs_dayBadge.
  ///
  /// In en, this message translates to:
  /// **'{n} DAY'**
  String programs_dayBadge(int n);

  /// No description provided for @programs_dayBadgePlural.
  ///
  /// In en, this message translates to:
  /// **'{n} DAYS'**
  String programs_dayBadgePlural(int n);

  /// No description provided for @programs_filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get programs_filterAll;

  /// No description provided for @programs_filterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get programs_filterActive;

  /// No description provided for @programs_filterAi.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get programs_filterAi;

  /// No description provided for @programs_filterManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get programs_filterManual;

  /// No description provided for @programs_searchHint.
  ///
  /// In en, this message translates to:
  /// **'Find a program'**
  String get programs_searchHint;

  /// No description provided for @programs_today.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get programs_today;

  /// No description provided for @programs_estDuration.
  ///
  /// In en, this message translates to:
  /// **'~{min} MIN'**
  String programs_estDuration(int min);

  /// No description provided for @programs_exerciseSets.
  ///
  /// In en, this message translates to:
  /// **'{n} EXERCISES'**
  String programs_exerciseSets(int n);

  /// No description provided for @programs_setsRepsRestEditorial.
  ///
  /// In en, this message translates to:
  /// **'{sets} × {reps}'**
  String programs_setsRepsRestEditorial(int sets, String reps);

  /// No description provided for @programs_restMeta.
  ///
  /// In en, this message translates to:
  /// **'{rest}s rest'**
  String programs_restMeta(int rest);

  /// No description provided for @chat_title.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get chat_title;

  /// No description provided for @chat_inputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about your training…'**
  String get chat_inputHint;

  /// No description provided for @chat_clearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear chat'**
  String get chat_clearTitle;

  /// No description provided for @chat_clearBody.
  ///
  /// In en, this message translates to:
  /// **'All messages will be removed. You can keep going from a fresh summary.'**
  String get chat_clearBody;

  /// No description provided for @chat_clearAction.
  ///
  /// In en, this message translates to:
  /// **'Clear chat'**
  String get chat_clearAction;

  /// No description provided for @chat_clearOpeningPrompt.
  ///
  /// In en, this message translates to:
  /// **'The chat has just been cleared. In the user\'s locale, briefly (2-3 sentences) sum up the current state — active program, top goals, any injuries — and ask one helpful follow-up question to keep training on track. No tool calls.'**
  String get chat_clearOpeningPrompt;

  /// No description provided for @chat_starter1.
  ///
  /// In en, this message translates to:
  /// **'Build me a 4-day push/pull/legs program'**
  String get chat_starter1;

  /// No description provided for @chat_starter2.
  ///
  /// In en, this message translates to:
  /// **'I have left shoulder pain — adjust today\'s workout'**
  String get chat_starter2;

  /// No description provided for @chat_starter3.
  ///
  /// In en, this message translates to:
  /// **'Give me a 20-min warm-up routine'**
  String get chat_starter3;

  /// No description provided for @chat_starter4.
  ///
  /// In en, this message translates to:
  /// **'Plan my nutrition for a cut'**
  String get chat_starter4;

  /// No description provided for @chat_attach.
  ///
  /// In en, this message translates to:
  /// **'Attach'**
  String get chat_attach;

  /// No description provided for @chat_attachNote.
  ///
  /// In en, this message translates to:
  /// **'Pick a note'**
  String get chat_attachNote;

  /// No description provided for @chat_attachProgram.
  ///
  /// In en, this message translates to:
  /// **'Pick a program'**
  String get chat_attachProgram;

  /// No description provided for @chat_offTopicReply.
  ///
  /// In en, this message translates to:
  /// **'I can only help with training, recovery, and sports nutrition. Ask me about your workout instead.'**
  String get chat_offTopicReply;

  /// No description provided for @chat_thinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking…'**
  String get chat_thinking;

  /// No description provided for @chat_toolProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get chat_toolProfileUpdated;

  /// No description provided for @chat_toolProgramCreated.
  ///
  /// In en, this message translates to:
  /// **'Program created'**
  String get chat_toolProgramCreated;

  /// No description provided for @chat_toolProgramUpdated.
  ///
  /// In en, this message translates to:
  /// **'Program updated'**
  String get chat_toolProgramUpdated;

  /// No description provided for @chat_toolNoteCreated.
  ///
  /// In en, this message translates to:
  /// **'Note created'**
  String get chat_toolNoteCreated;

  /// No description provided for @chat_toolReminderScheduled.
  ///
  /// In en, this message translates to:
  /// **'Reminder scheduled'**
  String get chat_toolReminderScheduled;

  /// No description provided for @chat_toolSourceLookup.
  ///
  /// In en, this message translates to:
  /// **'Looked up sources'**
  String get chat_toolSourceLookup;

  /// No description provided for @chat_sourcesLabel.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get chat_sourcesLabel;

  /// No description provided for @chat_disclaimerInjury.
  ///
  /// In en, this message translates to:
  /// **'Note: this is general guidance, not medical advice. Consult a doctor for persistent pain.'**
  String get chat_disclaimerInjury;

  /// No description provided for @chat_aiLabel.
  ///
  /// In en, this message translates to:
  /// **'PTAssistant'**
  String get chat_aiLabel;

  /// No description provided for @chat_aiTagline.
  ///
  /// In en, this message translates to:
  /// **'Your personal training assistant'**
  String get chat_aiTagline;

  /// No description provided for @chat_attachLabel.
  ///
  /// In en, this message translates to:
  /// **'Attach'**
  String get chat_attachLabel;

  /// No description provided for @notes_title.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes_title;

  /// No description provided for @notes_search.
  ///
  /// In en, this message translates to:
  /// **'Search notes'**
  String get notes_search;

  /// No description provided for @notes_empty.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get notes_empty;

  /// No description provided for @notes_emptyHint.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first note. The AI will read your notes when relevant.'**
  String get notes_emptyHint;

  /// No description provided for @notes_newNote.
  ///
  /// In en, this message translates to:
  /// **'New note'**
  String get notes_newNote;

  /// No description provided for @notes_titleHint.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get notes_titleHint;

  /// No description provided for @notes_bodyHint.
  ///
  /// In en, this message translates to:
  /// **'Start writing in markdown…'**
  String get notes_bodyHint;

  /// No description provided for @notes_untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get notes_untitled;

  /// No description provided for @notes_noPreview.
  ///
  /// In en, this message translates to:
  /// **'No content yet'**
  String get notes_noPreview;

  /// No description provided for @notes_pinnedSection.
  ///
  /// In en, this message translates to:
  /// **'PINNED'**
  String get notes_pinnedSection;

  /// No description provided for @notes_recentSection.
  ///
  /// In en, this message translates to:
  /// **'RECENT'**
  String get notes_recentSection;

  /// No description provided for @notes_count.
  ///
  /// In en, this message translates to:
  /// **'{n} notes'**
  String notes_count(int n);

  /// No description provided for @notes_countOne.
  ///
  /// In en, this message translates to:
  /// **'1 note'**
  String get notes_countOne;

  /// No description provided for @notes_pinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get notes_pinned;

  /// No description provided for @notes_pin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get notes_pin;

  /// No description provided for @notes_unpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get notes_unpin;

  /// No description provided for @notes_tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get notes_tags;

  /// No description provided for @notes_preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get notes_preview;

  /// No description provided for @notes_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get notes_edit;

  /// No description provided for @notes_deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this note?'**
  String get notes_deleteConfirm;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @profile_editPhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get profile_editPhoto;

  /// No description provided for @profile_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profile_settings;

  /// No description provided for @profile_appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profile_appearance;

  /// No description provided for @profile_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profile_language;

  /// No description provided for @profile_themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get profile_themeMode;

  /// No description provided for @profile_themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get profile_themeSystem;

  /// No description provided for @profile_themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get profile_themeLight;

  /// No description provided for @profile_themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get profile_themeDark;

  /// No description provided for @profile_languageTr.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get profile_languageTr;

  /// No description provided for @profile_languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get profile_languageEn;

  /// No description provided for @profile_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profile_notifications;

  /// No description provided for @profile_notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get profile_notificationsEnabled;

  /// No description provided for @profile_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profile_account;

  /// No description provided for @profile_deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get profile_deleteAccount;

  /// No description provided for @profile_deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get profile_deleteConfirmTitle;

  /// No description provided for @profile_deleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes your profile, programs, notes and chats.'**
  String get profile_deleteConfirmBody;

  /// No description provided for @profile_eyebrowAthlete.
  ///
  /// In en, this message translates to:
  /// **'ATHLETE'**
  String get profile_eyebrowAthlete;

  /// No description provided for @profile_metricsTitle.
  ///
  /// In en, this message translates to:
  /// **'BODY METRICS'**
  String get profile_metricsTitle;

  /// No description provided for @profile_goalsTitle.
  ///
  /// In en, this message translates to:
  /// **'GOALS'**
  String get profile_goalsTitle;

  /// No description provided for @profile_injuriesTitle.
  ///
  /// In en, this message translates to:
  /// **'INJURIES & LIMITATIONS'**
  String get profile_injuriesTitle;

  /// No description provided for @profile_addInjury.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get profile_addInjury;

  /// No description provided for @profile_metricCm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get profile_metricCm;

  /// No description provided for @profile_metricKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get profile_metricKg;

  /// No description provided for @profile_metricSessionsPerWeek.
  ///
  /// In en, this message translates to:
  /// **'sessions / week'**
  String get profile_metricSessionsPerWeek;

  /// No description provided for @profile_noGoals.
  ///
  /// In en, this message translates to:
  /// **'No goals set'**
  String get profile_noGoals;

  /// No description provided for @profile_noInjuries.
  ///
  /// In en, this message translates to:
  /// **'None reported'**
  String get profile_noInjuries;

  /// No description provided for @errors_generic.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get errors_generic;

  /// No description provided for @errors_offline.
  ///
  /// In en, this message translates to:
  /// **'You appear to be offline.'**
  String get errors_offline;

  /// No description provided for @errors_permission.
  ///
  /// In en, this message translates to:
  /// **'Permission denied.'**
  String get errors_permission;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
