# Plan 28 — Orders composer compact UX

## Goal

Make the Orders tab receipt composer **denser, faster, and keyboard-stable** after plan-26. Fix broken customer search, remove the tab-root **New order** button (black-screen risk), restore post-save actions, and simplify visual chrome (no card frames, fewer helper lines).

## UX contract

| Area | Behavior |
|------|----------|
| **Customer search** | Flat `TextField`; matches update **while typing** via `ValueListenableBuilder` on the search controller (no parent `setState` per keystroke). Tap result selects customer. Keyboard stays open while searching. **One** path to add a new customer: type a name (save creates) or tap the single “use new name” row when no match. |
| **Tab root app bar** | **No New order** button. **Reset** remains (confirm dialog). |
| **Layout** | Edge-to-edge scroll body (`8px` horizontal or safe-area minimum). No `Card` wrappers on composer sections. No filled `SearchBar` chrome. |
| **Garments** | `FilterChip` with garment icons; no selected-count subtitle or duplicate error lines. |
| **Garment blocks** | No outer `Card`; garment title row only (no redundant Measurements/Style/Fabric sub-headers). `PrideOptionalPanel` only for empty optional **fields**, not whole bordered cards. |
| **Style shapes** | Compact grid: **4–5 columns** on typical phone width; smaller thumbnails; **no tile borders**; selection + size/detail options unchanged. |
| **Post-save (new order)** | Snackbar → **post-save bottom sheet** (print, view/share PDF, open detail) → **then** reset form to defaults. **No** `context.go('/app/orders')` on tab root (already there; re-navigation caused black screen). |
| **Edit save (tab root)** | Success snackbar → post-save sheet → reset form (same as new). |
| **Edit save (pushed route)** | Snackbar → navigate to order detail (unchanged). |

## Root cause: keyboard dismiss

`OrderComposerScreen.build` called `setState` on every search keystroke (`SearchBar.onChanged`), rebuilding the full `Scaffold` + `ListView` + nested result `ListView`. That recreates the search field and drops focus. Fix: isolate customer search UI in a child widget using `ValueListenableBuilder` on `_customerSearchController`.

## Section order (unchanged)

Same as plan-26: customer → garments → per-garment panels → delivery → payment → (recent orders when not tab root).

## Files

- `lib/features/orders/order_composer_screen.dart` — search fix, compact layout, post-save, remove New order
- `lib/features/orders/order_composer_receipt_garment_block.dart` — flat garment sections
- `lib/features/orders/order_composer_style_sheet.dart` — denser figure grid
- `lib/features/orders/order_composer_shape_select_tile.dart` — borderless compact tiles
- `lib/features/orders/order_composer_measurements_panel.dart` — panel-level optional hint only
- `lib/features/orders/order_composer_fabric_panel.dart` — remove redundant sub-headers
- `test/order_composer_shape_grid_test.dart` — updated column expectations

## Out of scope

- Customers tab orders list layout
- Removing `OrderDetailScreen`
- Changing save validation rules (customer name required, etc.)
