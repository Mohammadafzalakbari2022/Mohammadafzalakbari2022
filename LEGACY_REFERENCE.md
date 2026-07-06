# Afghan Pride (Khayat) — Legacy Reference Spec

> **Purpose:** Reference document extracted from the abandoned v3 codebase (`Mohammadafzalakbari2022`).
> **Not a build blueprint.** ~80% of the new project will differ: new database, API, frontend, UX layout, and feature placement.
> **Do not copy v3 source files.** Use this only when you need business context, domain rules, or “what did the old app try to solve?”

**Last extracted:** July 2026  
**Source:** plan-00 … plan-30, AGENTS.md, and v3 implementation notes

---

## 0. How to use this document

| Use this for | Do NOT use this for |
|--------------|---------------------|
| Domain vocabulary (orders, garments, cloth, profiles) | File paths, class names, or folder structure from v3 |
| Business rules (payments ledger, offline login, licensing) | Exact screen layouts or where buttons lived |
| Entity relationships and ID strategy | Isar schemas, Prisma models, or API payloads as-is |
| What features existed and why | “Must look/behave exactly like v3” |

When rebuilding, decide per section: **Keep rule** / **Simplify** / **Drop** / **Redesign**.

---

## 1. Product summary

**Afghan Pride** is an offline-first tailoring shop management app for Afghan tailors.

- **Users:** shop owner + staff on shared devices
- **Core job:** take customer orders (measurements, style, payment), track status, report income
- **Markets:** Afghanistan — Dari (default), Pashto, English; full RTL
- **Platforms (engineering target):** Android, iOS, Web (Web was demo/testing; mobile is primary)

**Multi-tenant model:** many shops; each shop has its own users, data, and license.

---

## 2. Navigation model (v3 — redesign expected)

v3 used **five bottom tabs** (no Dashboard tab):

```
Orders | Customers | Catalog | Reports | Settings
```

Dashboard was a **drawer** (edge swipe + hamburger): KPIs, tasks preview, order search, notifications.

**New project:** tab set, drawer, and where settings live are **open for redesign**. Keep the *modules* as concepts, not the *placement*.

---

## 3. Roles & permissions

### Shop owner (one per shop, permanent)
- Created automatically when shop is created
- Cannot be deleted; ownership transfer not supported
- **Owner-only:** user management, backup/restore, some high-risk actions
- Manages subscription / activation codes (with all users able to redeem)

### Normal shop user
- Full day-to-day CRUD: customers, orders, measurements, payments, catalog (within license)
- Cannot create/remove users

### Developer account (allowlisted server-side)
- In-app developer portal: activation codes, audit log, shop stats, billing support tools
- Not a regular shop role

---

## 4. Authentication & session

### Online login
- **Inputs:** shop identifier + username + password
- **Output:** JWT access token, user id, shop id, `is_shop_owner`, license snapshot
- Username unique **within shop only** (not globally)

### Offline login (important business rule)
- Available **only after one successful online login** on that device
- Device stores a **password verifier** (hash), not plaintext password
- Offline session allows full local app use; sync blocked until online + valid license

### Shop bootstrap
- `create shop` → first user becomes owner
- No invite/QR join flow in v3 (excluded by product decision)

### Password reset
- No automated email/SMS reset
- User submits request from login screen → developer/support resolves manually

### Auth guard (conceptual)
- Unauthenticated → login
- Authenticated at login route → main app

---

## 5. Licensing

### States
| Status | Meaning |
|--------|---------|
| Trial active | Limited users (2), time-boxed |
| Active (paid) | Higher user cap (default 5, admin-adjustable 1–20) |
| Expired | Read-only mode |

### Expired behavior (v3 rule)
- **Read-only** across the app: browse, search, print/share existing data
- **No** create/update/delete, **no** sync
- **Only** subscription/activation screen stays fully interactive
- Server enforces on sync endpoints (403 `license_expired`)

### Activation
- Redeem codes via API (`activation_codes` table)
- Extends license by plan days; audit trail on server

### Offline license grace
- Trust cached expiry when offline
- If no expiry on snapshot: ~3-day grace after last successful server check
- Suspected device time tamper → block editing

**New project:** enforcement model can change; keep **server as source of truth** and **clear UX when expired**.

---

## 6. Identity & ID strategy (keep this concept)

### Two IDs everywhere
| ID | Purpose |
|----|---------|
| `internal_id` | UUID/ULID — primary key, sync, relationships |
| `display_*` numbers | UI-only (e.g. 8-digit order number `00000001`) |

**Why:** multi-device offline work avoids collisions; sync needs stable keys.

### Display order number
- Client may assign temporary number offline
- Server validates/assigns final 8-digit number on sync
- On collision, server wins and client updates local copy

### Soft delete
- Customers, users, tasks, etc. use `deleted_at` — not hard delete

### Audit fields (recommended for new DB)
- `created_at`, `updated_at`, `deleted_at`
- `last_modified_by_user_id`
- `revision` or concurrency token for sync conflicts

---

## 7. Customers

### Data
- `internal_id`, `shop_id`
- Name, phone (+93 normalization), address, notes
- Optional denormalized “last catalog design” fields from most recent order

### List behavior
- Search: name, phone, address, notes — instant offline
- Views: list vs card
- Filters: created date, has orders, unpaid balance
- Sort: recent activity, name, order count

### Customer profile
- Edit customer info
- **Measurement profiles** (multiple per customer)
- Today’s orders + link to full order list filtered by customer

### Measurement profiles
- Label optional (e.g. “Winter 2026”)
- Unit preference (inch/cm)
- **Edit in place** OR **save as new version**
- **Orders always store immutable measurement snapshot** — later profile edits do not alter past orders

### New customer flows
- From Customers: save → open profile
- From Order composer: save → return to composer with customer selected (composer flow may hide notes)

### Delete customer
- Soft delete with confirmation (policy TBD in new UX)

---

## 8. Orders — core domain

### Status lifecycle
```
new → inProgress → ready → delivered
                          ↘ cancelled
```

### Garment types (multi-garment model)
| Garment | Code | API-style key |
|---------|------|---------------|
| Perahan/Tunban | 0 | `perahan_tunban` |
| Waistcoat | 1 | `waistcoat` |

**Rule:** at most **one line per garment type** per order (0–2 items).

### Order structure

**Order level**
- Customer reference + frozen name/phone snapshots
- `display_order_no`, status, delivery date
- `total_amount_minor` (sum of item prices when multi-item)
- Internal notes (staff-only)
- Optional catalog design snapshots (frozen at save)
- Payment ledger (separate rows)

**Item level (per garment)**
- `garment_type`, sort order, price
- Measurements snapshot (text + structured items)
- Style: name, selection JSON, human summary
- Cloth: name, color, meters, price (optional block)
- Catalog design snapshots per item (optional)

### Money rules
- Store amounts as **integers in minor units** (e.g. AFN) — no floats
- Order total editable only if `newTotal ≥ sum(payments)`
- Remaining = total − paid (floor at 0)

### Payments — append-only ledger
- **Never** edit or delete existing payment rows
- Corrections via new **adjustment/reversal** entry
- New payment cannot exceed remaining balance
- Initial payment recorded at order creation

### Order composer (v3 UX — redesign expected)

v3 used a **hub screen + modal bottom sheets**:
1. Customer (required)
2. Measurements (required) — fields from shop measurement types
3. Style (required) — design name + figure per part; optional catalog photo
4. Payment + delivery date (required)
5. Cloth block (optional, shop-configurable visibility)

**Rules**
- No order row until user taps **Save Order**
- Post-save: print receipt, share invoice, view order (v3)
- Show recent orders for selected customer in composer
- Load measurements from customer profile optional

**Shop-configurable composer sections (v3)**
- Toggle: style name, catalog picker, cloth block (SharedPreferences per shop)

**New project:** composer layout, steps, and density are **fully open**; keep validation rules and data captured.

### Order list
- Filters: status, unpaid, date range
- Search: order number, customer name, phone
- **No row quick actions** — tap opens detail (v3 rule)
- Row shows: order no, customer, delivery date, status, remaining balance

### Order detail
- v3 allowed **editing on all statuses** including delivered/cancelled
- Measurements snapshot on order: **view/immutable history** (don’t recompute from profile)
- Status changes via dedicated action, not inline on list

### Confirmations (v3 / AGENTS.md)
- Delete order or cancel status → user types **customer name**
- Other field edits → simple confirm dialog
- Owner password **not** required on order flows (v3 final rule)

### Printing & sharing (mobile)
- PDF invoice (RTL/Arabic text)
- Thermal receipt (ESC/POS)
- WhatsApp share
- **Not on Web** in v3

---

## 9. Measurements & style configuration

### Measurement types (shop-scoped)
- Name, sort order, active/hidden
- Configured in Settings
- Drive composer measurement form dynamically

### Style catalog (shop-scoped)
- **Style names** — presets for design names
- **Style parts** — garment sections (collar, cuff, etc.)
- **Style figures** — shape images with text/size options per part
- v3 seeded **15 default shape PNGs** on first login

### Style on order
- Structured selection stored as JSON
- Human-readable `styleSummary` for lists, receipts, sync
- Optional link to catalog photo design (frozen snapshots)

---

## 10. Catalog (photo designs)

### Principles
- Images stored **locally on device** — no cloud image hosting
- Metadata: design name, designer shop name (auto from shop), date added, notes
- Thumbnail + full image

### My designs
- Add via camera/gallery (**mobile only** in v3)
- Grid/list browse, detail view, edit metadata, delete

### Sharing (v3 — optional for new project)
- **Mutual opt-in:** must enable sharing to browse others’ public directory
- Public **metadata** feed via API
- **Images** transferred **P2P (WebRTC)** with API signaling only — not via server
- Web: view-only, no upload

**New project:** may drop P2P in v1; keep local catalog first.

---

## 11. Reports (offline financial)

All computed from **local** orders + payment ledger.

| Report | Purpose |
|--------|---------|
| Overview | This month income, unpaid total, status counts |
| Monthly income | Payments in selected month; unpaid on orders due that month |
| Unpaid / open balances | Filter by delivery window, amount range |
| Delivered | By delivery month |
| Payments ledger | By date range; group day/week/month |
| Cloth financing | Customer cloth-related totals (v3) |
| Shop finance | Rent, expenses, rent payments (v3) |

### Calendar
- User chooses **Gregorian** or **Solar Hijri** for month boundaries (v3)

**New project:** which reports exist and how they’re grouped is open.

---

## 12. Settings & admin (conceptual map)

v3 grouped these in Settings (placement will change):

| Area | Notes |
|------|-------|
| Shop profile | Name, logo, banner, contact |
| Measurement fields | CRUD measurement types |
| Order style | Names, parts, figures |
| Cloth presets | Name/color presets |
| Composer visibility | Toggle optional composer sections |
| Users | Owner only: create/remove, seat limits |
| Subscription | Redeem code, refresh license, billing UI |
| Backup & restore | Owner only; JSON export/import; owner password |
| Sync & diagnostics | Last sync, manual sync, outbox, conflicts |
| Notifications | Mute, inbox |
| Tasks | Simple offline to-do |
| Printer | Thermal + PDF config |
| Appearance | Theme, language, font scale/family |
| About | Version, legal |
| Developer portal | Developer-only admin tools |

### Backup (v3)
- JSON format v3: data + optional catalog image binaries (base64 in JSON)
- **Merge restore** only (never replace-all)
- Owner password required
- Restore summary for conflicts (e.g. duplicate usernames)

### Tasks (v3)
- Shop-scoped checklist: title, notes, done, optional due date
- Soft delete; Settings entry; optional dashboard shortcut

---

## 13. Sync & offline-first

### Principles
1. **Write local first** (device DB)
2. Queue changes in **outbox**
3. Push then pull when online
4. Never silently lose order/payment data

### Sync loop
1. `POST /sync/push` — batch mutations from outbox
2. `GET /sync/pull?cursor=...` — paged remote changes
3. Apply inbound; update cursor; clear pushed outbox rows
4. Record conflicts for user review

### Entity types synced (v3)
Includes: order, customer, payment, notification, measurement_type, task, measurement_profile, catalog_item, style_name, style_part, style_figure, fabric presets, shop finance entities, etc.

### Conflict policy (v3 defaults)
| Entity | Policy |
|--------|--------|
| Customers | Last-write-wins |
| Orders | Field merge; critical conflicts → UI inspector |
| Payments | Append-only; never auto-merge |
| Order snapshots | Immutable after creation |
| Measurement types | Last-write-wins with audit |

### When sync is skipped
- Mock/offline-only login without API session
- License expired / read-only
- No network

### Server model (v3 concept)
- Append-only **sync mutation log** per shop (revision cursor)
- Not necessarily full normalized entity tables for all client data
- Clients hold canonical **local** state; server is sync hub + auth/licensing

**New project:** database schema will be new — preserve **outbox + cursor + conflict awareness**, not v3 table names.

---

## 14. Notifications

- In-app inbox per shop (synced across users)
- Events: order status changes, user added/removed, license changes, backup restore, etc.
- **Mute** option (hide banners; inbox still stores)
- v3 added FCM push for some events (optional pipeline)

---

## 15. Localization & RTL

### Languages
- Dari (`fa`) — default, RTL
- Pashto (`ps`) — RTL
- English (`en`) — LTR

### Rules
- No hardcoded user-visible strings in UI
- Use ARB + `intl`
- Directional layout: `EdgeInsetsDirectional`, `AlignmentDirectional`, `TextAlign.start/end`
- Format money, dates, numbers via shared formatters — don’t concatenate currency strings
- Phone search: tolerant of +93, spaces, leading zeros

### Fonts
- Cross-platform consistent Arabic script support (v3 used bundled Noto-style approach)

**New project:** v3 ARB files are a useful **translation reference**; don’t copy generated Dart l10n code.

---

## 16. API surface (v3 contract — rewrite implementation)

Use as **capability checklist**, not endpoint-for-endpoint port.

| Area | Capabilities |
|------|----------------|
| Health | Liveness check |
| Auth | Login, JWT, license snapshot on login |
| Shop | Create, join (login-shaped), user CRUD, user limits |
| Sync | Push batch, pull paginated cursor, conflict responses |
| License | Redeem code, status refresh |
| Catalog | Public metadata feed, share settings, P2P signaling |
| Admin | Stats, activation codes, audit log (developer) |
| Push | Device token register, dispatch (FCM) |
| Password reset | Request queue for developer |
| Billing | Subscription payment claims, support config (v3) |

### Auth model (keep)
- **Custom API auth** — not Supabase Auth in the client
- Postgres can be hosted anywhere (Supabase as DB host is fine)
- Client uses anon/public keys only if using Supabase client for realtime — v3 used Nest+Prisma primarily

### User limits (server-enforced)
- Trial: max **2** users
- Paid: max **`max_users`** per shop (default 5, admin 1–20)

---

## 17. Data model checklist (conceptual entities)

Use when designing **new** schema:

```
shops
shop_users
shop_licenses
shop_sync_mutations (or equivalent event log)

customers
orders
order_items
order_measurement_snapshots (+ items)
order_style_snapshots (+ figures)
payments

measurement_types
measurement_profiles (+ items)

catalog_items (local image refs on client)

style_names
style_parts
style_figures (+ text/size options)

fabric_name_presets
fabric_color_presets

tasks
app_notifications

shop_rent
shop_rent_payments
shop_expenses

activation_codes
password_reset_requests
audit_log (server)
```

**Client-only (typical)**
- sync_outbox
- offline_credential_verifiers
- license cache / sync cursor prefs

---

## 18. Platform behavior matrix

| Feature | Android/iOS | Web (v3) |
|---------|-------------|----------|
| Isar / persistent local DB | Yes | No — in-memory only |
| Offline login | Yes | Limited / same verifier concept |
| Camera/gallery catalog | Yes | Disabled |
| Thermal print | Yes | Disabled |
| PDF print/share | Yes | Limited/disabled |
| Bluetooth printer | Yes | Disabled |
| Full order/customer CRUD | Yes | Yes |
| P2P catalog images | Yes (scaffold) | No |

**New project:** decide Web scope early (demo vs parity).

---

## 19. v3 features explicitly excluded or deferred

Do not assume these in v1 of new app unless you add them back:

- Invite / QR shop join
- Supabase Auth + RLS in client
- Dashboard global search
- Full WebRTC P2P (native peer connection was scaffold only)
- Play/App Store launch ops (signing, listings) — process docs only
- Store-wide “coming soon” placeholders

---

## 20. v3 technical debt (why we are not reusing code)

| Problem | Lesson for new project |
|---------|------------------------|
| ~4,200-line order composer screen | Split by feature early; max ~300–400 lines per screen file |
| Vendored `third_party/jni`, `isar_flutter_libs` | Avoid vendoring; pin versions or pick stable stack |
| Dual Memory + Isar repos | Keep **one repository interface**; swap impl per platform from day one |
| 30+ plan files + doc drift | One living `SPEC.md` + short module docs |
| Many conditional import files | Establish platform abstraction pattern in week 1 |
| Multiple AI passes without CI gate | Every merge: analyze + test + smoke checklist |

---

## 21. Suggested build order for new project

1. **SPEC + design** — UX wireframes (new), entity list, API sketch
2. **Foundation** — app shell, theme, l10n, router, auth guards
3. **Auth + license** — online/offline login, read-only mode
4. **Customers + measurement profiles** — simplest full vertical slice
5. **Orders** — list, detail, then composer last
6. **Payments ledger** — with orders
7. **Reports** — local aggregates
8. **Settings** — shop profile, measurement types, style config
9. **Sync** — outbox, push/pull, conflicts
10. **Catalog** — local images first; sharing later
11. **Developer portal, push, P2P** — phase 2+

---

## 22. QA smoke checklist (domain-level)

1. Online login → shop has default style figures and sample catalog seeds (if you keep seeding)
2. Sign out → airplane mode → same credentials → app opens (after prior online seed)
3. Create customer → create order → payment → status change
4. Second device or pull sync sees data (when API up)
5. Expired license → read-only; subscription screen works
6. RTL: Dari/Pashto layouts mirror correctly
7. Reports: month income matches payment ledger

---

## 23. Glossary

| Term | Meaning |
|------|---------|
| Perahan/Tunban | Main Afghan garment set |
| Waistcoat | Secondary garment line on same order |
| Cloth | Tailor material (v3 renamed from “fabric” in user-facing EN) |
| Style figure | Shape/style image for a garment part |
| Style part | Section of garment (collar, sleeve, etc.) |
| Snapshot | Frozen copy on order at save time |
| Minor units | Integer money (e.g. whole AFN or fils — pick one convention and stick to it) |
| Outbox | Local queue of pending sync mutations |
| Owner | Shop admin account; manages users and backup |

---

## 24. Change log for this reference

| Date | Note |
|------|------|
| 2026-07 | Initial extraction from v3 for greenfield rebuild; ~80% intentional change |

---

*End of legacy reference. For implementation rules in the new repo, write a fresh `AGENTS.md` tied to the new stack and UX — do not copy v3 `AGENTS.md` verbatim.*
