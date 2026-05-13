# Implementation wave 1 — Notifications + dashboard preview

This wave ties together multiple UI plans without waiting on the full sync API.

## Scope (by plan)

| Plan | Deliverable |
|------|-------------|
| **plan-09** | Dashboard drawer: “Recent notifications” preview (max 3), “View all” → Settings → Notifications. Respects mute. |
| **plan-15** | Notifications inbox: real list from local store; tap row marks read; empty state when none. |
| **plan-12** | Append inbox entry when order **status** changes from order detail (after successful `updateOrderStatus`). |
| **plan-10** | App bar badge uses **unread count** from the same store (replaces static stub). |

## Out of scope (later waves)

- Push / server notifications
- plan-03 outbox-driven notification fan-out
- Order **internal notes** → see `plan-23-implementation-wave-2.md`
- Backup/restore binary (plan-15) — UI already exists; execution stays “coming soon”

## Data model

- **Isar (IO):** `AppNotificationEntity` — shop-scoped, append-only, `readAt` nullable.
- **Memory (Web):** same behavior, in-process list.

## Definition of done

- Unread badge on shell matches unread rows; mute hides badge.
- Dashboard preview lists latest three; offline-first.
- Changing order status creates one notification row with localized title/body.
- `flutter analyze` / `flutter test` clean.

## Execution status (wave shipped in repo)

- [x] `AppNotificationEntity` + Isar + `MemoryAppNotificationRepository` (Web)
- [x] `appNotificationRepositoryProvider`, `appNotificationsStreamProvider`, `unreadAppNotificationCountProvider`
- [x] Welcome seed from `AppShell` (localized, id `notif-seed-welcome`)
- [x] Order status change → `append` notification from order detail
- [x] Settings → Notifications inbox (mark read on tap, mark all read, deep link to order)
- [x] Dashboard drawer preview + “View all”
- [x] Shell badge uses unread count (removed stub `StateProvider`)
