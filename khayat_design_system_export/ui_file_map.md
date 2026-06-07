# UI File Map — Khayat Design System

Inventory of design-related files with migration guidance for AFMS / Station Pro.

**Legend**

| Flag | Meaning |
|------|---------|
| ✅ Copy | Safe to copy with minimal renaming |
| 🔁 Reimplement | Use as visual/structural reference; rewrite for AFMS |
| ⛔ Do not copy | Business logic, domain, or Khayat branding mixed in |

---

## Theme files

| File | Purpose | Migration |
|------|---------|-----------|
| `lib/app/app_theme.dart` | **Master theme**: ColorScheme, ThemeData, PrideActionColors, button helpers, icon palettes | ✅ Copy (rename `Pride` prefix) |
| `lib/app/afghan_pride_app.dart` | MaterialApp.router theme wiring, locale, hosts | 🔁 Copy theme lines only; keep AFMS router/hosts |
| `lib/features/settings/settings_providers.dart` | `themeModeProvider`, persistence keys, locale prefs | 🔁 Copy theme/locale providers only |
| `lib/features/settings/settings_appearance_language_screen.dart` | Theme mode SegmentedButton UI | 🔁 Reimplement with AFMS settings routes |
| `lib/main.dart` | Bootstraps prefs + themeMode override | 🔁 Wire theme init pattern only |

---

## Constants / branding

| File | Purpose | Migration |
|------|---------|-----------|
| `lib/core/branding/app_branding.dart` | Khayat logo asset paths | ⛔ Replace with AFMS assets |
| `assets/branding/app_icon.png` | App icon | ⛔ AFMS branding |
| `assets/branding/login_logo.png` | Login logo | ⛔ AFMS branding |
| `khayat_dari_clean_needle_icon_pack/` | Launcher icon pack | ⛔ AFMS icon pack |

---

## Shared widgets (`lib/core/widgets/`)

| File | Purpose | Migration |
|------|---------|-----------|
| `pride_action_buttons.dart` | Semantic buttons + dialog footers + PrideIconAction | ✅ Copy |
| `pride_alert_dialog.dart` | showPrideAlertDialog, bullet rows | ✅ Copy |
| `pride_nav_card_tile.dart` | Card navigation row with colored icon | ✅ Copy |
| `pride_carved_section.dart` | Carved expansion panel + prideCarvedDecoration | ✅ Copy |
| `pride_close_button.dart` | Tonal close icon button | ✅ Copy |
| `app_back_button.dart` | Standard back IconButton | ✅ Copy |
| `pride_form_bottom_bar.dart` | Cancel + primary footer, scroll padding helper | ✅ Copy |
| `keyboard_safe_bottom_bar.dart` | Keyboard-aware SafeArea bar | ✅ Copy |
| `compact_search_toolbar.dart` | Expandable SearchBar toolbar | ✅ Copy |
| `pride_money_field.dart` | Money TextField with LTR + keyboard scroll | 🔁 Copy UI; AFMS may simplify digit rules |
| `pride_numeric_text_field.dart` | Numeric input variant | 🔁 Copy pattern |
| `shop_branding_header.dart` | Drawer header with shop logo/name | 🔁 Restyle for AFMS org/branch branding |
| `shop_logo_image.dart` | Rounded logo thumbnail widget | 🔁 Reimplement for AFMS logo storage |

---

## Input helpers

| File | Purpose | Migration |
|------|---------|-----------|
| `lib/core/input/pride_ltr_input.dart` | LTR direction + keyboard scroll padding constant | ✅ Copy if RTL locales used |

---

## Feedback / states

| File | Purpose | Migration |
|------|---------|-----------|
| `lib/core/feedback/app_feedback.dart` | Snackbars with semantic colors + progress | ✅ Copy (optional: drop sound) |
| `lib/core/feedback/app_sound_feedback.dart` | UI sounds | ⛔ Optional feature |
| `lib/auth/auth_form_feedback_banner.dart` | Login loading/error cards | ✅ Copy pattern |

---

## Shell / navigation

| File | Purpose | Migration |
|------|---------|-----------|
| `lib/shell/app_shell.dart` | Scaffold, drawer, bottom nav, app bar | 🔁 Visual reference; AFMS tabs/routes differ |
| `lib/shell/shell_app_bar_branding.dart` | Logo + shop name title | 🔁 AFMS station/branch branding |
| `lib/shell/shell_app_bar_title.dart` | Route → title mapping | ⛔ Domain routes |
| `lib/shell/shell_app_bar_sync_button.dart` | Sync action styling | ⛔ Khayat sync feature |
| `lib/shell/shell_primary_tab.dart` | Primary tab path helper | ⛔ Domain routes |
| `lib/shell/shell_drawer_quick_actions.dart` | Drawer quick action chips | 🔁 Pattern only |

---

## Dashboard

| File | Purpose | Migration |
|------|---------|-----------|
| `lib/dashboard/dashboard_widgets.dart` | DashboardSection, KPI, charts, chips | ✅ Copy (rename labels) |
| `lib/dashboard/dashboard_drawer.dart` | Full drawer layout + KPI wiring | 🔁 Layout/sections reference; replace data |

---

## List / tile components

| File | Purpose | Migration |
|------|---------|-----------|
| `lib/features/orders/order_list_tile.dart` | Order row visual pattern | 🔁 Copy decoration/animation only |
| `lib/features/customers/customer_list_tile.dart` | Customer row visual pattern | 🔁 Copy decoration/animation only |
| `lib/features/orders/orders_filtered_list_body.dart` | List + search + filter toolbar layout | 🔁 Layout reference |
| `lib/features/customers/customers_list_body.dart` | Customer list + empty state | 🔁 Layout reference |

---

## Detail / hero cards

| File | Purpose | Migration |
|------|---------|-----------|
| `lib/features/orders/order_detail_hero_card.dart` | Gradient hero summary | 🔁 Copy visual shell |
| `lib/features/customers/customer_profile_hero_card.dart` | Customer hero summary | 🔁 Copy visual shell |

---

## Forms / sheets

| File | Purpose | Migration |
|------|---------|-----------|
| `lib/features/orders/orders_list_filter_sheet.dart` | Filter bottom sheet UI | 🔁 Chip/filter layout reference |
| `lib/features/orders/order_payment_sheet.dart` | Payment modal sheet | ⛔ Domain logic |
| `lib/auth/login_screen.dart` | Login form layout | 🔁 Layout/spacing reference only |

---

## Settings UI

| File | Purpose | Migration |
|------|---------|-----------|
| `lib/features/settings/settings_tab_screen.dart` | Settings sections + bordered groups | 🔁 Section styling reference |
| `lib/features/settings/settings_appearance_language_screen.dart` | Theme + language UI | 🔁 Theme segment ✅; rest optional |

---

## Reports / charts

| File | Purpose | Migration |
|------|---------|-----------|
| `lib/features/reports/reports_tab_screen.dart` | Report hub nav cards | 🔁 Nav card layout |
| `lib/features/reports/report_daily_income_bars.dart` | Custom bar chart widget | ✅ Copy chart widget |
| `lib/features/reports/monthly_income_report_screen.dart` | Report screen layout | 🔁 Screen structure |
| `lib/features/shop_finance/shop_finance_hub_screen.dart` | Finance + fl_chart pie | 🔁 Chart styling; ⛔ finance models |

---

## Catalog / grid

| File | Purpose | Migration |
|------|---------|-----------|
| `lib/features/catalog/catalog_tab_screen.dart` | Grid layout, segment icons, empty state | 🔁 Grid responsive pattern |

---

## Guide / onboarding banner

| File | Purpose | Migration |
|------|---------|-----------|
| `lib/core/guide/app_guide_banner.dart` | Bottom tip banner (primaryContainer) | 🔁 Optional onboarding pattern |

---

## Chart widgets (summary)

| File | Chart type |
|------|------------|
| `lib/features/reports/report_daily_income_bars.dart` | Custom vertical bars |
| `lib/dashboard/dashboard_widgets.dart` | Pipeline bar, income bars, KPI |
| `lib/features/shop_finance/shop_finance_hub_screen.dart` | fl_chart PieChart |

---

## Icon definitions

| Location | Notes |
|----------|-------|
| Inline `Icons.*` throughout | Material Icons — no custom icon font in UI |
| `lib/app/app_theme.dart` | `prideNavTabColor`, `prideSettingsIconColor` palettes |
| `khayat_dari_clean_needle_icon_pack/` | App launcher only — ⛔ |

---

## Font declarations

| Location | Notes |
|----------|-------|
| `pubspec.yaml` | **No UI fonts declared** — uses Material defaults |
| `assets/fonts/*.ttf` | PDF printing only (`lib/core/printing/invoice_pdf_font.dart`) |
| `lib/core/printing/invoice_pdf_font.dart` | ⛔ Not app UI |

---

## Asset folders (UI-related)

| Path | Purpose | Migration |
|------|---------|-----------|
| `assets/branding/` | Khayat logos | ⛔ AFMS assets |
| `assets/fonts/` | PDF fonts | ⛔ Unless AFMS generates similar PDFs |
| `assets/style_figures/` | Tailoring measurement diagrams | ⛔ Khayat domain |
| `assets/catalog_seed/` | Seed catalog images | ⛔ Khayat domain |
| `web/icons/` | Web PWA icons | ⛔ AFMS branding |

---

## pubspec dependencies (UI-related)

See `dependency_ui_report.md` for full analysis.

| Package | UI role |
|---------|---------|
| `flutter` / `flutter_localizations` | Core + RTL |
| `cupertino_icons` | Secondary icon set |
| `flutter_riverpod` | Theme mode state |
| `go_router` | Navigation shell |
| `fl_chart` | Pie charts (finance) |
| `intl` | Formatting (numbers/dates in UI) |
| `shamsi_date` | Calendar display (indirect UI) |

Packages **not** used for UI theming: `isar`, `http`, `pdf`, `sentry_flutter`, etc.

---

## Router (navigation structure reference)

| File | Purpose | Migration |
|------|---------|-----------|
| `lib/router/app_router.dart` | All routes + shell branches | ⛔ AFMS owns its own router |

---

## Localization (UI strings)

| Path | Purpose | Migration |
|------|---------|-----------|
| `lib/l10n/app_*.arb` / `app_localizations*.dart` | All UI copy | ⛔ Write AFMS strings; reuse tone not content |

---

## Quick copy checklist for AFMS

**Minimum viable design port (7 files + wiring):**

1. `lib/app/app_theme.dart`
2. `lib/core/widgets/pride_action_buttons.dart`
3. `lib/core/widgets/pride_nav_card_tile.dart`
4. `lib/core/widgets/pride_carved_section.dart`
5. `lib/core/widgets/keyboard_safe_bottom_bar.dart`
6. `lib/core/widgets/pride_form_bottom_bar.dart`
7. `lib/core/feedback/app_feedback.dart`
8. Theme provider + appearance screen segment
9. Root `MaterialApp` theme/darkTheme/themeMode

**Reference-only (study, don't copy):**

- List tiles, hero cards, shell, drawer, login, settings sections

**Never copy:**

- Data layer, API, auth, licensing, sync, Khayat branding assets, l10n strings
