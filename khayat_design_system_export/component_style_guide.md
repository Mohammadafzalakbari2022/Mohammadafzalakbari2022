# Component Style Guide — Khayat Design System

Per-component visual specification with source references. Adapt names/branding for AFMS; keep measurements and colors.

---

## Primary button

**Visual**: Violet filled pill, white label, no shadow.

| Property | Value |
|----------|-------|
| Widget | `FilledButton` via `PrideSaveButton` or `prideButtonStyle(..., primary)` |
| Background | `colorScheme.primary` (`#7C3AED` light) |
| Foreground | `colorScheme.onPrimary` |
| Padding | 20×12 (variant helper) or 22×14 (theme default) |
| Min size | 64×44 |
| Radius | 12 |
| Elevation | 0 |
| Disabled | Material default (muted) |

**Source**: `lib/app/app_theme.dart` (`filledButtonTheme`, `prideButtonStyle`), `lib/core/widgets/pride_action_buttons.dart` (`PrideSaveButton`)

---

## Secondary button

**Visual**: In Khayat, "secondary" actions use **semantic colors** rather than `colorScheme.secondary`. For neutral secondary confirmations, use **Edit (blue)** or default outlined cancel.

| Variant | Colors |
|---------|--------|
| Edit (common secondary action) | Fill `#2563EB`, on-white |
| Outlined cancel | `cancelContainer` bg, `cancel` border 1.5px |

**Source**: `lib/core/widgets/pride_action_buttons.dart` (`PrideEditButton`, `PrideCancelButton`)

---

## Danger button

**Visual**: Red filled pill, white label.

| Property | Value |
|----------|-------|
| Background | `#DC2626` (light) / `#F87171` (dark) |
| Foreground | white / `#450A0A` |
| Padding | 20×12 |
| Radius | 12 |

**Source**: `lib/core/widgets/pride_action_buttons.dart` (`PrideDeleteButton`, `prideDialogCancelDelete`)

---

## Text button

**Visual**: Primary-colored text, minimal padding, subtle 10px hit area rounding.

| Property | Value |
|----------|-------|
| Foreground | `colorScheme.primary` |
| Padding | 14×10 |
| Radius | 10 |

**Usage**: "Forgot password" on login, dialog dismiss links.

**Source**: `lib/app/app_theme.dart` (`textButtonTheme`), `lib/auth/login_screen.dart`

---

## Icon button

**Visual**: 44×44 tonal square with 12px radius; cancel palette by default.

| Property | Value |
|----------|-------|
| Background | `actions.cancelContainer` |
| Foreground | `actions.onCancelContainer` |
| Disabled fg | onCancelContainer @ 45% alpha |
| Icon size | 22 (theme), 22 (`PrideCloseIconButton`) |
| Padding | 8 (theme) / 10 (`PrideCloseIconButton`) |

**List row icon action** (`PrideIconAction`): 10px radius, 8px padding, variant-specific container colors.

**Source**: `lib/app/app_theme.dart` (`iconButtonTheme`), `lib/core/widgets/pride_close_button.dart`, `lib/core/widgets/pride_action_buttons.dart` (`PrideIconAction`)

---

## Input field

**Visual**: Filled outlined field, 12px corners, subtle gray border; violet 2px border on focus.

| Property | Value |
|----------|-------|
| Filled | true |
| Fill (light) | `surfaceContainerLowest` (white) |
| Fill (dark) | `surfaceContainerLow` |
| Border radius | 12 |
| Enabled border | `outlineVariant` @ 85% |
| Focused border | `primary`, width 2 |
| Label | `onSurfaceVariant` |
| Hint | `onSurfaceVariant` @ 85% |

**Source**: `lib/app/app_theme.dart` (`inputDecorationTheme`)

---

## Search field

**Visual**: Two patterns:

### A. Expandable toolbar search (`CompactSearchToolbar`)

- Collapsed: search icon in toolbar row; turns primary when active
- Expanded: Material 3 `SearchBar` with leading search icon, clear trailing button
- Animation: `AnimatedCrossFade`, 180ms ease
- Padding: toolbar row 12h × 8t

### B. Inline dashboard search

- Standard `TextField` with filled `surfaceContainerLow`, 12px radius, suffix search icon in primary

**Source**: `lib/core/widgets/compact_search_toolbar.dart`, `lib/dashboard/dashboard_drawer.dart`

---

## Dropdown

**Visual**: Inherits `inputDecorationTheme`. Settings language picker uses `DropdownButtonHideUnderline` inside a Card ListTile.

| Property | Value |
|----------|-------|
| Decoration | Same as inputs (label, filled) |
| Items | `DropdownMenuItem` standard text |
| Form variant | `DropdownButtonFormField` (finance category picker) |

**Source**: `lib/features/settings/settings_appearance_language_screen.dart`, `lib/features/shop_finance/shop_finance_hub_screen.dart`

---

## Table

**Visual**: Khayat has no traditional table. Use **list tile rows** instead.

| Property | Value |
|----------|-------|
| Row widget | `ListTile` or custom tile |
| Theme padding | start 16, end 12 |
| Icon color | `onSurfaceVariant` |
| Dividers | `outlineVariant` @ 50%, 1px |

**Source**: `lib/app/app_theme.dart` (`listTileTheme`, `dividerTheme`)

---

## Data row (list tile pattern)

**Visual**: Carved row — 14px rounded rect, inset border, optional selection glow.

| Property | Value |
|----------|-------|
| Outer padding | 10h × 3v |
| Inner padding | 14, 12, 12, 12 |
| Background | `surfaceContainerLow` |
| Selected bg | `primaryContainer` @ 42% |
| Border | `outlineVariant` 1px; selected 1.75px primary @ 55% |
| Shadow (selected) | primary @ 18%, blur 10, offset (0,3) |
| Animation | 220ms easeOutCubic |
| Name badge | `surfaceContainerHigh`, 10px radius, titleMedium w700 |

**Source**: `lib/features/orders/order_list_tile.dart`, `lib/features/customers/customer_list_tile.dart`

---

## List item (settings / nav)

**Visual**: Card wrapping ListTile with colored leading icon and optional chevron.

| Property | Value |
|----------|-------|
| Leading | `PrideColoredLeading` 40×40, 12px radius |
| Icon color | `prideSettingsIconColor(colorIndex)` |
| Chevron | accent @ 70% alpha |
| Card | global cardTheme (16px, bordered) |

**Source**: `lib/core/widgets/pride_nav_card_tile.dart`, `lib/features/settings/settings_tab_screen.dart`

---

## Card

**Visual**: Flat white (light) panel, hairline border, 16px corners.

| Property | Value |
|----------|-------|
| Elevation | 0 |
| Color | `surfaceContainerLowest` |
| Border | `outlineVariant` @ 60%, 1px |
| Radius | 16 |
| Margin | 0 |
| Clip | antiAlias |

**Source**: `lib/app/app_theme.dart` (`cardTheme`)

---

## Dashboard metric card (KPI tile)

**Visual**: Compact tappable stat block with colored border tint.

| Property | Value |
|----------|-------|
| Background | accent @ 6% alpha |
| Border | accent @ 35%, 1px |
| Radius | 14 |
| Padding | 12 |
| Value text | headlineSmall, w800, accent color |
| Label | labelMedium, onSurfaceVariant, w600 |
| Icon | 18px accent; chevron 12px faded |

**Source**: `lib/dashboard/dashboard_widgets.dart` (`DashboardKpiTile`)

---

## Chart card

**Visual**: Section inside dashboard drawer or finance screen — title + chart in bordered section.

### Bar charts (custom)

- Height: 88–120px
- Bars: `primaryContainer` or secondary gradient
- Bar radius: 2–6px
- Day labels: labelSmall, 10px, onSurfaceVariant

### Pie chart (`fl_chart`)

- Height: 180px container
- Section radius: 48
- Colors: primary / secondary / tertiary by category
- Title on slice: 10px white

**Source**: `lib/features/reports/report_daily_income_bars.dart`, `lib/dashboard/dashboard_widgets.dart`, `lib/features/shop_finance/shop_finance_hub_screen.dart`

---

## Dialog

**Visual**: 20px rounded modal, centered icon badge for alerts.

| Property | Value |
|----------|-------|
| Shape radius | 20 |
| Background | `surfaceContainerLowest` |
| Actions padding | 16 bottom/sides |
| Alert icon box | 52×52, 14px radius, semantic color @ 14% bg |
| Title | centered |
| Content | bodyMedium, onSurfaceVariant |
| Actions | centered row; cancel + filled confirm |

**Source**: `lib/app/app_theme.dart` (`dialogTheme`), `lib/core/widgets/pride_alert_dialog.dart`

---

## Snackbar / toast

**Visual**: Floating rounded snackbar; advanced feedback adds top progress bar.

| Property | Value |
|----------|-------|
| Behavior | floating |
| Elevation | 6 |
| Shape radius | 12 |
| Inset | 16h × 12v |
| Success bg | primaryContainer |
| Error bg | errorContainer |
| Info bg | secondaryContainer |
| Progress bar | 3px min height on top of content |

**Source**: `lib/app/app_theme.dart` (`snackBarTheme`), `lib/core/feedback/app_feedback.dart`

---

## Empty state

**Visual**: Centered text, optional primary CTA.

| Property | Value |
|----------|-------|
| Padding | 24 |
| Title | titleMedium, centered |
| CTA gap | 16 below title |
| CTA | emerald FilledButton.icon (add variant) |

No illustrations or Lottie — text + button only.

**Source**: `lib/features/customers/customers_list_body.dart`, `lib/features/catalog/catalog_tab_screen.dart`

---

## Loading state

**Visual**: Two tiers.

### Full-page async

- Centered `CircularProgressIndicator` (theme primary)

### Inline auth / form loading

- Card on `primaryContainer`
- 22px circular indicator (stroke 2.5)
- titleSmall w600 title
- 4px linear progress bar below
- Optional bodySmall hint

**Source**: `lib/auth/auth_form_feedback_banner.dart`, `lib/features/shop_finance/shop_finance_hub_screen.dart` (and most `AsyncValue.when`)

---

## Error state

**Visual**: Two tiers.

### Auth inline error

- Card on `errorContainer`
- Leading `error_outline_rounded`, onErrorContainer
- bodyMedium w500 message

### Async error (simple)

- Centered plain `Text('$e')` — minimal styling (candidate for AFMS improvement while keeping palette)

**Source**: `lib/auth/auth_form_feedback_banner.dart`

---

## Bottom sheet (bonus — common pattern)

| Property | Value |
|----------|-------|
| API | `showModalBottomSheet` |
| Flags | `isScrollControlled: true`, `showDragHandle: true` |
| Padding | 16 horizontal, SafeArea wrapped |
| Title | titleLarge at top |
| Filters | FilterChip wraps, 8px spacing |

**Source**: `lib/features/orders/orders_list_filter_sheet.dart`

---

## Hero summary card (detail screens)

**Visual**: 20px gradient panel at top of detail views.

| Property | Value |
|----------|-------|
| Radius | 20 |
| Gradient | status/secondary tint → primaryContainer @ 35% |
| Border | semantic color @ 35–45%, 1.25px |
| Icon box | 48×48, 14px radius, white surface |
| Padding | 16 |

**Source**: `lib/features/orders/order_detail_hero_card.dart`, `lib/features/customers/customer_profile_hero_card.dart`

---

## Segmented control (theme / calendar)

**Visual**: Material 3 `SegmentedButton` with default theme styling from ColorScheme.

**Source**: `lib/features/settings/settings_appearance_language_screen.dart`

---

## Filter chip

**Visual**: Inherits global `chipTheme` — 10px radius, surfaceContainerLow/High fill, outlineVariant border.

**Source**: `lib/app/app_theme.dart` (`chipTheme`), `lib/features/orders/orders_list_filter_sheet.dart`
