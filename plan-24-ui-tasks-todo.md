# Afghan Pride — Frontend UI Plan: Tasks / To‑Do

This document defines a small offline-first **Tasks / To‑Do** feature.

## Goals
- Track shop work as a simple checklist (no calendar complexity).
- Works fully offline from local data.
- Fast add/complete/edit; minimal fields.

## Non-goals (for now)
- No reminders/notifications.
- No multi-user assignment or permissions.
- No sync to server (until `plan-03` sync pipeline is implemented for tasks).

## Data shape (client, offline-first)
Entity: `tasks`
- `internal_id` (UUID/ULID string)
- `shop_id`
- `title` (required)
- `notes` (optional)
- `is_done` (bool)
- `due_date` (optional date)
- `created_at`, `updated_at`
- `deleted_at` (soft delete)

Rules:
- Tasks are shop-scoped.
- Deletion is **soft delete**.
- List default: show **open** tasks first, then completed.

## Navigation placement (selected)
- Entry point: **Settings → Tasks** (keeps bottom tabs unchanged).
- Optional shortcut chip may be added to Dashboard drawer.

## Screen 1: Tasks list
Top controls:
- Search (title + notes)
- Filter: All / Open / Done

List rows:
- Checkbox (toggle done)
- Title
- Optional due date chip (if set)
- Tap row → edit

Actions:
- FAB: Add task

## Screen 2: Add/Edit task
Fields:
- Title (required)
- Notes (optional, multiline)
- Due date (optional; date picker)

Actions:
- Save
- Delete (soft delete) with confirmation

## Definition of Done
- Tasks list works offline and is instant.
- CRUD works on Web (memory) and Android/iOS (Isar).
- No hardcoded user-visible strings (ARB).
- `flutter analyze` clean; tests pass.

## Implementation status

- Settings → Tasks: shipped.
- Optional **dashboard shortcut**: **Tasks** chip in the dashboard drawer quick links (`plan-25`).

