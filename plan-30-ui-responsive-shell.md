# Plan 30 — Responsive shell and tablet layouts

## Goal

One Android APK (phone + tablet) and compile-safe iOS/iPad layouts with **Material 3 breakpoints**: compact phone, tablet-wide content, and **NavigationRail** on web / desktop-width shells — without breaking auth, license guards, or dashboard drawer behavior.

## Breakpoints (canonical)

| Token | Width | Use |
|-------|-------|-----|
| **Compact** | `< 600` | Phone: bottom `NavigationBar`, single-column composer, 12px list inset |
| **Tablet** | `600 … 899` | Wider grids, two-column order composer, **8px** horizontal inset (plan-28 density) |
| **Desktop / shell rail** | `≥ 900` **or** `kIsWeb` | Persistent `NavigationRail` + `VerticalDivider`; bottom nav hidden |
| **Wide rail** | `≥ 1200` | `NavigationRail(extended: true)` with labels |

Helpers live in `lib/app/responsive_breakpoints.dart`.

## Shell (plan-19 + plan-16)

- **Mobile (`< 900`, not web):** unchanged five-tab bottom nav.
- **Web or wide:** `NavigationRail` at the **start** edge (RTL-safe via directional `Row`); tab icons/labels shared with bottom nav via `lib/shell/shell_nav_destinations.dart`.
- **Dashboard drawer:** still on `Scaffold.drawer`; hamburger / title tap on primary tabs unchanged.
- **No route changes** — `StatefulShellRoute.indexedStack` branches unchanged.

## Orders composer (plan-11 / plan-28 / plan-29)

| Width | Layout |
|-------|--------|
| `< 600` | Single `ListView` (existing compact flow) |
| `≥ 600` | `SingleChildScrollView` + `Row`: **meta + payment** (flex 2) beside **garment blocks** (flex 3) |
| Shape grid | `orderComposerShapeGridColumns`: up to **7** columns at `≥ 900` |

Padding: `prideComposerScrollPadding` — safe-area aware, 8px on tablet.

## Lists (orders, customers)

- `CompactSearchToolbar`, filter chips, and primary CTAs use `prideContentHorizontalPadding` / `prideListScreenPadding`.
- Tablet uses **full width** with modest inset (not centered phone column with huge side gutters).

## Files

- `lib/app/responsive_breakpoints.dart` — breakpoints + padding helpers
- `lib/shell/app_shell.dart` — rail vs bottom nav
- `lib/shell/shell_nav_destinations.dart` — shared tab destinations
- `lib/features/orders/order_composer_screen.dart` — tablet two-column body
- `lib/features/orders/order_composer_shape_select_tile.dart` — wider shape grid
- `lib/features/orders/orders_filtered_list_body.dart` — responsive list inset
- `lib/features/customers/customers_list_body.dart` — responsive list inset
- `lib/core/widgets/compact_search_toolbar.dart` — responsive search row inset
- `test/responsive_breakpoints_test.dart`

## Out of scope

- Separate tablet APK or flavor
- Split master/detail navigation for order detail on tablet (future)
- Changing auth/license redirect logic

## QA checklist

- [ ] Phone: bottom tabs, composer single column, keyboard stable on customer search
- [ ] Tablet emulator (~800dp): composer side-by-side, lists edge-to-edge with 8px inset
- [ ] Web / width ≥ 900: rail visible, drawer opens, RTL tab order correct
- [ ] `flutter analyze` clean; `flutter test test/responsive_breakpoints_test.dart test/order_composer_shape_grid_test.dart`
