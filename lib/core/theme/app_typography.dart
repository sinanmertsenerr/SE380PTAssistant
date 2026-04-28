import 'package:flutter/material.dart';

class AppTypography {
  const AppTypography._();

  static TextTheme textTheme(ColorScheme cs) {
    final base = Typography.material2021(platform: TargetPlatform.iOS).black;
    final colored = base.apply(
      bodyColor: cs.onSurface,
      displayColor: cs.onSurface,
    );
    return colored.copyWith(
      displayLarge: colored.displayLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
      ),
      displayMedium: colored.displayMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
      ),
      displaySmall: colored.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
      ),
      headlineLarge: colored.headlineLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.7,
      ),
      headlineMedium: colored.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineSmall: colored.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleLarge: colored.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: colored.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleSmall: colored.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: colored.bodyLarge?.copyWith(height: 1.4),
      bodyMedium: colored.bodyMedium?.copyWith(height: 1.4),
      labelLarge: colored.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
