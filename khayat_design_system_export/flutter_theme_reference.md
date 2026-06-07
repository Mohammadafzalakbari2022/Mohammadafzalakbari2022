# Flutter Theme Reference — Khayat Design System

This document explains **how the Khayat app wires Flutter theming**, so AFMS / Station Pro can replicate the same architecture without copying business logic.

---

## Where `ThemeData` is created

All theme construction lives in a **single file**:

| File | Role |
|------|------|
| `lib/app/app_theme.dart` | Defines `buildPrideLightTheme()`, `buildPrideDarkTheme()`, `PrideActionColors`, button helpers, icon palettes |

There are no separate light/dark theme files. Both themes call a private `_buildTheme(ColorScheme, Brightness, PrideActionColors)`.

---

## How `ColorScheme` is used

1. **Seed generation**: Both themes start from:

```dart
ColorScheme.fromSeed(
  seedColor: Color(0xFF7C3AED),
  brightness: Brightness.light, // or .dark
  dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
)
```

2. **Manual overrides**: The generated scheme is heavily customized via `.copyWith(...)` for primary/secondary/tertiary, all surface containers, outline, onSurface, error, etc.

3. **Runtime access**: Widgets read colors through:

```dart
final scheme = Theme.of(context).colorScheme;
```

4. **Semantic actions** (separate from ColorScheme): A `ThemeExtension`:

```dart
final actions = Theme.of(context).extension<PrideActionColors>()!;
```

Registered in `_buildTheme`:

```dart
extensions: [actions],
```

---

## Light / dark / system mode handling

### App root

`lib/app/afghan_pride_app.dart`:

```dart
MaterialApp.router(
  theme: buildPrideLightTheme(),
  darkTheme: buildPrideDarkTheme(),
  themeMode: themeMode, // from Riverpod
  ...
)
```

### State + persistence

| Piece | File |
|-------|------|
| Provider | `themeModeProvider` in `lib/features/settings/settings_providers.dart` |
| Read on launch | `themeModeFromPrefs(prefs)` in `lib/main.dart` |
| Persist on change | `persistThemeMode(prefs, mode)` |
| SharedPreferences key | `pride_theme_mode` (stores `ThemeMode.name`) |
| Default | `ThemeMode.system` |

### User control

`lib/features/settings/settings_appearance_language_screen.dart` uses:

```dart
SegmentedButton<ThemeMode>(
  segments: [system, light, dark],
  selected: {themeMode},
  onSelectionChanged: (s) { ... persist ... },
)
```

---

## Providers / controllers that manage theme mode

| Provider | Type | Default | Purpose |
|----------|------|---------|---------|
| `themeModeProvider` | `StateProvider<ThemeMode>` | `ThemeMode.system` | Active theme mode |
| `sharedPreferencesProvider` | Riverpod override | from `main()` | Persistence backing store |

Theme mode is **not** tied to auth, sync, or licensing. It is a pure UI preference.

---

## How styles are reused across widgets

### 1. Global `ThemeData` component themes

Defined once in `_buildTheme()` and inherited automatically:

- `appBarTheme`
- `cardTheme`
- `navigationBarTheme`
- `filledButtonTheme` / `outlinedButtonTheme` / `textButtonTheme`
- `iconButtonTheme`
- `inputDecorationTheme`
- `dialogTheme`
- `snackBarTheme`
- `listTileTheme`
- `dividerTheme`
- `chipTheme`
- `switchTheme` / `radioTheme`
- `floatingActionButtonTheme`

### 2. Helper functions (copy to AFMS)

| Helper | Purpose |
|--------|---------|
| `prideButtonStyle(context, PrideButtonVariant)` | Semantic filled/outlined buttons |
| `prideLedgerTonalButtonStyle(context)` | Payment/teal actions |
| `prideNavTabColor(index)` | Bottom nav icon accent per tab |
| `prideSettingsIconColor(index)` | Settings/nav tile icon cycling palette |
| `prideCarvedDecoration(scheme)` | 14px carved panel border/fill |

### 3. Shared widget library (`lib/core/widgets/`)

These encapsulate repeated visual patterns:

| Widget | Visual role |
|--------|-------------|
| `PrideColoredLeading` | 40×40 rounded icon badge |
| `PrideNavCardTile` | Card + ListTile navigation row |
| `PrideCancelButton` / `PrideSaveButton` / `PrideAddButton` / etc. | Semantic buttons |
| `PrideIconAction` | Tonal circle icon button in lists |
| `PrideCarvedSection` / `PrideCarvedPanel` | Expandable/static carved sections |
| `PrideAlertDialog` + `showPrideAlertDialog` | Icon-led centered dialogs |
| `PrideFormBottomBar` + `KeyboardSafeBottomBar` | Form footers above keyboard |
| `CompactSearchToolbar` | Expandable search row |
| `AuthFormFeedbackBanner` | Loading/error inline cards (auth forms) |

### 4. Feedback / snackbars

`lib/core/feedback/app_feedback.dart`:

- `showPrideSnack` / `showAppFeedback` map `AppFeedbackKind` → container colors from `ColorScheme`
- Uses floating `SnackBar` with optional animated progress bar

### 5. Typography

No custom `fontFamily` in `ThemeData`. Uses:

```dart
Typography.material2021(platform: TargetPlatform.android).black // or .white
  .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface)
```

RTL locales rely on Flutter localization; numeric fields force LTR via `PrideLtrInput`.

---

## Files to copy or reimplement in AFMS

### Copy directly (rename `Pride` → your prefix if desired)

| File | Notes |
|------|-------|
| `lib/app/app_theme.dart` | **Core** — entire design token system |
| `lib/core/widgets/pride_action_buttons.dart` | Depends only on `app_theme.dart` |
| `lib/core/widgets/pride_alert_dialog.dart` | Pure UI |
| `lib/core/widgets/pride_nav_card_tile.dart` | Pure UI |
| `lib/core/widgets/pride_carved_section.dart` | Pure UI |
| `lib/core/widgets/pride_close_button.dart` | Pure UI |
| `lib/core/widgets/app_back_button.dart` | Pure UI |
| `lib/core/widgets/keyboard_safe_bottom_bar.dart` | Pure UI |
| `lib/core/widgets/pride_form_bottom_bar.dart` | Pure UI (+ scroll padding helper) |
| `lib/core/widgets/compact_search_toolbar.dart` | Pure UI |
| `lib/core/input/pride_ltr_input.dart` | Pure UI |
| `lib/core/feedback/app_feedback.dart` | UI + sound bridge — strip sound if not needed |
| `lib/dashboard/dashboard_widgets.dart` | Dashboard visual components (rename/refactor labels) |

### Reimplement the pattern (not copy verbatim)

| Area | Why |
|------|-----|
| `lib/shell/app_shell.dart` | Mixed with Khayat routes, shop name, sync, notifications |
| `lib/dashboard/dashboard_drawer.dart` | Heavy business KPI wiring |
| List tiles (`order_list_tile.dart`, `customer_list_tile.dart`) | Domain-specific content; **copy styling pattern only** |
| Hero cards (`order_detail_hero_card.dart`, `customer_profile_hero_card.dart`) | Copy gradient/border structure, replace content |
| `lib/auth/login_screen.dart` | Copy layout/spacing; replace auth logic and branding assets |
| Settings providers | Copy `themeModeProvider` + persistence helpers only |

### Wire theme in AFMS app root (pattern)

1. Create `buildXxxLightTheme()` / `buildXxxDarkTheme()` from Khayat's `app_theme.dart`
2. Add `themeModeProvider` + SharedPreferences persistence
3. In root `MaterialApp`:

```dart
theme: buildXxxLightTheme(),
darkTheme: buildXxxDarkTheme(),
themeMode: ref.watch(themeModeProvider),
```

---

## Files NOT to copy (business logic mixed in)

| Category | Examples |
|----------|----------|
| Data / repositories | `lib/data/**` |
| API clients | `lib/core/api/**` |
| Auth | `lib/auth/auth_providers.dart`, session storage, login API calls |
| Licensing | `lib/licensing/**` |
| Sync | `lib/core/sync/**` |
| Order/customer/catalog features | `lib/features/orders/**`, `customers/**`, `catalog/**` |
| Shop profile / finance models | `lib/features/settings/shop_profile_*`, `shop_finance/**` |
| Printing / PDF fonts | `lib/core/printing/**` (PDF-specific, not app UI theme) |
| Localization strings | `lib/l10n/**` (Khayat-specific copy) |
| Router | `lib/router/app_router.dart` |
| Brand assets | `assets/branding/*`, `khayat_dari_clean_needle_icon_pack/` |

---

## Recommended AFMS migration order

1. Port `app_theme.dart` + rename prefix
2. Hook `themeModeProvider` + appearance settings screen segment
3. Port `core/widgets` button/card/toolbar library
4. Restyle AFMS shell (app bar, bottom nav, drawer) using `app_shell.dart` as visual reference
5. Apply list tile + hero card patterns to AFMS list/detail screens
6. Port snackbar feedback colors from `app_feedback.dart`
7. Add `fl_chart` only if AFMS needs pie charts; bar charts can stay custom Container-based
