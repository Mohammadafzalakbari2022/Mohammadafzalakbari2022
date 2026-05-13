# Afghan Pride — Frontend UI Plan: Settings Module

This document defines the **Settings** module UI as the control center for the app.

## Goals
- Keep Settings clear and not crowded
- Owner-only controls are grouped and safely confirmed
- Works fully offline (shows cached values; refreshes when online)

## Navigation placement
- Bottom tab: **Settings**

## Screen: Settings Home
Sectioned list (cards/tiles), consistent across Android/iOS/Web.

### 1) Account & Shop
- Shop name/logo/address/contact
- **Measurement fields** (shop-scoped `measurement_types`): list, reorder, rename, active/hidden toggle, soft-remove — see Settings → Measurement fields (`plan-02`).
- Current user: username + badge (Owner/User)
- License status chip + expiry date
- Row: “Subscription”

### 2) Users (Owner only)
- List users
- Create user (username + password)
- Remove user (soft-delete)
- Show limits: Trial 2 / Paid 5
- Owner cannot be deleted

### 3) Subscription (Owner only)
- Enter activation code
- Current plan + expiry
- “Refresh license status” (when online)
- Explain read-only mode behavior when expired

### 4) Backup & Restore (Owner only)
Backup:
- Data-only
- Data + images
- Requires **owner login password confirmation** (no separate PIN)

Restore:
- Merge restore (never replace-all)
- Requires **owner login password confirmation**
- After restore, show **Restore Summary** + conflicts needing action (duplicate usernames, etc.)

### 5) Notifications
- Toggle: **Mute notifications**
- Notifications history/inbox list (full history)
- Filters by type (order status / user added/removed / license / backup restore)

### 6) Sync & Diagnostics
- Last sync time
- Queued changes count
- Owner Outbox viewer:
  - queued changes list + retry sync
  - export diagnostics bundle

### 7) Appearance & Language
- Theme: Light / Dark / System
- Language: Dari / Pashto / English

### 8) About
- App version/build
- Privacy/Terms (optional)

### Developer Portal (developer-only)
- Settings shows “Developer Portal” only when server confirms developer account.
- Opens the in-app portal screens (see `plan-18-ui-developer-portal.md`).

## Global UX rules (selected)
- Owner-only sections are visible but locked for normal users with “Owner only” label.
- Destructive/high-risk actions use global confirmation dialog + owner password confirmation.

## Definition of Done
- Settings works offline and shows cached values
- Owner gating works reliably
- Backup/restore uses owner password confirmation and produces Restore Summary
- Notifications mute works and affects badges/banners

