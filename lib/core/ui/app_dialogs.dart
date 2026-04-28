import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_spacing.dart';

Future<bool> showAppConfirm(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final l10n = AppLocalizations.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      return _AppDialogShell(
        title: title,
        body: body,
        primary: FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: _primaryStyle(theme, destructive: destructive),
          child: Text(confirmLabel),
        ),
        secondaryLabel: l10n.common_cancel,
        onSecondary: () => Navigator.pop(ctx, false),
      );
    },
  );
  return result ?? false;
}

Future<String?> showAppPrompt(
  BuildContext context, {
  required String title,
  String? body,
  String? hint,
  String initial = '',
  TextInputType? keyboardType,
  required String saveLabel,
}) async {
  final l10n = AppLocalizations.of(context);
  final ctrl = TextEditingController(text: initial);
  try {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return _AppDialogShell(
          title: title,
          body: body,
          field: TextField(
            controller: ctrl,
            autofocus: true,
            keyboardType: keyboardType,
            textInputAction: TextInputAction.done,
            onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
            decoration: InputDecoration(hintText: hint),
          ),
          primary: FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            style: _primaryStyle(theme),
            child: Text(saveLabel),
          ),
          secondaryLabel: l10n.common_cancel,
          onSecondary: () => Navigator.pop(ctx),
        );
      },
    );
    if (result == null || result.isEmpty) return null;
    return result;
  } finally {
    ctrl.dispose();
  }
}

class _AppDialogShell extends StatelessWidget {
  const _AppDialogShell({
    required this.title,
    required this.primary,
    required this.secondaryLabel,
    required this.onSecondary,
    this.body,
    this.field,
  });

  final String title;
  final String? body;
  final Widget? field;
  final Widget primary;
  final String secondaryLabel;
  final VoidCallback onSecondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXLarge),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
            if (body != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                body!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
            ],
            if (field != null) ...[
              const SizedBox(height: AppSpacing.md),
              field!,
            ],
            const SizedBox(height: AppSpacing.lg),
            primary,
            const SizedBox(height: 4),
            TextButton(
              onPressed: onSecondary,
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurfaceVariant,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              child: Text(secondaryLabel),
            ),
          ],
        ),
      ),
    );
  }
}

ButtonStyle _primaryStyle(ThemeData theme, {bool destructive = false}) {
  return FilledButton.styleFrom(
    backgroundColor: destructive ? theme.colorScheme.error : null,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
    ),
    textStyle: const TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 15,
      letterSpacing: -0.2,
    ),
  );
}
