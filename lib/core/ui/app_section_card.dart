import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import 'app_card.dart';
import 'app_eyebrow.dart';

class AppSectionCard extends StatelessWidget {
  const AppSectionCard({
    required this.eyebrow,
    required this.child,
    this.trailing,
    super.key,
  });

  final String eyebrow;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md + 2,
        AppSpacing.md,
        AppSpacing.md + 2,
        AppSpacing.md + 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: AppEyebrow(eyebrow, letterSpacing: 1.6)),
              ?trailing,
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}
