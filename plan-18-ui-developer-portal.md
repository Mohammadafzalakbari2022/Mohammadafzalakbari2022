# Afghan Pride — Frontend UI Plan: Developer Portal (In-App)

This document defines the **Developer Portal** UI inside the same Flutter app.

## Goals
- Give the developer (you) full control of licensing/support operations
- Keep it secure: server-enforced developer access (not “hidden UI”)
- Make actions auditable (who/when/what changed)

## Access & placement (selected)
- Visible only if server confirms `is_developer=true`.
- Entry point:
  - Settings → **Developer Portal** (shown only for developer account)
- Developer portal requires internet:
  - all actions call API
  - show “Online required” state if offline

## Global UX rules
- Environment badge always visible (dev/staging/prod)
- All destructive actions require confirmation dialog
- Actions show global action feedback bar (success/error)
- All actions write audit logs

## Screens

### 1) Overview
Cards:
- Total shops
- Active vs expired
- Trials running
- Activations redeemed (today/this week)
- API health status

### 2) Activation Codes
Create code:
- Plan type: 1 year / 2 year / lifetime
- Single-use
- Optional: assign to a specific shop at creation time

List/search:
- Search by code/shop
- Filters: unused / redeemed / expired / revoked

Details:
- created_by, created_at
- redeemed_by_shop_id, redeemed_at

### 3) Shops & Licenses
Shop list row:
- shop name
- created_at
- user count
- license status + expires_at
- last_successful_check_at

Shop detail:
- users list (username + deleted_at flag)
- activation history
- license snapshot details

Actions (audited):
- Disable shop (rare abuse)
- Extend license / apply code (optional)

### 4) Password Reset Requests (manual support)
List:
- shop_id / shop name
- username
- requested_at
- status (open/resolved)

Action:
- Set new password (audited)
- Mark resolved

### 5) Diagnostics (support)
View:
- recent API errors (if stored)
- per-shop last sync timestamp (if tracked)

Device diagnostics bundle:
- instruct user to export from Settings → Sync & Diagnostics
- developer can request it via support workflow

## API endpoints (developer-only)
- `GET /admin/me`
- `POST /admin/activation-codes`
- `GET /admin/activation-codes`
- `GET /admin/activation-codes/:code`
- `GET /admin/shops`
- `GET /admin/shops/:shopId`
- `POST /admin/shops/:shopId/disable` (optional)
- `POST /admin/shops/:shopId/extend-license` (optional; audited)
- `GET /admin/password-resets`
- `POST /admin/password-resets/:requestId/reset`

## Definition of Done
- Portal is inaccessible unless server confirms developer status
- Works in all themes and RTL/LTR (mostly LTR content, but UI must mirror correctly)
- All actions are audited and show clear feedback
- Offline state handled gracefully (read-only view or “Online required”)

