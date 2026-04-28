import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/providers.dart';
import '../../core/theme/app_colors.dart';

class ActiveProgramIndicator extends ConsumerWidget {
  const ActiveProgramIndicator({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(currentUidProvider);
    if (uid == null) return child;
    final asyncActive = ref.watch(_activeProgramProvider(uid));
    final hasActive = asyncActive.value != null;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (hasActive)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.activeRing,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.activeRing,
                    blurRadius: 6,
                    spreadRadius: 0.4,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

final _activeProgramProvider = StreamProvider.family.autoDispose((
  ref,
  String uid,
) {
  return ref.watch(programsRepoProvider).watchActive(uid);
});
