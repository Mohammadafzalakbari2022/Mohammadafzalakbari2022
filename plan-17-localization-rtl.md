# Afghan Pride — Localization + RTL/LTR Plan

This document defines the localization system and RTL/LTR UI rules for the entire app.

## Supported languages (selected)
- Dari (RTL) (default)
- Pashto (RTL)
- English (LTR)

## Goals
- All text is localizable (no hardcoded UI strings)
- RTL/LTR works everywhere with correct mirroring
- Numbers/dates/currency are formatted correctly and consistently
- Same UI look across Android/iOS/Web

## System approach (selected)

### 1) Flutter official localization pipeline
- Use:
  - `flutter_localizations`
  - `intl`
  - ARB-based generation in `lib/l10n/*.arb`
- Add/maintain `l10n.yaml` to configure generation (output, template, etc.).

Rule:
- Any user-facing string must come from localization keys (except temporary dev placeholders).

### 2) Directionality rules (critical)
Always use directional APIs so UI mirrors automatically:
- `EdgeInsetsDirectional` instead of left/right padding
- `AlignmentDirectional` instead of left/right alignment
- `BorderRadiusDirectional` for shapes that depend on start/end
- Use `TextAlign.start/end` instead of left/right

Navigation:
- Dashboard edge-swipe opens from **start side** (LTR left, RTL right)
- Back/forward chevrons must auto-flip in RTL

### 3) Formatting rules (never concatenate)
Use `intl` for:
- Dates: delivery date, payment date, created/updated timestamps
- Money: totals, paid, remaining, monthly income
- Counts: orders, customers, queued sync items

Rules:
- Never build currency strings manually (e.g., `${amount} AFN`).
- Keep formatting in one shared formatter utility:
  - `formatMoney(amount, locale)`
  - `formatDate(date, locale)`
  - `formatNumber(n, locale)`

### 4) Phone number normalization (+93)
Rules:
- Store phone in a normalized format (recommended: E.164-like).
- Display can be friendly, but searching must match:
  - with/without +93
  - spaces/dashes
  - leading zeros

### 5) Fonts (cross-platform consistency)
Use one font family across platforms with strong Arabic-script support:
- Recommended baseline: Noto family (final selection during implementation)

Rules:
- Do not rely on platform default fonts.
- Ensure digits are readable in both themes.

### 6) Localization coverage (domain-specific)
Must be localized:
- Order statuses (New/In Progress/Ready/Delivered/Cancelled)
- Buttons, labels, validation messages
- Measurement units and UI labels
- Style categories
- Settings sections
- Reports labels (monthly income, unpaid, etc.)

User-generated content stays as entered:
- customer name
- notes
- custom measurement profile labels

## QA checklist (RTL/LTR)
Every screen must be tested in:
- Dari (RTL)
- English (LTR)

Checklist:
- layout mirrors correctly (start/end)
- list rows show leading/trailing content correctly
- dialogs button order is consistent and readable
- icons with directionality flip correctly
- numbers/dates/currency appear correctly formatted
- dashboard swipe direction behaves correctly in RTL/LTR

## Definition of Done
- No hardcoded user-facing strings remain
- All screens pass RTL/LTR QA checklist
- Formatting utilities used everywhere
- Fonts consistent across Android/iOS/Web

