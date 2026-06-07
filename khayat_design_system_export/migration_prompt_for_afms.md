# Migration Prompt for AFMS / Station Pro

Copy everything below the line into a new Cursor chat in your **AFMS / Station Pro** project. Attach or paste the contents of the `khayat_design_system_export` folder from the Khayat repo.

---

## PROMPT START

You are working on **AFMS / Station Pro**, a Flutter business management app (sales, inventory, finance, branches, reports, settings).

I am providing the extracted **Khayat app design system** documentation from another project (`khayat_design_system_export/`). Your job is to **apply the Khayat visual design language to AFMS** while preserving all existing AFMS functionality.

### Read these reference files first

- `DESIGN_SYSTEM_REPORT.md` — full human-readable design spec
- `design_tokens.json` — machine-readable tokens
- `flutter_theme_reference.md` — how ThemeData is wired in Flutter
- `component_style_guide.md` — per-component specs
- `ui_file_map.md` — what to copy vs reimplement
- `dependency_ui_report.md` — pubspec UI packages
- `screens_to_compare.md` — screens to visually match

### Hard requirements

1. **Apply Khayat design style** — Material 3, violet primary (`#7C3AED`), airy surfaces, flat bordered cards, semantic action colors (add/edit/delete/cancel/warning/payment), carved 14px sections, colored icon leading badges, bottom NavigationBar at 72px, dashboard drawer pattern where applicable.

2. **Keep Station Pro branding** — use AFMS logo, icon pack, app name, subtitle, and tagline. Do **not** import Khayat needle icon, Khayat shop branding assets, or Khayat product name in UI strings.

3. **Do not copy Khayat business logic** — no orders/customers/catalog/tailoring/measurements/sync/licensing code. No Khayat API endpoints, models, or feature screens.

4. **Adapt style to AFMS modules** — apply the same visual patterns to:
   - Sales screens (lists, detail, forms)
   - Inventory screens
   - Finance / ledger screens
   - Branches / stations
   - Reports & charts
   - Settings (including theme picker)
   - Login / auth screens (layout only)

5. **Implement light, dark, and system theme modes** — port `buildPrideLightTheme` / `buildPrideDarkTheme` pattern (rename prefix to AFMS), `ThemeMode` Riverpod provider, SharedPreferences persistence, and a SegmentedButton on settings appearance screen.

6. **Preserve existing AFMS backend/API/auth/business logic** — this is a **UI/theming refactor only**. Do not change API contracts, database schemas, auth flows, or business rules unless a change is strictly required for theming (e.g., wrapping existing screens in themed widgets).

### Implementation plan (follow in order)

**Phase 1 — Theme foundation**
- Create `lib/app/afms_theme.dart` (or equivalent) by porting `lib/app/app_theme.dart` from Khayat:
  - `PrideActionColors` → rename to `AfmsActionColors` (or your prefix)
  - `buildAfmsLightTheme()` / `buildAfmsDarkTheme()`
  - Button helpers: `afmsButtonStyle`, icon color palettes
- Wire in root `MaterialApp`: `theme`, `darkTheme`, `themeMode`
- Add `themeModeProvider` + SharedPreferences persist/restore

**Phase 2 — Shared widget library**
Port these Khayat widgets (rename prefix, adjust imports):
- Action buttons (`PrideSaveButton`, `PrideAddButton`, etc.)
- `PrideNavCardTile` → navigation cards for reports/settings hubs
- `PrideCarvedSection` / `PrideCarvedPanel` → form sections
- `CompactSearchToolbar` → list search bars
- `KeyboardSafeBottomBar` + form bottom bar
- `showAfmsAlertDialog` pattern
- Snackbar feedback colors from `app_feedback.dart`

**Phase 3 — Shell & navigation**
- Restyle AFMS main shell to match Khayat:
  - AppBar: `surfaceContainerLow` background, shop/station branding row
  - Bottom `NavigationBar` height 72, per-tab accent colors
  - Optional side drawer for dashboard KPIs (if AFMS has equivalent)
- Use Material Icons outlined/filled pattern

**Phase 4 — Lists & details**
- Apply Khayat list tile pattern to AFMS data rows:
  - 14px radius, `surfaceContainerLow`, selection highlight with primary glow
  - Name badge inset, meta rows with 16px icons
- Apply hero card gradient pattern to AFMS detail headers

**Phase 5 — Forms & dialogs**
- Ensure all `InputDecoration` inherits themed borders (12px, filled, primary focus)
- Dialogs: 20px radius, centered actions, semantic buttons
- Bottom sheets: `showDragHandle: true`, 16px padding

**Phase 6 — Reports & charts**
- Custom bar charts: use Container gradient pattern from Khayat reports
- If AFMS needs pie charts: add `fl_chart` and use primary/secondary/tertiary slice colors
- Report hub: `PrideNavCardTile`-style cards with live subtitles

**Phase 7 — States**
- Loading: centered `CircularProgressIndicator` or primaryContainer banner for forms
- Error: `errorContainer` cards for inline errors
- Empty: centered titleMedium + emerald add CTA
- Snackbars: floating, semantic container colors

**Phase 8 — Settings appearance**
- Add/update appearance screen with ThemeMode SegmentedButton (System / Light / Dark)
- Match Khayat settings section styling (16px bordered groups, colored leading icons)

### Visual acceptance criteria

Compare AFMS screens side-by-side with Khayat references listed in `screens_to_compare.md`:

- [ ] Light theme: violet primary, white cards, slate text hierarchy
- [ ] Dark theme: deep blue-gray surfaces, lighter violet primary
- [ ] System theme follows OS
- [ ] Buttons use semantic colors (green add, blue edit, red delete, slate cancel)
- [ ] Cards have 0 elevation + hairline border
- [ ] List rows match carved/selection animation feel
- [ ] App bar and bottom nav match Khayat proportions
- [ ] Snackbars use container color coding
- [ ] AFMS branding visible (not Khayat)

### Do NOT do

- Copy `lib/data/**`, `lib/core/api/**`, `lib/auth/**` business files from Khayat
- Copy Khayat l10n strings or feature names
- Copy `assets/branding/` or `khayat_dari_clean_needle_icon_pack/`
- Register Vazirmatn/Noto fonts for UI unless AFMS explicitly needs them (they are PDF-only in Khayat)
- Break existing AFMS tests or API integration

### Deliverables

1. Themed AFMS app with light/dark/system modes
2. Shared widget library under `lib/core/widgets/` (or AFMS convention)
3. Updated settings appearance screen
4. Brief summary of files created/modified and any AFMS-specific adaptations

Start by reading the attached design system files, then inspect the current AFMS theme setup and propose a minimal diff plan before implementing.

## PROMPT END
