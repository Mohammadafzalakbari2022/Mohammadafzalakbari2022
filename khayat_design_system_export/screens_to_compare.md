# Screens to Compare — Khayat → AFMS Migration

Use these Khayat screens as **visual reference benchmarks** when restyling AFMS. Open them in Khayat (light + dark + system) and compare against AFMS equivalents after theming.

---

## 1. Dashboard / home drawer

| | |
|---|---|
| **Khayat screen** | Dashboard drawer (`DashboardDrawer`) |
| **Route** | Open from primary tab app bar (dashboard icon) |
| **File** | `lib/dashboard/dashboard_drawer.dart`, `lib/dashboard/dashboard_widgets.dart` |
| **Shows** | Gradient-free shop header, bordered dashboard sections, KPI tiles, pipeline bar chart, income bars, quick link chips, search field in section |
| **AFMS equivalent** | Main dashboard, station overview, or home drawer/sidebar |

**Compare**: section borders, KPI tile colors, drawer width (~92%), header branding strip.

---

## 2. Bottom navigation shell

| | |
|---|---|
| **Khayat screen** | App shell with 5 tabs |
| **Route** | `/app/orders`, `/app/customers`, etc. |
| **File** | `lib/shell/app_shell.dart` |
| **Shows** | NavigationBar 72px, per-tab colored icons, app bar with shop branding, drawer trigger |
| **AFMS equivalent** | Main tab shell (sales, inventory, finance, reports, settings) |

**Compare**: nav height, indicator color, icon outlined/filled pattern, app bar background.

---

## 3. Table / list screen — orders

| | |
|---|---|
| **Khayat screen** | Orders list tab |
| **Route** | `/app/orders` |
| **File** | `lib/features/orders/orders_filtered_list_body.dart`, `lib/features/orders/order_list_tile.dart` |
| **Shows** | Compact search toolbar, filter badge, carved list rows, two-tap selection, status chips, add button (emerald) |
| **AFMS equivalent** | Sales list, invoice list, transaction list, inventory list |

**Compare**: row radius, selection animation, name badge, meta icon rows, empty state.

---

## 4. Table / list screen — customers

| | |
|---|---|
| **Khayat screen** | Customers list tab |
| **Route** | `/app/customers` |
| **File** | `lib/features/customers/customers_list_body.dart`, `lib/features/customers/customer_list_tile.dart` |
| **Shows** | Same list pattern as orders, empty state with add CTA |
| **AFMS equivalent** | Customer/supplier list, branch list, user list |

---

## 5. Form screen — new customer

| | |
|---|---|
| **Khayat screen** | New customer form |
| **Route** | `/app/customers/new` |
| **File** | `lib/features/customers/new_customer_screen.dart` |
| **Shows** | Filled inputs, form scroll padding, sticky bottom bar with cancel/save |
| **AFMS equivalent** | Create sale, add product, add branch, any create/edit form |

**Compare**: input borders, bottom bar above keyboard, button variants.

---

## 6. Detail screen — order detail

| | |
|---|---|
| **Khayat screen** | Order detail |
| **Route** | `/app/orders/:id` |
| **File** | `lib/features/orders/order_detail_screen.dart`, `lib/features/orders/order_detail_hero_card.dart` |
| **Shows** | Gradient hero card, carved expansion sections, payment progress, semantic action buttons |
| **AFMS equivalent** | Sale detail, product detail, branch detail |

**Compare**: hero gradient border, carved sections, icon action circles.

---

## 7. Detail screen — customer profile

| | |
|---|---|
| **Khayat screen** | Customer profile |
| **Route** | `/app/customers/:id` |
| **File** | `lib/features/customers/customer_profile_screen.dart`, `lib/features/customers/customer_profile_hero_card.dart` |
| **Shows** | Secondary-tinted hero card, order history list reuse |
| **AFMS equivalent** | Customer/account profile, station profile |

---

## 8. Report / chart screen — reports hub

| | |
|---|---|
| **Khayat screen** | Reports tab |
| **Route** | `/app/reports` |
| **File** | `lib/features/reports/reports_tab_screen.dart` |
| **Shows** | Overview title, stack of `PrideNavCardTile` cards with live metric subtitles |
| **AFMS equivalent** | Reports module landing |

---

## 9. Report / chart screen — monthly income

| | |
|---|---|
| **Khayat screen** | Monthly income report |
| **Route** | `/app/reports/monthly-income` |
| **File** | `lib/features/reports/monthly_income_report_screen.dart`, `lib/features/reports/report_daily_income_bars.dart` |
| **Shows** | Month pager, summary cards, custom primaryContainer bar chart |
| **AFMS equivalent** | Sales report, revenue report, period analytics |

---

## 10. Report / chart screen — shop finance

| | |
|---|---|
| **Khayat screen** | Shop finance hub |
| **Route** | `/app/reports/shop-finance` |
| **File** | `lib/features/shop_finance/shop_finance_hub_screen.dart` |
| **Shows** | Summary card, fl_chart pie chart, list tiles, add expense emerald button |
| **AFMS equivalent** | Finance/expenses module, P&L breakdown |

**Compare**: pie chart colors (primary/secondary/tertiary), card layout, chip for overdue status.

---

## 11. Settings / theme screen

| | |
|---|---|
| **Khayat screen** | Appearance & language |
| **Route** | `/app/settings/appearance` |
| **File** | `lib/features/settings/settings_appearance_language_screen.dart` |
| **Shows** | ThemeMode SegmentedButton, bordered settings card groups, section titleSmall headers |
| **AFMS equivalent** | Settings → Appearance / Theme |

**Compare**: segmented control, spacing, card grouping — **critical for light/dark/system verification**.

---

## 12. Settings hub

| | |
|---|---|
| **Khayat screen** | Settings tab |
| **Route** | `/app/settings` |
| **File** | `lib/features/settings/settings_tab_screen.dart` |
| **Shows** | Section headers, 16px bordered groups with primary tint border, colored leading icons, locked tiles |
| **AFMS equivalent** | Settings main screen |

---

## 13. Login screen

| | |
|---|---|
| **Khayat screen** | Login |
| **Route** | `/auth/login` |
| **File** | `lib/auth/login_screen.dart`, `lib/auth/auth_form_feedback_banner.dart` |
| **Shows** | Centered logo with primary shadow, headline hierarchy, filled inputs, loading/error banners, filled primary CTA |
| **AFMS equivalent** | Login / sign-in |

**Compare**: logo treatment, spacing, form feedback cards — use **AFMS logo**, not Khayat needle.

---

## 14. Filter bottom sheet

| | |
|---|---|
| **Khayat screen** | Orders filter sheet |
| **Route** | Modal from orders list filter icon |
| **File** | `lib/features/orders/orders_list_filter_sheet.dart` |
| **Shows** | Drag handle, FilterChip groups, apply/cancel semantic buttons |
| **AFMS equivalent** | Any list filter sheet |

---

## 15. Alert dialog

| | |
|---|---|
| **Khayat screen** | Validation alert (e.g. order composer) |
| **File** | `lib/core/widgets/pride_alert_dialog.dart` |
| **Shows** | Centered icon in tonal circle, centered title, bullet rows with colored leading |
| **AFMS equivalent** | Validation / confirmation dialogs |

---

## 16. Catalog grid (optional reference)

| | |
|---|---|
| **Khayat screen** | Catalog tab |
| **Route** | `/app/catalog` |
| **File** | `lib/features/catalog/catalog_tab_screen.dart` |
| **Shows** | Responsive grid, segment icon toggles, sort/search icon toolbar |
| **AFMS equivalent** | Product grid, inventory image grid |

---

## Comparison workflow

For each AFMS screen:

1. Run Khayat side-by-side in **light**, **dark**, and **system** modes
2. Screenshot Khayat reference from list above
3. Apply theme phases from `migration_prompt_for_afms.md`
4. Verify against `component_style_guide.md` checklist
5. Confirm AFMS branding remains (logo, name, colors only from design tokens — not Khayat assets)

## Priority order (if time-constrained)

1. Settings appearance (theme modes) — validates foundation
2. App shell + bottom nav
3. One list screen + one detail screen
4. One form + bottom bar
5. Login
6. Reports hub + one chart screen
7. Dashboard drawer (if AFMS has equivalent)
