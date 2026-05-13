# Afghan Pride — Architecture Plan (Full System)

## Goals
- Offline-first, fast in-shop workflows
- Modular feature-first Flutter architecture
- Clear boundaries to support sync, licensing, and admin tools

## Client Architecture (Flutter)

### Recommended structure (feature-first + layered inside each feature)
- `lib/core/` (theme, routing, localization, base widgets, logging)
- `lib/features/<feature>/`
  - `data/` (Isar models, DTOs, repository impl)
  - `domain/` (entities, repository interfaces, use-cases)
  - `presentation/` (screens, widgets, controllers/providers)
- `lib/shared/` (reusable UI + utilities)

### State management
- Riverpod for:
  - screen controllers (async state)
  - app session state (shop/user/license)
  - background jobs (sync scheduler triggers)

### Routing
- `go_router` with route guards:
  - unauthenticated → auth flow
  - authenticated but unlicensed/expired → subscription screen
  - developer account → admin/dev portal routes enabled

### Navigation (selected)
- Main navigation is a **bottom navigation bar** (Android/iOS/Web) for core modules.
- Dashboard is not a bottom tab. It is opened via an **edge swipe** (start side, respecting RTL/LTR) as a sliding panel/drawer.
- For discoverability, also provide a **hamburger icon** on main screens to open the Dashboard panel.
- Other modules should not rely on drawer navigation (bottom nav remains primary).

Bottom navigation items (selected)
- Orders
- Customers
- Catalog
- Reports
- Settings

## Module boundaries (what “module-by-module” means)

### Foundation module
Definition of Done:
- responsive navigation shell
- theming tokens + dark mode
- l10n keys (no hard-coded strings)
- error handling + logging base
- settings skeleton

### Business modules
Each module must ship with:
- offline CRUD
- list filters + search where needed
- basic validation
- “dirty changes” tracking fields needed for sync

## Cross-cutting systems (must be designed early)

### Identity (critical)
- **internal_id** (UUID/ULID): stable unique key for sync and relationships
- **display numbers** (e.g., 8-digit order number): UI-only, not keys

### Audit / change tracking
Every mutable entity should carry:
- `created_at`, `updated_at`, optional `deleted_at`
- `last_modified_by_user_id`
- `revision` (integer) or `updated_at` for conflict checks
- `sync_state` (synced/dirty/conflict)

### Background work
- Sync runner (periodic + on connectivity regained)
- Cleanup jobs (thumbnails, orphaned images)
- License refresh checks (when online) + offline enforcement:
  - cache `license_snapshot` locally
  - if expired (or grace exceeded) → global READ-ONLY gate except Subscription page

### In-app notifications (system notifications; selected)
- Provide an in-app “Notifications” inbox shared per shop (synced).
- Notify all users in the shop when:
  - order status changes (ready/delivered/cancelled)
  - user added/removed
  - important subscription/license status changes

Scope rule (selected)
- Notifications are **in-app only** (no SMS/email, no external push requirements in MVP).
- Add a Settings option to **mute notifications** (hide in-app banners/badges; inbox still stores items).

### Global UI consistency (selected)
- Use one shared dialog/confirmation component across the entire app.
- Use one shared “action feedback bar” component for success/error messages.

## Web scope (optional)
- Keep Flutter Web **optional** (frontend testing)
- Do not require offline Web for MVP
- If later needed: add an abstraction for local store and implement web backend separately

### Web limitations (to keep Web stable)
Web is for **UI testing/demo**, not full parity. On Web:
- Disable **catalog image capture/upload** (camera/gallery pickers) and any flows that depend on device file paths.
- Disable **all printing capabilities**:
  - PDF printing via OS print dialogs is inconsistent across browsers and will be excluded for the Web build.
  - Disable **thermal printer** integrations (ESC/POS) and any platform-specific printer discovery.
- Disable **Bluetooth-related features** (printer pairing/connection) on Web.
- Web is allowed to **edit non-device features** (your selected scope):
  - customers, orders, measurements, payments, settings, subscription (when applicable)
  - anything not requiring printing/Bluetooth/image capture
- Prefer “view-only” fallback for any module that becomes unstable on Web; keep mobile as the real product.

