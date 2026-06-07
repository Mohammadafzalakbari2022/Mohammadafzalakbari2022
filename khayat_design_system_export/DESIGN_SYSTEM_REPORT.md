# Khayat Design System Report

> Extracted from the **Khayat** Flutter app (`pride_v3`). UI/design only — no business logic.

---

## Design philosophy

Khayat follows a **Material 3, mobile-first, vibrant-but-clean** aesthetic tuned for Afghan tailoring shops:

- **Airy surfaces** — light gray-blue backgrounds (`#F8FAFC`) with white cards; dark mode uses deep blue-gray (`#12131A`) rather than pure black.
- **Violet primary identity** — seed color `#7C3AED` anchors brand, selection, and focus states.
- **Semantic color language** — every action type (add, edit, delete, cancel, warning, payment) has a dedicated hue so users learn meaning through color, not labels alone.
- **Flat cards, soft borders** — elevation is almost always `0`; depth comes from `outlineVariant` borders and subtle tinted fills.
- **Carved sections** — list/detail content sits in 14px rounded panels with `surfaceContainerLow` fills, giving a layered “inset” look.
- **Icon-led navigation** — settings and reports use colored circular icon badges (`PrideColoredLeading`) cycled from a 10-color palette.
- **RTL-aware, LTR numbers** — UI respects locale direction; money, phone, and numeric fields force LTR for correct cursor behavior.
- **Accessibility-minded motion** — selection animations (~220ms), keyboard-safe form bars, reduce-motion respected in snackbar progress animation.

---

## Visual style summary

| Aspect | Style |
|--------|-------|
| Design system | Material 3 (`useMaterial3: true`) |
| Density | Standard `VisualDensity` |
| Corners | 12px inputs/buttons, 14px lists/sections, 16px cards, 20px dialogs/heroes |
| Shadows | Minimal; selected list rows get soft primary glow |
| Icons | Material Icons — outlined default, filled when active |
| Charts | Mix of custom `Container` bars + `fl_chart` pie (finance only) |
| Typography | Material 2021 defaults (no custom UI font family) |
| Navigation | Bottom `NavigationBar` (72px) + optional wide drawer dashboard |

---

## Color palette

### Brand & scheme (light)

| Token | Hex | Usage |
|-------|-----|-------|
| Primary | `#7C3AED` | Buttons, focus rings, selection accents |
| Primary container | `#EDE9FE` | Nav indicator, loading banners, snackbar success |
| Secondary | `#0D9488` | Teal accent, payment actions, income charts |
| Tertiary | `#EA580C` | Orange accent, catalog tab |
| Surface | `#F8FAFC` | Scaffold background |
| Surface container low | `#F1F5F9` | App bar, carved sections, list tiles |
| On surface | `#0F172A` | Primary text |
| On surface variant | `#475569` | Secondary text, icons |
| Outline variant | `#CBD5E1` | Borders, dividers |

### Brand & scheme (dark)

| Token | Hex | Usage |
|-------|-----|-------|
| Primary | `#A78BFA` | Lighter violet for dark surfaces |
| Primary container | `#5B21B6` | Selected nav, containers |
| Surface | `#12131A` | Scaffold |
| Surface container low | `#181924` | App bar, panels |
| On surface | `#E8EDF4` | Primary text |

### Semantic action colors (`PrideActionColors`)

| Variant | Light fill | Meaning |
|---------|------------|---------|
| Add | `#059669` emerald | Create / FAB |
| Edit | `#2563EB` blue | Modify |
| Delete | `#DC2626` red | Destructive |
| Cancel | `#64748B` slate outlined | Dismiss / neutral |
| Warning | `#D97706` amber | Alerts |
| Payment | `#0D9488` teal | Money / ledger |
| Primary | `colorScheme.primary` | Save / confirm |

Each variant also has `*Container` / `on*Container` pairs for tonal backgrounds (icon actions, chips).

### Navigation tab palette (index 0–4)

`#7C3AED`, `#2563EB`, `#EA580C`, `#0D9488`, `#64748B`

### Settings icon palette (index 0–9, cycles)

Violet, emerald, blue, teal, orange, pink, yellow, red, indigo, cyan.

---

## Light theme details

Built by `buildPrideLightTheme()` in `lib/app/app_theme.dart`:

- `ColorScheme.fromSeed` with vibrant variant, then manual surface/error overrides
- Scaffold: `scheme.surface`
- App bar: `surfaceContainerLow`, scrolled elevation `0.5`
- Cards: white (`surfaceContainerLowest`), 16px radius, hairline border
- Inputs: filled white, 12px radius, 2px primary focus border
- FAB: emerald (`actions.add`), 16px radius, elevation 4

---

## Dark theme details

Built by `buildPrideDarkTheme()`:

- Same structure as light with dark surface stack (`#0C0D12` → `#32374A`)
- App bar scrolled elevation `1`
- Input fill: `surfaceContainerLow` instead of white
- Semantic action colors shift to lighter fills with dark on-colors

---

## System theme behavior

- Default: **`ThemeMode.system`** — follows OS light/dark
- Persisted in SharedPreferences key `pride_theme_mode`
- User selects via **SegmentedButton** (System / Light / Dark) on Appearance settings screen
- No custom `ThemeMode` scheduling or time-based switching

---

## Typography and fonts

### In-app UI

- **No custom font registered in `pubspec.yaml` fonts section**
- Uses `Typography.material2021(platform: TargetPlatform.android)` black/white text themes
- Body and display colors forced to `colorScheme.onSurface`
- Common weight overrides in widgets: `w700` section titles, `w800` KPI values, `w600` meta text

### PDF-only fonts (not app UI)

| Asset | Use |
|-------|-----|
| `assets/fonts/NotoNaskhArabic-Regular.ttf` | Arabic body in invoices |
| `assets/fonts/Vazirmatn-Bold.ttf` | Emphasis in invoices |
| `assets/fonts/Vazirmatn-Regular.ttf` | Latin fallback in PDF |

---

## Spacing and sizing

Khayat uses an **informal 4/8/12/16/24 grid** (not a formal token class):

| Token | Value | Typical use |
|-------|-------|-------------|
| xs | 4 | Tight gaps, bar chart spacing |
| sm | 8 | Section gaps, icon-text spacing |
| md | 12 | Button vertical padding, inner section gaps |
| lg | 16 | Page padding, card padding, bottom bar |
| xl | 24 | Settings section breaks, login padding |

**Touch targets**: buttons min 44px height; icon buttons 44×44.

**Form layout**: `prideFormScrollPadding` = 16px sides + 96px bottom reserve for sticky footer.

---

## Border radius rules

| Element | Radius |
|---------|--------|
| Buttons, inputs, icon buttons | 12 |
| Text buttons, chips, icon actions | 10 |
| List tiles, carved sections, KPI tiles | 14 |
| Cards, FAB, settings groups, dashboard sections | 16 |
| Dialogs, hero summary cards | 20 |
| Login logo clip | 36 |

---

## Shadow / elevation rules

| Component | Elevation / shadow |
|-----------|-------------------|
| Cards | 0 |
| Filled buttons | 0 |
| FAB | 4 (highlight 8) |
| App bar (scrolled) | 0.5 light / 1 dark |
| SnackBar | 6, floating |
| Guide banner | 8 |
| Selected list row | Custom: primary @ 18% alpha, blur 10, offset (0,3) |
| Login logo | primary @ 18%, blur 28, offset (0,10) |

---

## Button styles

See `component_style_guide.md` for per-component detail.

Summary:

- **Primary / Save**: violet filled, 12px radius, h=44 min
- **Add**: emerald filled (+ FAB)
- **Edit**: blue filled
- **Delete**: red filled
- **Cancel**: slate outlined with filled neutral background
- **Payment**: teal filled
- **Text**: primary color, 10px radius
- **Icon (theme)**: cancelContainer circle, 44×44

Dialog footers use `prideDialogCancelSave` / `prideDialogCancelDelete` helpers.

---

## Input / form styles

- `InputDecorationTheme`: filled, 12px `OutlineInputBorder`
- Enabled border: `outlineVariant` @ 85% alpha
- Focused border: `primary`, 2px width
- Label: `onSurfaceVariant`; hint slightly faded
- Money/phone fields: LTR direction, digit normalizer support
- Sticky bottom bars: `KeyboardSafeBottomBar` + `PrideFormBottomBar`
- Dropdowns: standard `DropdownButton` / `DropdownButtonFormField` inheriting input theme

---

## Table styles

**No `DataTable` widget used.** Tabular data appears as:

- Custom bordered list tiles (`OrderListTile`, `CustomerListTile`)
- `ListTile` inside cards (settings, finance lists)
- `ListTileTheme`: start padding 16, end 12, min vertical 12

---

## List styles

- Vertical list with **10px horizontal / 3px vertical** outer padding per row
- Tile: 14px radius, `surfaceContainerLow` background, 1px `outlineVariant` border
- **Two-tap selection pattern**: first tap selects (highlight), second tap navigates
- Selected state: `primaryContainer` @ 42%, primary border @ 55%, optional check icon
- Animated transition: 220ms `easeOutCubic`
- Name displayed in inset badge: `surfaceContainerHigh`, 10px radius

---

## Card styles

Global `cardTheme`:

- Color: `surfaceContainerLowest`
- Elevation: 0
- Shape: 16px rounded rect + `outlineVariant` border @ 60% alpha
- Margin: zero (screens control spacing)
- `clipBehavior: antiAlias`

Settings sections wrap children in a **16px bordered group** with primary-tinted border (1.5px @ 38% alpha).

---

## Dashboard widget styles

| Widget | Description |
|--------|-------------|
| `DashboardHeader` | Primary→secondary gradient, 48px icon box, headline title |
| `DashboardSection` | Bordered 16px card, tinted header strip with icon |
| `DashboardKpiTile` | 14px tile, color-tinted fill @ 6%, bordered, tappable |
| `DashboardOrderPipelineChart` | Horizontal stacked bar, purple/blue/green segments |
| `DashboardRecentIncomeBars` | 7-day gradient teal bars |
| `DashboardQuickLinkChip` | `ActionChip` with tinted background |

Drawer width: **92% of screen**.

---

## Chart / diagram styles

| Chart | Implementation | Colors |
|-------|----------------|--------|
| Daily income (reports) | Custom `Container` bars, h=120 | `primaryContainer` |
| Dashboard 7-day income | Gradient bars, h=88 | `secondary` → `secondaryContainer` |
| Order pipeline | Horizontal flex segments, h=14 | `#7C3AED`, `#2563EB`, `#059669` |
| Expense pie (finance) | `fl_chart` `PieChart`, r=48 | primary / secondary / tertiary |
| Legend dots | 10px circles + labelSmall text | Segment colors |

Bar corner radii: 2px (report), 6px (dashboard), 8px (pipeline clip).

---

## Icon pack and usage rules

- **Pack**: Flutter Material Icons (`Icons.*`)
- **Dependency**: `cupertino_icons` in pubspec (minimal; Material dominates)
- **Pattern**: `*_outlined` when inactive; filled variant when selected/active
- **Nav tabs**: per-tab color from `prideNavTabColor`, inactive @ 72% alpha
- **Settings/menu**: `PrideColoredLeading` — 40×40 box, 12px radius, icon color @ 14% alpha background
- **Chevrons**: trailing chevron tinted to match tile accent @ 70% alpha
- **App bar**: dashboard menu icon uses `scheme.primary`

Khayat brand launcher icons live in `assets/branding/` and `khayat_dari_clean_needle_icon_pack/` — **do not migrate to AFMS**.

---

## Navigation / sidebar / header style

### Bottom navigation

- Widget: `NavigationBar` (not deprecated `BottomNavigationBar`)
- Height: 72
- Background: `surfaceContainerLowest`
- Indicator: `primaryContainer`
- Selected icon: `primary`, 26px; unselected: `onSurfaceVariant`, 24px

### App bar

- Background: `surfaceContainerLow`
- Title: shop name + logo on primary tabs; module title when nested
- Leading: dashboard icon (opens drawer) or `AppBackButton`
- No center title

### Drawer / dashboard

- Full-height drawer, shop branding header (`primaryContainer` strip)
- Scrollable sections using `DashboardSection`
- Quick actions, KPIs, search, notifications preview

---

## Loading / error / empty state styles

### Loading

- Full screen: centered `CircularProgressIndicator` (default primary)
- Auth forms: `AuthFormFeedbackBanner` — `primaryContainer` card + circular + linear progress
- Riverpod `AsyncValue.when(loading: ...)` pattern throughout

### Error

- Auth: `AuthFormFeedbackBanner` — `errorContainer` card + `error_outline` icon
- Async screens: plain centered `Text('$e')` (minimal styling)
- Inline license banners: `errorContainer` material strip in drawer

### Empty

- Centered `titleMedium` message, 24px padding
- Optional CTA: emerald `FilledButton.icon` (add customer, etc.)
- Catalog/orders: text-only empty states, no illustration assets

### Snackbar feedback

| Kind | Background | Foreground |
|------|------------|------------|
| Success | `primaryContainer` | `onPrimaryContainer` |
| Error | `errorContainer` | `onErrorContainer` |
| Info | `secondaryContainer` | `onSecondaryContainer` |

Floating behavior, optional animated progress bar on top edge.

---

## Responsive layout behavior

Khayat is **mobile-first**. No `responsive_framework` or adaptive scaffold.

| Behavior | Rule |
|----------|------|
| Drawer width | 92% screen width |
| Catalog grid columns | 2 / 3 / 4 based on width (<360, <600, else) |
| Style figure grid | 2 / 3 / 4 (<400, <700, else) |
| Bottom sheets | `isScrollControlled: true`, `showDragHandle: true` |
| Keyboard | Bottom bars animate padding; forms avoid double keyboard inset |
| Web | Same UI; some features disabled with explanatory text (not a separate web theme) |
| Tablet/desktop | Layouts stretch; grids gain columns; no sidebar replacement for bottom nav |

---

## Important implementation files

| Priority | File |
|----------|------|
| ★★★ | `lib/app/app_theme.dart` |
| ★★★ | `lib/app/afghan_pride_app.dart` |
| ★★ | `lib/features/settings/settings_providers.dart` (theme mode) |
| ★★ | `lib/features/settings/settings_appearance_language_screen.dart` |
| ★★ | `lib/core/widgets/pride_action_buttons.dart` |
| ★★ | `lib/core/widgets/pride_carved_section.dart` |
| ★★ | `lib/core/widgets/pride_nav_card_tile.dart` |
| ★★ | `lib/core/feedback/app_feedback.dart` |
| ★ | `lib/shell/app_shell.dart` |
| ★ | `lib/dashboard/dashboard_widgets.dart` |
| ★ | `lib/dashboard/dashboard_drawer.dart` |
| ★ | `lib/features/orders/order_list_tile.dart` |
| ★ | `lib/features/customers/customer_list_tile.dart` |
| ★ | `lib/auth/login_screen.dart` (layout reference) |
| ★ | `lib/auth/auth_form_feedback_banner.dart` |

See `ui_file_map.md` for the complete file inventory.
