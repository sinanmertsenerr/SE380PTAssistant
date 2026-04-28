import 'package:flutter/material.dart';

class AppEyebrow extends StatelessWidget {
  const AppEyebrow(
    this.text, {
    this.letterSpacing = 1.4,
    this.fontWeight = FontWeight.w800,
    super.key,
  });

  final String text;
  final double letterSpacing;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
