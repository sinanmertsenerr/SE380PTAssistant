import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/onboarding_flow.dart';
import '../../features/auth/sign_in_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/notes/note_editor_screen.dart';
import '../../features/notes/notes_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/settings_screen.dart';
import '../../features/programs/program_detail_screen.dart';
import '../../features/programs/program_editor_screen.dart';
import '../../features/programs/programs_screen.dart';
import '../../features/programs/session_runner_screen.dart';
import '../providers/providers.dart';
import 'app_shell.dart';

const _shellBranches = ['/home', '/programs', '/chat', '/notes', '/profile'];

int _branchIndexFor(String location) {
  for (var i = _shellBranches.length - 1; i >= 0; i--) {
    if (location.startsWith(_shellBranches[i])) return i;
  }
  return 0;
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authStream = ref.watch(authStateProvider);
  final profileStream = ref.watch(profileStreamProvider);

  int? lastBranchIndex;

  Page<void> branchPage(GoRouterState state, Widget child) {
    final newIdx = _branchIndexFor(state.uri.toString());
    final prev = lastBranchIndex;
    final forward = prev == null || newIdx >= prev;
    final isFirst = prev == null;
    lastBranchIndex = newIdx;

    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (isFirst) return child;
        final begin =
            forward ? const Offset(1, 0) : const Offset(-1, 0);
        return SlideTransition(
          position: Tween<Offset>(begin: begin, end: Offset.zero).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        );
      },
    );
  }

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: _AuthListenable(ref),
    redirect: (context, state) {
      final loc = state.uri.toString();
      final auth = authStream.value;

      if (authStream.isLoading) return null;
      final isAuthRoute = loc.startsWith('/auth');
      final isOnboarding = loc.startsWith('/onboarding');

      if (auth == null) {
        return isAuthRoute ? null : '/auth/sign-in';
      }

      final profile = profileStream.value;
      if (profileStream.isLoading) return null;
      final needsOnboarding = profile == null || !profile.onboardingComplete;
      if (needsOnboarding && !isOnboarding) return '/onboarding';
      if (!needsOnboarding && (isAuthRoute || isOnboarding)) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/auth/sign-in',
        builder: (_, __) => const SignInScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingFlow(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (_, state) => branchPage(state, const HomeScreen()),
          ),
          GoRoute(
            path: '/programs',
            pageBuilder: (_, state) =>
                branchPage(state, const ProgramsScreen()),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, state) =>
                    ProgramDetailScreen(programId: state.pathParameters['id']!),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (_, state) => ProgramEditorScreen(
                      programId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'session',
                    builder: (_, state) => SessionRunnerScreen(
                      programId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/chat',
            pageBuilder: (_, state) => branchPage(state, const ChatScreen()),
          ),
          GoRoute(
            path: '/notes',
            pageBuilder: (_, state) => branchPage(state, const NotesScreen()),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, state) =>
                    NoteEditorScreen(noteId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (_, state) =>
                branchPage(state, const ProfileScreen()),
            routes: [
              GoRoute(
                path: 'settings',
                builder: (_, __) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(this._ref) {
    _ref
      ..listen(authStateProvider, (_, __) => notifyListeners())
      ..listen(profileStreamProvider, (_, __) => notifyListeners());
  }

  final Ref _ref;
}
