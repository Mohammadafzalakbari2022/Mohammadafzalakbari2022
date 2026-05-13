# Afghan Pride — Offline + Sync Plan (Full System)

## Objectives
- App fully usable offline for all shop workflows
- Multi-user collaboration within a shop when back online
- Predictable conflict behavior (no silent data loss)

## Principles
- **Local-first**: write to Isar first, always
- **Server as sync target**: Supabase Postgres holds canonical history, but the client may be ahead while offline
- **Soft delete everywhere**

## What sync must support
- Create/update/delete while offline
- Retry failures with backoff
- Resume after app restart
- Conflict detection + resolution policy

## Recommended approach (practical)

### Data fields required on all synced entities
- `internal_id`
- `shop_id`
- `updated_at` (client timestamp)
- `server_updated_at` (server timestamp, when known)
- `revision` (optional integer) OR server `updated_at` used as concurrency token
- `deleted_at` (soft delete)
- `last_modified_by_user_id`

### Change queue (outbox)
Maintain a local “outbox” table:
- entity_type, entity_id
- operation (upsert/delete)
- payload snapshot or “diff”
- queued_at, attempts, last_error

### Sync loop
1. Push local outbox changes to API
2. Pull remote changes since last sync cursor
3. Apply merges/conflicts to local store
4. Update cursors and clear successfully pushed outbox rows

## Conflict policy (must be explicit per entity)

### Default policy (good MVP default)
- If two users edit the same record:
  - Detect conflict by comparing concurrency token
  - Apply **server wins** for some fields, **client wins** for others, or present a UI prompt on critical entities (orders/payments)

### Suggested per-entity policy
- Customers: last-write-wins usually acceptable
- Orders: avoid losing changes; prefer field-level merge or conflict UI
- Payments: never auto-merge if it can change totals; prefer append-only payments
- Measurement types: treat as “admin-like”; last-write-wins with audit

### Selected conflict rules (practical defaults)
- Customers: last-write-wins + keep `last_modified_by_user_id`
- Orders:
  - field-level merge for non-financial fields (notes, delivery_date, status)
  - if both edited the same critical field → show conflict UI on next open
- Payments (selected):
  - treat payments as append-only ledger entries
  - do not edit old payments; add a new payment or a “reversal/adjustment” entry
- Measurement profiles/snapshots:
  - profile edits: last-write-wins (with audit)
  - order snapshots: immutable history (never “recomputed” after creation)

### Notifications (in-app, shop-wide)
Generate “system notifications” for important events and sync them across users:
- user added / user removed
- order status changed (ready/delivered/cancelled)

Implementation direction:
- store notifications locally first (Isar)
- enqueue to outbox and sync to server
- pull down notifications for other users on next sync

## Catalog sharing note (P2P; no cloud images)
- Shared catalog browsing can sync metadata, but **images are never synced via server**.
- Image transfer happens via **P2P WebRTC** when both shops are online (signaling via API).

## 8-digit display order number
Selected approach: **Hybrid** (works offline, server finalizes)
- `internal_id` is always the real identifier (offline-safe).
- Client can generate a **temporary** `display_order_no` while offline for usability.
- On first successful sync, server assigns/validates the **final** 8-digit `display_order_no`.

Collision handling:
- If the server detects the client’s temporary number collides:
  - server issues a new final `display_order_no`
  - client updates local order record to the server final value

## Observability
- “Sync status” screen:
  - last sync time
  - queued changes count
  - last error message

Owner outbox viewer (selected)
- Add an owner-accessible “Outbox” screen:
  - list queued changes (entity_type, operation, queued_at, attempts, last_error)
  - “Retry sync now” button
  - “Export diagnostics” shortcut

## Licensing interaction with sync (must be explicit)
- If license is **expired**:
  - client is READ-ONLY (except Subscription page)
  - do not attempt background sync
  - API denies push/pull (return explicit “license_expired” error code)
- If offline and license cannot be rechecked:
  - apply the offline expiration tracking rules from the Security & Licensing plan
  - if client determines expired ⇒ READ-ONLY and sync disabled

## Order status workflow (selected UX rules)
Even though orders remain editable, status changes should be quick and safe:
- Quick actions:
  - Mark Ready
  - Mark Delivered
  - Cancel Order
- Confirmation prompts:
  - Delivered: confirm + require **owner password confirmation**
  - Cancel: require reason (optional) + require **owner password confirmation**
- Generate notifications:
  - broadcast to all users in shop (in-app inbox) when status changes

