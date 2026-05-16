import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/widgets/compact_search_toolbar.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/local/task_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../../shell/shell_sync_providers.dart';

enum _TasksFilter { all, open, done }

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

String _taskUpsertPayloadJson({
  required String title,
  required String notes,
  required bool isDone,
  required DateTime? dueDate,
  required DateTime createdAt,
  required DateTime updatedAt,
}) {
  return jsonEncode({
    'title': title.trim(),
    'notes': notes,
    'is_done': isDone,
    if (dueDate != null)
      'due_date': _dateOnly(dueDate).toUtc().toIso8601String(),
    'created_at': createdAt.toUtc().toIso8601String(),
    'updated_at': updatedAt.toUtc().toIso8601String(),
  });
}

class SettingsTasksScreen extends ConsumerStatefulWidget {
  const SettingsTasksScreen({super.key});

  @override
  ConsumerState<SettingsTasksScreen> createState() => _SettingsTasksScreenState();
}

class _SettingsTasksScreenState extends ConsumerState<SettingsTasksScreen> {
  final _search = TextEditingController();
  _TasksFilter _filter = _TasksFilter.open;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<TaskSummary> _apply(List<TaskSummary> tasks) {
    final q = _search.text.trim().toLowerCase();
    var list = tasks;
    if (q.isNotEmpty) {
      list = list
          .where((t) {
            return t.title.toLowerCase().contains(q) ||
                t.notes.toLowerCase().contains(q);
          })
          .toList();
    }

    switch (_filter) {
      case _TasksFilter.all:
        break;
      case _TasksFilter.open:
        list = list.where((t) => !t.isDone).toList();
      case _TasksFilter.done:
        list = list.where((t) => t.isDone).toList();
    }

    list = [...list];
    list.sort((a, b) {
      final cmpDone = a.isDone.toString().compareTo(b.isDone.toString());
      if (cmpDone != 0) return cmpDone;
      final ad = a.dueDate?.millisecondsSinceEpoch ?? 1 << 62;
      final bd = b.dueDate?.millisecondsSinceEpoch ?? 1 << 62;
      final cmpDue = ad.compareTo(bd);
      if (cmpDue != 0) return cmpDue;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return list;
  }

  void _openFilterSheet(AppLocalizations l10n) {
    var filter = _filter;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.listToolbarFilterTooltip,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    RadioGroup<_TasksFilter>(
                      groupValue: filter,
                      onChanged: (v) => setModal(() => filter = v!),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final f in _TasksFilter.values)
                            RadioListTile<_TasksFilter>(
                              title: Text(_tasksFilterLabel(l10n, f)),
                              value: f,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: () {
                        setState(() => _filter = filter);
                        Navigator.of(sheetContext).pop();
                      },
                      child: Text(l10n.ordersFilterApply),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _tasksFilterLabel(AppLocalizations l10n, _TasksFilter f) {
    switch (f) {
      case _TasksFilter.all:
        return l10n.tasksFilterAll;
      case _TasksFilter.open:
        return l10n.tasksFilterOpen;
      case _TasksFilter.done:
        return l10n.tasksFilterDone;
    }
  }

  Future<void> _openEditor(AppLocalizations l10n, {TaskSummary? task}) async {
    final titleCtrl = TextEditingController(text: task?.title ?? '');
    final notesCtrl = TextEditingController(text: task?.notes ?? '');
    DateTime? due = task?.dueDate;

    Future<void> pickDue() async {
      final now = DateTime.now();
      final picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime(now.year + 5),
        initialDate: due ?? now,
        helpText: l10n.tasksDueDatePick,
      );
      if (picked == null) return;
      due = _dateOnly(picked);
    }

    final repo = await ref.read(taskRepositoryProvider.future);
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  16 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      task == null ? l10n.tasksAddTitle : l10n.tasksEditTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleCtrl,
                      autofocus: task == null,
                      decoration: InputDecoration(
                        labelText: l10n.tasksTitleLabel,
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.tasksNotesLabel,
                      ),
                      minLines: 2,
                      maxLines: 6,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            due == null
                                ? l10n.tasksDueDateNone
                                : l10n.tasksDueDateValue(
                                    '${due!.year}-${due!.month.toString().padLeft(2, '0')}-${due!.day.toString().padLeft(2, '0')}',
                                  ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            await pickDue();
                            setModal(() {});
                          },
                          icon: const Icon(Icons.event_outlined),
                          label: Text(l10n.tasksDueDateSet),
                        ),
                        if (due != null)
                          IconButton(
                            tooltip: l10n.tasksDueDateClear,
                            onPressed: () => setModal(() => due = null),
                            icon: const Icon(Icons.clear),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (task != null)
                          TextButton(
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(l10n.tasksDeleteTitle),
                                  content: Text(l10n.tasksDeleteBody),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(false),
                                      child: Text(l10n.tasksDeleteCancel),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(true),
                                      child: Text(l10n.tasksDeleteConfirm),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed != true) return;
                              final shopId = ref.read(effectiveShopIdProvider);
                              recordSyncOutboxMutation(
                                ref,
                                kind: SyncOutboxKinds.taskDelete,
                                entityRef: task.internalId,
                                shopId: shopId,
                              );
                              await repo.softDeleteTask(task.internalId);
                              if (context.mounted) {
                                Navigator.of(sheetContext).pop();
                              }
                            },
                            child: Text(l10n.tasksDeleteAction),
                          ),
                        const Spacer(),
                        FilledButton(
                          onPressed: () async {
                            final title = titleCtrl.text.trim();
                            if (title.isEmpty) return;
                            final shopId = ref.read(effectiveShopIdProvider);
                            final now = DateTime.now();
                            final id = await repo.upsertTask(
                              shopId: shopId,
                              internalId: task?.internalId,
                              title: title,
                              notes: notesCtrl.text.trim(),
                              dueDate: due,
                            );
                            recordSyncOutboxMutation(
                              ref,
                              kind: SyncOutboxKinds.taskUpsert,
                              entityRef: id,
                              shopId: shopId,
                              payloadJson: _taskUpsertPayloadJson(
                                title: title,
                                notes: notesCtrl.text.trim(),
                                isDone: task?.isDone ?? false,
                                dueDate: due,
                                createdAt: task?.createdAt ?? now,
                                updatedAt: now,
                              ),
                            );
                            if (context.mounted) {
                              Navigator.of(sheetContext).pop();
                            }
                          },
                          child: Text(l10n.tasksSave),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shopId = ref.watch(effectiveShopIdProvider);
    final asyncTasks = ref.watch(tasksForShopProvider(shopId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.tasksTitle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(l10n),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          CompactSearchToolbar(
            searchController: _search,
            searchHint: l10n.tasksSearchHint,
            searchTooltip: l10n.listToolbarSearchTooltip,
            filterTooltip: l10n.listToolbarFilterTooltip,
            filterActive: _filter != _TasksFilter.open,
            onSearchChanged: () => setState(() {}),
            onFilterTap: () => _openFilterSheet(l10n),
          ),
          Expanded(
            child: asyncTasks.when(
              data: (tasks) {
                final list = _apply(tasks);
                if (list.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        tasks.isEmpty ? l10n.tasksEmpty : l10n.tasksEmptyFiltered,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: list.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final t = list[i];
                    return ListTile(
                      leading: Checkbox(
                        value: t.isDone,
                        onChanged: (v) async {
                          final repo =
                              await ref.read(taskRepositoryProvider.future);
                          final isDone = v == true;
                          await repo.setTaskDone(
                            internalId: t.internalId,
                            isDone: isDone,
                          );
                          final shopId = ref.read(effectiveShopIdProvider);
                          final now = DateTime.now();
                          recordSyncOutboxMutation(
                            ref,
                            kind: SyncOutboxKinds.taskUpsert,
                            entityRef: t.internalId,
                            shopId: shopId,
                            payloadJson: _taskUpsertPayloadJson(
                              title: t.title,
                              notes: t.notes,
                              isDone: isDone,
                              dueDate: t.dueDate,
                              createdAt: t.createdAt,
                              updatedAt: now,
                            ),
                          );
                        },
                      ),
                      title: Text(
                        t.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: t.dueDate == null
                          ? null
                          : Text(
                              l10n.tasksDueDateShort(
                                '${t.dueDate!.year}-${t.dueDate!.month.toString().padLeft(2, '0')}-${t.dueDate!.day.toString().padLeft(2, '0')}',
                              ),
                            ),
                      onTap: () => _openEditor(l10n, task: t),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('$e', textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

