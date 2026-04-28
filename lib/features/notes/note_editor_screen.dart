import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/note.dart';
import '../../core/providers/providers.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  const NoteEditorScreen({required this.noteId, super.key});

  final String noteId;

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  final _tag = TextEditingController();
  Timer? _debounce;
  bool _previewing = false;
  bool _loaded = false;
  Note? _current;

  @override
  void initState() {
    super.initState();
    _title.addListener(_scheduleSave);
    _body.addListener(_scheduleSave);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _title.dispose();
    _body.dispose();
    _tag.dispose();
    super.dispose();
  }

  void _scheduleSave() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), _save);
  }

  Future<void> _save() async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    await ref.read(notesRepoProvider).update(uid, widget.noteId, {
      'title': _title.text,
      'body': _body.text,
      'tags': _current?.tags ?? <String>[],
      'pinned': _current?.pinned ?? false,
    });
  }

  Future<void> _togglePin() async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    final next = !(_current?.pinned ?? false);
    setState(() => _current = _current?.copyWith(pinned: next));
    await ref.read(notesRepoProvider).update(uid, widget.noteId, {
      'pinned': next,
    });
  }

  Future<void> _addTag(String tag) async {
    final uid = ref.read(currentUidProvider);
    if (uid == null || tag.isEmpty) return;
    final tags = {..._current?.tags ?? <String>[], tag}.toList();
    setState(() => _current = _current?.copyWith(tags: tags));
    await ref.read(notesRepoProvider).update(uid, widget.noteId, {
      'tags': tags,
    });
    _tag.clear();
  }

  Future<void> _delete() async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) return;
    await ref.read(notesRepoProvider).delete(uid, widget.noteId);
    if (mounted) context.go('/notes');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final uid = ref.watch(currentUidProvider);
    if (uid == null) return const SizedBox.shrink();
    final asyncNote = ref.watch(_noteProvider((uid, widget.noteId)));

    return asyncNote.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text(l10n.errors_generic))),
      data: (note) {
        if (!_loaded) {
          _loaded = true;
          _current = note;
          _title.text = note.title;
          _body.text = note.body;
        }
        _current = note;
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: _title,
              decoration: InputDecoration(
                hintText: l10n.notes_titleHint,
                border: InputBorder.none,
                isDense: true,
              ),
              style: theme.textTheme.titleLarge,
            ),
            actions: [
              IconButton(
                tooltip: note.pinned ? l10n.notes_unpin : l10n.notes_pin,
                icon: Icon(
                  note.pinned
                      ? Icons.push_pin_rounded
                      : Icons.push_pin_outlined,
                  color: note.pinned ? theme.colorScheme.primary : null,
                ),
                onPressed: _togglePin,
              ),
              IconButton(
                tooltip: _previewing ? l10n.notes_edit : l10n.notes_preview,
                icon: Icon(
                  _previewing
                      ? Icons.edit_rounded
                      : Icons.remove_red_eye_rounded,
                ),
                onPressed: () => setState(() => _previewing = !_previewing),
              ),
              IconButton(
                tooltip: l10n.common_delete,
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: _delete,
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: _previewing
                    ? Markdown(
                        data: _body.text.isEmpty ? '_—_' : _body.text,
                        padding: const EdgeInsets.all(AppSpacing.md),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: TextField(
                          controller: _body,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            hintText: l10n.notes_bodyHint,
                            border: InputBorder.none,
                            filled: false,
                          ),
                        ),
                      ),
              ),
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          children: note.tags
                              .map(
                                (t) => InputChip(
                                  label: Text('#$t'),
                                  onDeleted: () async {
                                    final tags = note.tags
                                        .where((x) => x != t)
                                        .toList();
                                    await ref.read(notesRepoProvider).update(
                                      uid,
                                      widget.noteId,
                                      {'tags': tags},
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      SizedBox(
                        width: 140,
                        child: TextField(
                          controller: _tag,
                          decoration: InputDecoration(
                            hintText: l10n.notes_tags,
                            isDense: true,
                          ),
                          onSubmitted: _addTag,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

final _noteProvider = StreamProvider.family
    .autoDispose<Note, (String uid, String id)>((ref, args) async* {
      final repo = ref.watch(notesRepoProvider);
      yield await repo.get(args.$1, args.$2);
    });
