# Implementation wave 2 — Order internal notes + sync queue stub wiring

Follows **plan-12** (internal notes), **plan-03** (local outbox), **plan-15** (backup v1), and **plan-06** (owner password).

## Scope (by plan)

| Plan | Deliverable |
|------|-------------|
| **plan-12** | `OrderEntity.internalNotes` + `OrderSummary.internalNotes`; `updateOrderInternalNotes` on `OrderListRepository` (Isar + Memory). Order detail: **Internal notes** section; editable whenever the license is valid, including **Delivered / Cancelled** (other sections stay locked). |
| **plan-03** (foundation) | Local **sync outbox** (`SyncOutboxEntity` on Isar; in-memory on Web): UI records mutations via `recordSyncOutboxMutation`; shell badge + Settings → Sync show **pending count** and a **pending list** (no API replay yet). |
| **plan-15** (v1→v2) | **Backup & restore** on IO: JSON **v2** export (v1+v2 import). Adds **measurement types, profiles, profile items** to the bundle; v1 files still merge (omit measurement keys). |

## Out of scope (later waves)

- Real sync outbox + server replay
- Backup **catalog images** + catalog rows (v1 is data-only core tables)
- Full conflict UI for every entity

## Definition of done

- Internal notes persist on IO (Isar) and Web (memory); list/detail reflect updates.
- Locked-order hint clarifies that internal notes can still be edited.
- On **Android/iOS/desktop**: backup JSON round-trip merge works from Settings with owner password + summary.
- `dart analyze` / `flutter test` clean.

## Execution status

- [x] `internalNotes` on `OrderEntity` + codegen
- [x] `OrderSummary` + `IsarOrderRepository` / `MemoryOrderRepository` + `updateOrderInternalNotes`
- [x] Order detail UI + l10n
- [x] `recordSyncOutboxMutation` + `SyncOutboxRepository` (Isar + Memory) + shell/settings count + pending list
- [x] Offline **owner password** gate for **Delivered / Cancelled** (`lib/security/owner_password_verify.dart`; default dev password documented in `TESTING.md`)
- [x] Backup **v2** (measurement types/profiles/items + v1 import compat; `file_picker`, Settings)
