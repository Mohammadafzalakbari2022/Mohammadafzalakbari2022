# Afghan Pride — Frontend UI Plan: Design System (All Platforms)

This document defines the **global UI system** to keep the app’s look identical on Android, iOS, and Web.

## Core rules (selected)
- Use one unified design system (Material-based) across all platforms (no platform-specific Cupertino look).
- One icon set everywhere (Material Symbols).
- All dialogs, confirmation modals, toasts/snackbars, and notifications follow the same components and tokens.

## Navigation consistency
- Bottom navigation is primary (Orders / Customers / Catalog / Reports / Settings).
- Dashboard is opened via start-edge swipe (RTL/LTR aware) and optional hamburger button.

## Brand mood
- Minimalist + premium craft (tailoring/art), using subtle textile-inspired details only in small places.

## Color tokens (selected)
Primary (emerald): `#0B3D2E`
PrimaryContainer: `#D7EFE7`
Accent (gold): `#C9A227`
BackgroundLight (paper): `#FAFAF7`
SurfaceLight: `#FFFFFF`
TextLight: `#101418`
BackgroundDark: `#0E1114`
SurfaceDark: `#151A1E`
TextDark: `#EEF2F6`
Error: `#D92D20`
Success: `#16A34A`
Warning: `#F59E0B`

Contrast rules:
- Never place gold text on white; use gold as accents, borders, icons, and small highlights.
- Status chips must meet contrast in both themes.

## Typography
- Use a single font family everywhere with strong RTL support (e.g., Noto Sans / Noto Naskh Arabic depending on final choice).
- Keep standard sizes, but emphasize:
  - order number, customer name, remaining balance, status chips.

## Icons
- Use **Material Symbols Outlined** everywhere.
- Icon usage rule: only where it improves scan speed; avoid decorative icons.

## Components (global)

### 1) Confirmation dialog (message box)
Use the same component across the entire app.
Required features:
- Title + message + optional destructive warning
- Primary/secondary buttons (consistent placement in RTL/LTR)
- Destructive actions use the Error color accent
- For owner-protected actions: show a password field + “Confirm” button

### 2) In-app notifications inbox
- Same layout across platforms.
- Notification item: icon + title + body + time + optional deep-link.

Mute option (selected):
- Settings → Notifications:
  - mute all notifications (in-app inbox badge + in-app banners)
  - optional per-type toggles (later)

Placement rule (selected)
- Notifications live in two places:
  - Dashboard: small “Recent notifications” preview
  - Settings: Notifications management + full history

### 3) Action feedback: colorful sliding progress bar (selected)
For important operations (order created/delivered/cancelled, user added/removed, backup completed):
- Show a top “sliding” progress/feedback bar:
  - success (green), warning (amber), error (red)
  - includes short text label (localized)
  - auto-dismiss after a short duration

Rules:
- Do not use blocking dialogs for success; use the feedback bar.
- Errors that require action can show dialog + feedback bar.

## Motion/animation
- Navigation transitions: subtle and fast (150–220ms).
- List updates: animate insert/update for new orders and payments.
- Avoid heavy effects; keep animations purposeful.

## Definition of Done
- Same colors/tokens/components on Android/iOS/Web
- RTL and LTR verified for dialogs and notifications
- Mute notifications setting works and is respected everywhere
- Feedback bar appears for key operations with correct color + localized text

