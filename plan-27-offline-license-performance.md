# Plan 27 — Offline license, developer exemption, performance

**Status:** In progress (2026-06-20)

## Problem statement

1. Paid/activated shops going offline for days were blocked after the 3-day grace window even when `expires_at` was still in the future.
2. Offline credential cache was not updated when license snapshots changed (activation, periodic refresh), so offline re-login could restore stale `trial_active`.
3. Developer/portal-admin accounts were subject to the same license read-only gates as regular shops.
4. Developer Portal visibility could rely on a device-global persisted flag without matching the current session identity.
5. Connectivity unknown at startup defaulted to “online”, briefly skipping offline license evaluation.

## Root causes (confirmed in code)

| Issue | Location | Cause |
|-------|----------|-------|
| Paid offline lockout | `LicenseNotifier.isEditingBlocked` | Applied 3-day grace to all offline sessions, ignoring cached `expires_at` for `active` |
| Stale offline login | `persistLicenseSnapshotFromApi` | Updated prefs but not `OfflineCredentialStorage` |
| Dev license lock | `licenseEditingBlockedProvider` | No developer exemption |
| Portal leak risk | `showDeveloperPortalInSettings` | `persistedDeveloperFlag` alone could show portal without session match |
| Startup online assumption | `connectivityOnlineProvider` | `orElse: () => true` |

## Phased implementation

### Phase 1 — Offline-first license (HIGHEST PRIORITY) ✅

- [x] `isEditingBlocked`: when offline, honor cached `expires_at` before grace; grace only when expiry unknown
- [x] Mirror license snapshot into `OfflineCredentialStorage` on every API persist
- [x] Unit tests for paid-offline, trial grace, expired, developer exempt

### Phase 2 — Developer portal + owner exemption ✅

- [x] `isDeveloperAccountProvider` — env gate, `GET /admin/me`, scoped persisted flag
- [x] `licenseEditingBlockedProvider` returns `false` for developer accounts
- [x] Tighten `showDeveloperPortalInSettings` — session-scoped persisted developer identity
- [x] Store `shop_id|username` when marking developer portal unlocked; clear on sign-out

### Phase 3 — Offline audit ✅

- [x] Connectivity defaults to offline until known (offline-first license evaluation on cold start)
- [x] No changes to signup/activation flows (still require internet)
- [x] Sync/auto-sync already skip when `licenseEditingBlockedProvider` — developers now exempt

### Phase 4 — Performance (minimal) ✅

- [x] `connectivityOnlineProvider` `orElse: false` — avoids false-online license/sync work at startup
- [ ] Future: profile hot `StreamProvider`s if slowness reports continue (out of scope unless measured)

## Contracts (aligned with plan-06)

### Offline editing allowed when

- Developer account (env/API/persisted identity for current session), OR
- Online (server refresh pending; client does not pre-block), OR
- Offline AND cached `expires_at` is in the future, OR
- Offline AND no `expires_at` AND within 3 days of `last_successful_check_at`, OR
- Offline AND `last_successful_check_at` missing (permissive — restored session without anchor)

### Offline editing blocked when

- `status == expired`, OR
- `suspected_time_tamper`, OR
- Offline AND `now > expires_at`, OR
- Offline AND no valid `expires_at` AND past 3-day grace

### Developer Portal visible when

- Debug simulate toggle (debug builds only), OR
- Current session matches `PRIDE_DEVELOPER_USERS` dart-define, OR
- `GET /admin/me` → `is_developer: true`, OR
- Persisted developer identity matches current `shop_id|username` (offline after prior server confirmation)

Regular shop users never match the above.

## Files touched

- `lib/licensing/license_notifier.dart`
- `lib/licensing/license_providers.dart`
- `lib/licensing/license_snapshot_persist.dart`
- `lib/auth/developer_account.dart` (new)
- `lib/auth/developer_portal_gate.dart`
- `lib/auth/auth_session_storage.dart`
- `lib/auth/offline_credential_storage.dart`
- `lib/shell/shell_sync_providers.dart`
- `test/license_offline_test.dart` (new)
- `plan-00-index.md` (index entry)

## Verification

```bash
flutter analyze
flutter test test/license_offline_test.dart
flutter test
```

### Manual (product owner)

1. **Paid offline** — Activate shop online, go offline 5+ days (or simulate), confirm orders/customers/settings save still work until real `expires_at`.
2. **Trial offline** — Trial shop offline within trial window: editing works; past trial `expires_at`: read-only.
3. **Developer** — Developer login offline after prior online session: no subscription redirect, Developer Portal visible, editing works.
4. **Regular user** — No Developer Portal tile in Settings; expired license → read-only except Subscription.

## Out of scope

- Changing activation/signup internet requirement
- Server-side license enforcement changes (API already authoritative for sync)
- Broad stream/list performance refactors without profiling data
