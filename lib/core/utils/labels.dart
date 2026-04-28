import '../../l10n/app_localizations.dart';
import '../models/user_profile.dart';

String goalLabel(AppLocalizations l, FitnessGoal g) => switch (g) {
  FitnessGoal.loseFat => l.onboarding_goalLoseFat,
  FitnessGoal.buildMuscle => l.onboarding_goalBuildMuscle,
  FitnessGoal.strength => l.onboarding_goalStrength,
  FitnessGoal.endurance => l.onboarding_goalEndurance,
  FitnessGoal.mobility => l.onboarding_goalMobility,
  FitnessGoal.health => l.onboarding_goalHealth,
};

String equipmentLabel(AppLocalizations l, Equipment e) => switch (e) {
  Equipment.bodyweight => l.onboarding_equipmentNone,
  Equipment.dumbbells => l.onboarding_equipmentDumbbells,
  Equipment.barbell => l.onboarding_equipmentBarbell,
  Equipment.machines => l.onboarding_equipmentMachines,
  Equipment.bands => l.onboarding_equipmentBands,
  Equipment.fullGym => l.onboarding_equipmentGym,
};

String experienceLabel(AppLocalizations l, ExperienceLevel x) => switch (x) {
  ExperienceLevel.beginner => l.onboarding_expBeginner,
  ExperienceLevel.intermediate => l.onboarding_expIntermediate,
  ExperienceLevel.advanced => l.onboarding_expAdvanced,
};

String sexLabel(AppLocalizations l, Sex s) => switch (s) {
  Sex.male => l.onboarding_sexMale,
  Sex.female => l.onboarding_sexFemale,
  Sex.other => l.onboarding_sexOther,
};
