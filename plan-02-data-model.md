# Afghan Pride — Data Model Plan (Full System)

This document defines the “shape” of data so offline-first + sync + multi-user remains consistent.

## ID strategy (non-negotiable)

### Two IDs everywhere
- **internal_id**: UUID/ULID (primary key for relationships + sync)
- **display_* numbers**: e.g. `display_order_no` (8-digit shop counter) for UI only

### Why
- multi-device offline work will otherwise cause collisions
- sync needs stable identifiers not dependent on “incrementing”

## Core entities (client + server)

### shops
- internal_id
- name, logo_url (optional), address, phone
- created_at, updated_at

### users
- internal_id
- shop_id (FK)
- username
- phone, email (optional)
- is_developer (bool) OR developer allowlist checked server-side
- is_shop_owner (bool)
- password_hash (server-only; never synced to client as plaintext)
- created_at, updated_at, deleted_at?

User deletion rule (selected)
- Deleting a user is a **soft delete**:
  - user cannot log in after deletion
  - keep historical references (created_by_user_id, last_modified_by_user_id) intact

Username uniqueness (selected)
- `username` must be unique **within the same shop_id** only.

Restore collision rule (selected)
- If a merge restore introduces duplicate usernames inside the same shop:
  - block login for that duplicated username until owner resolves it (rename or soft-delete one)

Offline login cache (client-only; stored locally)
- Store a secure offline credential verifier for the last successful logins (per device):
  - user_id, shop_id, username, is_shop_owner
  - password verifier (hash) or offline auth token

Rule (selected)
- Offline login is available only **after at least one successful online login** on that device (credential seeding).

### customers
- internal_id
- shop_id (FK)
- name, phone (+93 normalization), address?, notes?
- created_at, updated_at, deleted_at?

### orders
- internal_id
- shop_id (FK)
- customer_id (FK)
- display_order_no (string “00000001”)
- status (enum)
- delivery_date
- notes?
- created_at, updated_at, deleted_at?

### measurement_types (dynamic fields)
- internal_id
- shop_id (FK)
- name (RTL/LTR text)
- sort_order
- is_active (soft-disable instead of delete recommended)
- created_at, updated_at

### measurements (values per order/customer context)
Selected approach: **C (recommended for your workflow)** — customer profile + order snapshot.

Goals:
- Save a customer’s measurements once (profile) for repeat orders
- Preserve history per order (snapshot at time of order)

Data shape:
- **customer_measurement_profiles**
  - internal_id, shop_id, customer_id
  - label/name (optional: e.g., “Winter 2026”)
  - unit_preference (inch/cm)
  - created_at, updated_at, deleted_at?
- **customer_measurement_profile_items**
  - internal_id, profile_id, measurement_type_id
  - value, unit
  - created_at, updated_at
- **order_measurement_snapshots**
  - internal_id, order_id
  - source_profile_id (nullable; for traceability)
  - created_at
- **order_measurement_snapshot_items**
  - internal_id, snapshot_id, measurement_type_id
  - value, unit

Rule:
- When creating an order, user selects an existing profile (or creates one), and the app copies values into the order snapshot.

Profile editing behavior (selected: support both)
- Support both:
  - **Edit in place**: quick corrections to the current profile
  - **Save as new version**: create a new profile (e.g., “Profile v2”) and keep old versions for history
- Orders always store a snapshot, so historical orders are not affected by later profile edits.

### payments
- internal_id
- order_id (FK)
- amount
- method (cash/manual/etc.)
- created_at

Payments rule (selected)
- Payments are an **append-only ledger**:
  - do not edit/delete old payments
  - for corrections, create a new “adjustment/reversal” payment entry

### designs
- internal_id
- shop_id (FK)
- name

### style_figures
- internal_id
- shop_id (FK)
- category
- name
- image_path (local) and/or storage_url (if later cloud)

### order_style_figures (join)
- internal_id
- order_id (FK)
- style_figure_id (FK)

### catalog_items
- internal_id
- shop_id (FK)
- image_path, thumbnail_path (local)
- design_name?, designer_name?, notes?
- created_at, updated_at, deleted_at?

Catalog metadata (selected)
- `designer_name` is the **shop name** of the creator (watermark label).
- Add fields:
  - `added_by_user_id`
  - `added_at` (can reuse created_at)
  - `is_shared_public` (bool; only meaningful if shop sharing is enabled)

Local image storage rules (selected)
- Images are stored **locally only** (no cloud image hosting).
- Store images in an app-private directory so they **do not appear in the phone gallery**.
- Backup can optionally include images (see Backup plan).
- Optional optimization: create compressed thumbnails for fast lists and smaller backups.

Web scope rule:
- Flutter Web is for UI testing/demo. On Web:
  - **do not allow creating/updating images** for catalog items (no upload/camera).
  - catalog items may be **view-only** (render existing metadata; images optional).

### catalog_sharing_settings (server-owned)
Purpose: opt-in gate for public directory visibility.
- shop_id
- sharing_enabled (bool)
- updated_at

### shared_catalog_public_index (server-owned metadata only)
Purpose: public directory listing without storing image binaries.
- catalog_item_id (origin)
- origin_shop_id
- design_name
- designer_shop_name (watermark label)
- added_at
- is_active

Rule (selected mutual opt-in):
- A shop can browse the public shared directory **only if** its own `sharing_enabled = true`.

### subscriptions / licenses (server-owned)
- shop_id (FK)
- plan_type, expires_at
- status
- last_checked_at

### license_snapshots (client-owned cache; stored locally in Isar)
Purpose: enable **offline enforcement** and consistent UX.
- shop_id
- status (trial_active/active/expired)
- expires_at (server time)
- last_successful_check_at (server time)
- grace_period_days (fixed = 3)
- suspected_time_tamper (bool)
- last_seen_device_time, last_seen_uptime (anchors)

### activation_codes (admin-created)
- code
- plan_type, duration
- assigned_shop_id?
- redeemed_at?

### notifications (synced; in-app inbox)
Purpose: system-wide notifications for all users in a shop (no SMS/email).
- internal_id
- shop_id (FK)
- type (order_status_changed, user_added, user_removed, license_changed, etc.)
- title, body
- entity_ref_type?, entity_ref_id? (optional link to order/user)
- created_at
- created_by_user_id

### password_reset_requests (server-owned; manual support)
- internal_id
- shop_id
- username
- requested_at
- status (open/resolved)

## Constraints & indexing (performance)
- Index orders by: shop_id + status, shop_id + delivery_date, shop_id + updated_at
- Index customers by: shop_id + phone, shop_id + name

## Soft delete policy
- Prefer `deleted_at` rather than hard delete to support sync and restore.

