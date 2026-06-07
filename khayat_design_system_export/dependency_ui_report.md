# UI Dependency Report — Khayat (`pubspec.yaml`)

Analysis of packages with UI impact and whether AFMS / Station Pro should adopt them.

---

## Core Flutter UI

| Package | Version | UI role | Add to AFMS? |
|---------|---------|---------|--------------|
| `flutter` | SDK | Material widgets, theming, layout | ✅ Required (already) |
| `flutter_localizations` | SDK | RTL/LTR, locale-aware Material | ✅ Yes if multi-locale / RTL |

---

## Icons

| Package | Version | UI role | Add to AFMS? |
|---------|---------|---------|--------------|
| `cupertino_icons` | ^1.0.8 | Cupertino icon font (minimal use in Khayat) | ⚪ Optional — Khayat relies on Material Icons; add only if AFMS uses Cupertino widgets |

**Note**: Khayat UI uses **`Icons.*` Material Icons** exclusively in theme and widgets. No `flutter_svg`, no custom icon font for in-app UI.

---

## Charts

| Package | Version | UI role | Add to AFMS? |
|---------|---------|---------|--------------|
| `fl_chart` | ^0.70.2 | `PieChart` in shop finance expense breakdown | ✅ Yes **if** AFMS reports use pie/donut charts; otherwise optional |

Khayat also builds **bar charts without fl_chart** using `Container` + `Row` (reports, dashboard). AFMS can replicate those with zero extra deps.

---

## SVG

| Package | In Khayat? | Add to AFMS? |
|---------|------------|--------------|
| `flutter_svg` | ❌ Not used | Only if AFMS brand assets are SVG |

---

## Animations

| Package | In Khayat? | UI role | Add to AFMS? |
|---------|------------|---------|--------------|
| Dedicated animation package | ❌ | Uses built-in `AnimatedContainer`, `AnimatedCrossFade`, `AnimationController` in snackbars | ❌ Not needed — Flutter SDK sufficient |

---

## Responsive layout

| Package | In Khayat? | UI role | Add to AFMS? |
|---------|------------|---------|--------------|
| `responsive_framework` / similar | ❌ | Ad-hoc `MediaQuery.sizeOf(context).width` thresholds | ❌ Not required; copy Khayat's simple width checks if needed |

---

## Theme / state management

| Package | Version | UI role | Add to AFMS? |
|---------|---------|---------|--------------|
| `flutter_riverpod` | ^2.6.1 | `themeModeProvider`, settings prefs, app state | ✅ Yes if AFMS already uses Riverpod; otherwise wire theme mode with AFMS state solution |
| `shared_preferences` | 2.5.3 | Persist theme mode, locale, UI prefs | ✅ Yes for theme/locale persistence |
| `go_router` | ^14.8.1 | Shell routes, bottom nav branches | ✅ If AFMS uses go_router (match AFMS router, not Khayat routes) |

---

## Typography / fonts

| Package | In Khayat? | Add to AFMS? |
|---------|------------|--------------|
| Custom UI font package | ❌ | UI uses Material 2021 defaults |
| Bundled fonts in assets | PDF only | ⛔ Do not add for UI unless AFMS needs custom typography |

Assets present but **not registered for UI**:
- `assets/fonts/Vazirmatn-Bold.ttf`
- `assets/fonts/Vazirmatn-Regular.ttf`
- `assets/fonts/NotoNaskhArabic-Regular.ttf`

---

## Formatting (affects displayed UI text)

| Package | Version | UI role | Add to AFMS? |
|---------|---------|---------|--------------|
| `intl` | ^0.20.2 | Number/date formatting in lists and reports | ✅ Recommended |
| `shamsi_date` | 1.1.1 | Solar Hijri calendar in date pickers/display | ⚪ Only if AFMS targets same calendar locales |

---

## Image / media UI

| Package | Version | UI role | Add to AFMS? |
|---------|---------|---------|--------------|
| `image_picker` | ^1.2.0 | Catalog/profile photos | ⚪ Feature-dependent |
| `image` | 3.3.0 (override 4.3.0) | Image processing | ⚪ Not a UI theme dep |
| `qr_flutter` | ^4.1.0 | QR display widgets | ⚪ If AFMS shows QR codes |

---

## Feedback (non-visual but paired with UI)

| Package | Version | UI role | Add to AFMS? |
|---------|---------|---------|--------------|
| Built-in `SystemSound` | via `app_sound_feedback.dart` | Click/success sounds | ⚪ Optional polish |

---

## Packages NOT needed for design migration

These are in Khayat `pubspec.yaml` but unrelated to UI theming:

| Package | Purpose |
|---------|---------|
| `isar` / `isar_flutter_libs` | Local database |
| `http` | API |
| `sentry_flutter` | Crash reporting |
| `pdf` / `esc_pos_utils_plus` | Printing |
| `connectivity_plus` | Network status |
| `file_picker` | File import |
| `share_plus` / `url_launcher` | Sharing/links |
| `flutter_contacts` | Contacts import |
| `crypto` / `uuid` | Backend/security |
| `package_info_plus` | App version |
| `path_provider` | Storage paths |

---

## Recommended AFMS `pubspec.yaml` UI additions

**Minimum for design parity:**

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  flutter_riverpod: ^2.6.1   # if not already
  shared_preferences: ^2.5.3   # theme persistence
  intl: ^0.20.2                # formatting
```

**Optional based on features:**

```yaml
  fl_chart: ^0.70.2            # pie/donut report charts
  shamsi_date: 1.1.1           # Hijri calendar UI
  cupertino_icons: ^1.0.8      # if using Cupertino widgets
```

**Not needed for design-only migration:**

- SVG, animation, responsive_framework packages
- Khayat PDF fonts (unless AFMS prints similar invoices)

---

## Version notes

- Khayat SDK: `^3.10.4`
- Material 3 enabled via `useMaterial3: true` in theme — no `material_color_utilities` direct import required (pulled transitively by Flutter)
- `fl_chart` ^0.70.x aligns with Flutter 3.x; verify compatibility with AFMS Flutter version before pinning
