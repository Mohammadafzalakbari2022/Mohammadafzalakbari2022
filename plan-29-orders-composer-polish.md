# Plan 29 — Orders composer polish (visibility, cloth, edit, status)

## Goal

Complete the Orders tab receipt composer after plan-26/28: **shop-configurable section visibility**, **Cloth** terminology and fields, **clean layout** (no tinted empty panels), **edit / post-save / reference prefill / status** flows restored and reliable. One plan so the product owner does not re-fix the same gaps.

## Depends on

- `plan-26-ui-orders-receipt-composer.md` — single-screen composer, edit via `?orderId=`
- `plan-28-ui-orders-composer-compact.md` — density, search fix, post-save sheet, shape grid
- `plan-04-backend-api.md` — order `items[]` sync block (extend with cloth meters/price)
- `plan-15-ui-settings.md` — settings patterns
- `AGENTS.md` — l10n, offline-first, small diffs

## UX contract

### A. Settings → Orders composer visibility (core)

**Location:** Settings tab → new tile **Orders composer fields** (sibling to Order style / Customer cloth presets), route `/app/settings/orders-composer`.

| Toggle | When OFF on Orders tab | When ON |
|--------|------------------------|---------|
| Style name | Style name chips + custom name field **hidden** | Shown; **optional** at save |
| Choose from catalog | Catalog picker block **hidden** | Shown; optional |
| Cloth block | Entire cloth section **hidden** (no empty panel) | Name, color, meters, price shown; all optional |

- Defaults: **all ON** (current behavior for shops without prefs).
- Persist: **shop-scoped SharedPreferences** (local, offline-first; key prefix `pride_composer_vis_{shopId}_*`).
- Provider: `composerVisibilitySettingsProvider` — read in composer garment block + style panel.

### B. Garment icons

| Garment | Icon |
|---------|------|
| Perahan/Tunban | `Icons.checkroom_outlined` (shirt — not waistcoat) |
| Waistcoat | `Icons.layers_outlined` (vest layer) |

Shared helper: `composerGarmentIcon(GarmentType)` in `order_composer_item_card.dart`.

### C. Remove tinted composer section backgrounds

On Orders composer only (measurements, style, cloth, catalog):

- **No** `PrideOptionalPanel` wrappers on whole sections.
- **No** `prideOptionalDecoration` filled backgrounds on fields in these panels.
- Optional empty state: subtle hint text or label only — not blocking save.

Delivery date and payment fields on the main composer scroll may keep existing optional styling (out of scope for “section” pink).

### D. Measurements layout

- Compact **two-column table**: measurement name | value (fixed narrow value column).
- Profile picker + “use previous” unchanged.

### E. Style shapes grid

- **Keep plan-28** (4–5 columns, borderless tiles). No regression.

### F. Cloth (not Fabric) + data layer

**User-facing copy (composer + settings hub titles):**

| Locale | Term |
|--------|------|
| EN | **Cloth** (not Fabric) for tailor material |
| Dari (`fa`) | **رخت** — نام رخت، رنگ رخت، متراژ رخت (not پارچه for customer material) |
| Pashto (`ps`) | aligned cloth terms in ARB |

**New per-garment item fields** (when cloth block enabled):

- `clothMetersSnapshot` — free text / decimal string (e.g. `3.5`)
- `clothPriceAmountMinor` — int minor units (same as garment price)

Waistcoat and Perahan each have **own** cloth block (same pattern as garment price).

**Persistence:**

- `OrderItemEntity`: `clothMetersSnapshot`, `clothPriceAmountMinor`
- Propagate: `OrderItemSummary`, `OrderItemDraft`, `OrderItemCreateInput`, Isar repo, memory repo, sync pull/push (`order_sync_payload.dart` keys `cloth_meters`, `cloth_price_amount_minor` in `items[]`).

Internal snapshot field names may keep `fabric*` for backward compatibility; UI labels say Cloth.

### G. Edit saved orders

- `/app/orders?orderId=` loads order into composer (listener on orders stream).
- Customers tab orders list row tap → same route.
- Save updates existing order (`upsertOrderItem`, `updateOrderDetails`, status if changed).
- Prefill includes cloth meters/price.

### H. Post-save sheet

Per plan-26/28:

- **New order (tab root):** snackbar → post-save bottom sheet (print, view PDF, share PDF, view order) → **reset** form.
- **Edit (tab root):** same.
- **Edit (pushed):** snackbar → navigate to detail.
- Do not `context.go('/app/orders')` on tab root after save (black screen).

### I. Previous order prefill

“Use previous” actions copy from customer reference order **per garment**:

- Measurements (item snapshot)
- Style + shapes
- Catalog design (Perahan)
- Cloth name, color, presets, **meters, price**

Respect visibility toggles: hidden sections still copy data internally on save if present in reference (optional); UI buttons only shown when section visible.

### J. Order status

**Customers tab orders list:**

- Trailing **status menu** on each row (PopupMenu): In progress, Ready, Delivered, Cancelled, etc.
- Same confirmations as detail (`confirmOrderStatusChange`, `confirmOrderCancelByCustomerName`).
- Sync outbox + notification on change (reuse detail flow).

**Composer edit mode:**

- Status dropdown when `_editingOrderId != null`; persisted on save via `updateOrderStatus`.

## Implementation phases

| Phase | Work |
|-------|------|
| **1** | This plan + `plan-00-index.md` entry |
| **2** | Settings storage, provider, settings screen, router, settings tile |
| **3** | Composer respects toggles (hide sections entirely) |
| **4** | Icons, remove pink panels, measurements table |
| **5** | Cloth fields + l10n + Isar/entity/repo/sync |
| **6** | Edit prefill, post-save verify, previous cloth copy, list status menu |
| **7** | Tests + `flutter analyze` |

## Files (primary)

- `plan-29-orders-composer-polish.md`, `plan-00-index.md`
- `lib/core/persistence/shop_composer_settings_storage.dart`
- `lib/features/settings/composer_visibility_provider.dart`
- `lib/features/settings/settings_composer_fields_screen.dart`
- `lib/features/settings/settings_tab_screen.dart`
- `lib/router/app_router.dart`, `lib/router/license_paths.dart`
- `lib/features/orders/order_composer_receipt_garment_block.dart`
- `lib/features/orders/order_composer_style_sheet.dart`
- `lib/features/orders/order_composer_fabric_panel.dart`
- `lib/features/orders/order_composer_measurements_panel.dart`
- `lib/features/orders/order_composer_screen.dart`
- `lib/features/orders/order_composer_reference.dart`
- `lib/features/orders/order_list_tile.dart`
- `lib/features/orders/order_list_status_actions.dart` (new)
- `lib/features/orders/orders_filtered_list_body.dart`
- `lib/data/local/entities/order_item_entity.dart` (+ codegen)
- `lib/data/local/order_item_*.dart`, `order_sync_payload.dart`
- `lib/data/local/isar_order_repository.dart`, `memory_order_repository.dart`
- `lib/l10n/app_*.arb`

## Tests

- `test/composer_visibility_settings_test.dart` — defaults, persist round-trip
- `test/order_composer_reference_test.dart` — cloth copy includes meters/price
- Update `test/order_composer_shape_grid_test.dart` if needed
- Existing composer/draft tests still pass

## Out of scope

- Renaming Isar `fabric_*` columns (keep for migration simplicity)
- Removing `OrderDetailScreen`
- Backend NestJS schema (client sends new keys; server tolerant)

## Isar migration (cloth fields)

- `OrderItemEntity.clothMetersSnapshot` and `clothPriceAmountMinor` are **additive** scalar fields with defaults (`''` / `0`).
- Isar opens existing databases without a manual migration helper; new columns read as empty/zero for existing rows.
- Regenerate after entity edits: `dart run build_runner build --delete-conflicting-outputs`.

## Performance (minimal)

- Composer uses `ref.watch(...select((async) => async.valueOrNull))` on orders/customers streams so `AsyncLoading` transitions do not rebuild the full receipt form.
- Item-scoped snapshot reads use `OrderItemSnapshotKey` (no unbounded in-memory cache layer).

## Definition of done

- Plan indexed in `plan-00-index.md`
- All toggles persist and hide sections (not empty boxes)
- Cloth l10n in EN/fa/ps; meters + price on items sync locally
- Edit, post-save, previous prefill, list status menu work
- `flutter analyze` clean; targeted tests pass
