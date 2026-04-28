// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PTAssistant';

  @override
  String get common_continue => 'Continue';

  @override
  String get common_save => 'Save';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_done => 'Done';

  @override
  String get common_retry => 'Retry';

  @override
  String get common_close => 'Close';

  @override
  String get common_loading => 'Loading…';

  @override
  String get common_emptyTitle => 'Nothing here yet';

  @override
  String get common_search => 'Search';

  @override
  String get common_today => 'Today';

  @override
  String get common_yesterday => 'Yesterday';

  @override
  String get common_required => 'Required';

  @override
  String get common_optional => 'Optional';

  @override
  String get common_yes => 'Yes';

  @override
  String get common_no => 'No';

  @override
  String get common_dismiss => 'Dismiss';

  @override
  String get common_accept => 'Accept';

  @override
  String get common_back => 'Back';

  @override
  String get common_next => 'Next';

  @override
  String get common_finish => 'Finish';

  @override
  String get common_active => 'Active';

  @override
  String get common_chooseImage => 'Choose image';

  @override
  String get common_takePhoto => 'Take photo';

  @override
  String get common_chooseFromLibrary => 'Choose from library';

  @override
  String get common_remove => 'Remove';

  @override
  String get common_undo => 'Undo';

  @override
  String get auth_signInTitle => 'Welcome back';

  @override
  String get auth_signInSubtitle => 'Sign in to continue training';

  @override
  String get auth_signUpTitle => 'Create your account';

  @override
  String get auth_signUpSubtitle => 'Start your journey with PTAssistant';

  @override
  String get auth_email => 'Email';

  @override
  String get auth_password => 'Password';

  @override
  String get auth_signIn => 'Sign in';

  @override
  String get auth_signUp => 'Sign up';

  @override
  String get auth_signOut => 'Sign out';

  @override
  String get auth_googleSignIn => 'Continue with Google';

  @override
  String get auth_haveAccount => 'Already have an account?';

  @override
  String get auth_noAccount => 'No account yet?';

  @override
  String get auth_forgotPassword => 'Forgot your password?';

  @override
  String get auth_resetSent => 'Password reset email sent.';

  @override
  String get auth_invalidEmail => 'Enter a valid email address';

  @override
  String get auth_weakPassword => 'Password must be at least 6 characters';

  @override
  String get auth_genericError => 'Authentication failed. Please try again.';

  @override
  String get onboarding_title => 'Set up your profile';

  @override
  String get onboarding_step1Title => 'Who are you?';

  @override
  String get onboarding_step2Title => 'Body metrics';

  @override
  String get onboarding_step3Title => 'Goals & equipment';

  @override
  String get onboarding_firstName => 'First name';

  @override
  String get onboarding_lastName => 'Last name';

  @override
  String get onboarding_dob => 'Date of birth';

  @override
  String get onboarding_sex => 'Sex';

  @override
  String get onboarding_sexMale => 'Male';

  @override
  String get onboarding_sexFemale => 'Female';

  @override
  String get onboarding_sexOther => 'Other';

  @override
  String get onboarding_height => 'Height (cm)';

  @override
  String get onboarding_weight => 'Weight (kg)';

  @override
  String get onboarding_experience => 'Experience level';

  @override
  String get onboarding_expBeginner => 'Beginner';

  @override
  String get onboarding_expIntermediate => 'Intermediate';

  @override
  String get onboarding_expAdvanced => 'Advanced';

  @override
  String get onboarding_goals => 'Goals';

  @override
  String get onboarding_goalLoseFat => 'Lose fat';

  @override
  String get onboarding_goalBuildMuscle => 'Build muscle';

  @override
  String get onboarding_goalStrength => 'Get stronger';

  @override
  String get onboarding_goalEndurance => 'Endurance';

  @override
  String get onboarding_goalMobility => 'Mobility';

  @override
  String get onboarding_goalHealth => 'General health';

  @override
  String get onboarding_equipment => 'Equipment';

  @override
  String get onboarding_equipmentNone => 'Bodyweight only';

  @override
  String get onboarding_equipmentDumbbells => 'Dumbbells';

  @override
  String get onboarding_equipmentBarbell => 'Barbell';

  @override
  String get onboarding_equipmentMachines => 'Machines';

  @override
  String get onboarding_equipmentBands => 'Resistance bands';

  @override
  String get onboarding_equipmentGym => 'Full gym';

  @override
  String get onboarding_injuries => 'Injuries / limitations';

  @override
  String get onboarding_injuriesHint => 'e.g. left shoulder impingement';

  @override
  String get onboarding_weeklySessions => 'Weekly sessions';

  @override
  String get onboarding_finish => 'Finish setup';

  @override
  String get tabs_home => 'Home';

  @override
  String get tabs_programs => 'Programs';

  @override
  String get tabs_chat => 'AI';

  @override
  String get tabs_notes => 'Notes';

  @override
  String get tabs_profile => 'Profile';

  @override
  String home_greetingMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String home_greetingAfternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String home_greetingEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String get home_todaySession => 'Today\'s session';

  @override
  String get home_noActiveProgram => 'No active program yet';

  @override
  String get home_noActiveProgramHint =>
      'Ask the AI to build one or create your own.';

  @override
  String get home_startSession => 'Start session';

  @override
  String get home_resumeSession => 'Resume';

  @override
  String get home_streakLabel => 'Streak';

  @override
  String home_streakValue(int days) {
    return '$days days';
  }

  @override
  String get home_weeklyVolumeLabel => 'Weekly volume';

  @override
  String get home_weightTrendLabel => 'Weight trend';

  @override
  String get home_aiNudgeTitle => 'AI suggestion';

  @override
  String get home_aiNudgeNoneTitle => 'No new suggestion';

  @override
  String get home_aiNudgeNoneBody =>
      'Keep your notes updated and the AI will surface new ideas.';

  @override
  String get home_quickLogWeight => 'Log weight';

  @override
  String get home_quickNewNote => 'New note';

  @override
  String get home_quickAskAi => 'Ask AI';

  @override
  String get home_eyebrowToday => 'TODAY';

  @override
  String get home_eyebrowReady => 'READY WHEN YOU ARE';

  @override
  String home_dayOf(int n, int total) {
    return 'Day $n of $total';
  }

  @override
  String home_estDuration(int min) {
    return '~$min min';
  }

  @override
  String home_exerciseCount(int n) {
    return '$n exercises';
  }

  @override
  String get home_aiNudgeEyebrow => 'FOR YOU';

  @override
  String get home_noStreak => '—';

  @override
  String get home_noWeight => 'Log to track';

  @override
  String get home_noVolume => 'Start logging';

  @override
  String get home_streakUnit => 'DAY STREAK';

  @override
  String get home_volumeUnit => 'WEEKLY VOLUME';

  @override
  String get home_weightUnit => 'BODY WEIGHT';

  @override
  String get programs_title => 'Programs';

  @override
  String get programs_empty => 'No programs yet';

  @override
  String get programs_emptyHint =>
      'Generate one in the AI tab or create manually.';

  @override
  String get programs_createNew => 'New program';

  @override
  String get programs_renameDay => 'Day name';

  @override
  String get programs_discardTitle => 'Unsaved changes';

  @override
  String get programs_discardBody => 'Discard your edits?';

  @override
  String get programs_setActive => 'Set active';

  @override
  String get programs_duplicate => 'Duplicate';

  @override
  String get programs_active => 'Active';

  @override
  String get programs_sourceAi => 'AI generated';

  @override
  String get programs_sourceManual => 'Manual';

  @override
  String programs_dayLabel(int n) {
    return 'Day $n';
  }

  @override
  String programs_setsRepsRest(int sets, String reps, int rest) {
    return '$sets×$reps · ${rest}s rest';
  }

  @override
  String get programs_addedFromChat => 'Added to Programs.';

  @override
  String get programs_openInPrograms => 'Open';

  @override
  String programs_count(int n) {
    return '$n programs';
  }

  @override
  String get programs_countOne => '1 program';

  @override
  String get profile_editGoals => 'Edit goals';

  @override
  String programs_dayBadge(int n) {
    return '$n DAY';
  }

  @override
  String programs_dayBadgePlural(int n) {
    return '$n DAYS';
  }

  @override
  String get programs_filterAll => 'All';

  @override
  String get programs_filterActive => 'Active';

  @override
  String get programs_filterAi => 'AI';

  @override
  String get programs_filterManual => 'Manual';

  @override
  String get programs_searchHint => 'Find a program';

  @override
  String get programs_today => 'TODAY';

  @override
  String programs_estDuration(int min) {
    return '~$min MIN';
  }

  @override
  String programs_exerciseSets(int n) {
    return '$n EXERCISES';
  }

  @override
  String programs_setsRepsRestEditorial(int sets, String reps) {
    return '$sets × $reps';
  }

  @override
  String programs_restMeta(int rest) {
    return '${rest}s rest';
  }

  @override
  String get chat_title => 'AI';

  @override
  String get chat_inputHint => 'Ask anything…';

  @override
  String get chat_clearTitle => 'Clear chat';

  @override
  String get chat_clearBody =>
      'All messages will be removed. You can keep going from a fresh summary.';

  @override
  String get chat_clearAction => 'Clear chat';

  @override
  String get chat_clearOpeningPrompt =>
      'The chat has just been cleared. In the user\'s locale, briefly (2-3 sentences) sum up the current state — active program, top goals, any injuries — and ask one helpful follow-up question to keep training on track. No tool calls.';

  @override
  String get chat_starter1 => 'Build me a 4-day push/pull/legs program';

  @override
  String get chat_starter2 =>
      'I have left shoulder pain — adjust today\'s workout';

  @override
  String get chat_starter3 => 'Give me a 20-min warm-up routine';

  @override
  String get chat_starter4 => 'Plan my nutrition for a cut';

  @override
  String get chat_attach => 'Attach';

  @override
  String get chat_attachNote => 'Pick a note';

  @override
  String get chat_attachProgram => 'Pick a program';

  @override
  String get chat_offTopicReply =>
      'I can only help with training, recovery, and sports nutrition. Ask me about your workout instead.';

  @override
  String get chat_thinking => 'Thinking…';

  @override
  String get chat_toolProfileUpdated => 'Profile updated';

  @override
  String get chat_toolProgramCreated => 'Program created';

  @override
  String get chat_toolProgramUpdated => 'Program updated';

  @override
  String get chat_toolNoteCreated => 'Note created';

  @override
  String get chat_toolReminderScheduled => 'Reminder scheduled';

  @override
  String get chat_toolSourceLookup => 'Looked up sources';

  @override
  String get chat_sourcesLabel => 'Sources';

  @override
  String get chat_disclaimerInjury =>
      'Note: this is general guidance, not medical advice. Consult a doctor for persistent pain.';

  @override
  String get chat_aiLabel => 'PTAssistant';

  @override
  String get chat_aiTagline => 'Your personal training assistant';

  @override
  String get chat_attachLabel => 'Attach';

  @override
  String get notes_title => 'Notes';

  @override
  String get notes_search => 'Search notes';

  @override
  String get notes_empty => 'No notes yet';

  @override
  String get notes_emptyHint =>
      'Tap + to add your first note. The AI will read your notes when relevant.';

  @override
  String get notes_newNote => 'New note';

  @override
  String get notes_titleHint => 'Title';

  @override
  String get notes_bodyHint => 'Start writing in markdown…';

  @override
  String get notes_untitled => 'Untitled';

  @override
  String get notes_noPreview => 'No content yet';

  @override
  String get notes_pinnedSection => 'PINNED';

  @override
  String get notes_recentSection => 'RECENT';

  @override
  String notes_count(int n) {
    return '$n notes';
  }

  @override
  String get notes_countOne => '1 note';

  @override
  String get notes_pinned => 'Pinned';

  @override
  String get notes_pin => 'Pin';

  @override
  String get notes_unpin => 'Unpin';

  @override
  String get notes_tags => 'Tags';

  @override
  String get notes_preview => 'Preview';

  @override
  String get notes_edit => 'Edit';

  @override
  String get notes_deleteConfirm => 'Delete this note?';

  @override
  String get profile_title => 'Profile';

  @override
  String get profile_editPhoto => 'Change photo';

  @override
  String get profile_settings => 'Settings';

  @override
  String get profile_appearance => 'Appearance';

  @override
  String get profile_language => 'Language';

  @override
  String get profile_themeMode => 'Theme';

  @override
  String get profile_themeSystem => 'System';

  @override
  String get profile_themeLight => 'Light';

  @override
  String get profile_themeDark => 'Dark';

  @override
  String get profile_languageTr => 'Türkçe';

  @override
  String get profile_languageEn => 'English';

  @override
  String get profile_notifications => 'Notifications';

  @override
  String get profile_notificationsEnabled => 'Enable notifications';

  @override
  String get profile_account => 'Account';

  @override
  String get profile_deleteAccount => 'Delete account';

  @override
  String get profile_deleteConfirmTitle => 'Delete account?';

  @override
  String get profile_deleteConfirmBody =>
      'This permanently removes your profile, programs, notes and chats.';

  @override
  String get profile_eyebrowAthlete => 'ATHLETE';

  @override
  String get profile_metricsTitle => 'BODY METRICS';

  @override
  String get profile_goalsTitle => 'GOALS';

  @override
  String get profile_injuriesTitle => 'INJURIES & LIMITATIONS';

  @override
  String get profile_addInjury => 'Add';

  @override
  String get profile_metricCm => 'cm';

  @override
  String get profile_metricKg => 'kg';

  @override
  String get profile_metricSessionsPerWeek => 'sessions / week';

  @override
  String get profile_noGoals => 'No goals set';

  @override
  String get profile_noInjuries => 'None reported';

  @override
  String get errors_generic => 'Something went wrong.';

  @override
  String get errors_offline => 'You appear to be offline.';

  @override
  String get errors_permission => 'Permission denied.';
}
