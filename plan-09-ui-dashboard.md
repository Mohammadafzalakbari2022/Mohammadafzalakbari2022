# Afghan Pride — Frontend UI Plan: Dashboard

This document defines the **Dashboard** UI for Android/iOS first (Web optional/limited).

## Goals
- Show “today’s work” at a glance for tailors
- One-tap navigation into critical lists (new/in-progress/ready/unpaid)
- Fast loading offline (no spinners as the default UX)
- RTL/LTR friendly layout

## Primary widgets (mobile)

### 0) Navigation pattern (selected)
- App navigation uses a **bottom navigation bar** (Orders / Customers / Catalog / **Reports** / Settings) — same five tabs as `plan-19-ui-routes-navigation-map.md` and `plan-01-architecture.md`.
- Dashboard is **not** a bottom tab. It opens as a **sliding panel/drawer** via:
  - edge swipe from the **start side** (LTR: left edge, RTL: right edge)
  - optional hamburger icon for discoverability

### 1) Top app bar
- Hamburger menu (opens Dashboard panel)
- Shop name (tap → Shop settings)
- Notifications icon (badge count) (opens Notifications history inside Settings)
- Sync status indicator (icon + last sync time)

States:
- Offline: show “Offline” chip
- Sync queued: show queued count
- License expired: show banner + link to Subscription

### 2) KPI cards (2x2 grid)
Cards (tap navigates to filtered list):
- New Orders (count)
- In Progress (count)
- Ready (count)
- Unpaid Balance (amount)

Rules:
- Counts computed from local DB instantly
- Amounts from payments ledger totals (append-only)

### 2b) Financial analysis (monthly income)
Show a simple monthly income card:
- “This month income” (sum of payments received in current month)
- Optional: small trend indicator vs last month (▲/▼)

Rules:
- Computed from local payments ledger (append-only).
- Must work offline (uses local data).

### 2c) Quick links (navigation only; no CRUD)
Small quick-link row/buttons for common views:
- Unpaid orders
- Overdue deliveries
- Delivered today
- Reports (Monthly) (opens Reports tab → Monthly Income)

### 3) “Today” section
- Today’s deliveries (list preview, max 5)
- Overdue orders (if delivery_date < today and not delivered)

### 3b) Notifications preview (inside Dashboard)
- Show a small “Recent notifications” preview (max 3)
- Tap “View all” navigates to Settings → Notifications

Row item:
- display_order_no
- customer name
- delivery date
- status chip
- remaining balance chip

### 4) Search entry
- Single search box:
  - order number
  - customer name
  - phone

Routes:
- Takes user to global search results screen (future doc) or Orders list with search query.

## Tablet/Desktop layout (optional)
- Left sidebar navigation (if enabled)
- Dashboard content in a 2-column layout:
  - KPIs + search left
  - Today/Overdue lists right

## Web scope
Web Dashboard supports:
- viewing KPIs and lists
- navigation and search
- no CRUD actions; dashboard remains read-only navigation + insights

Explicitly excluded on Web:
- printing actions
- Bluetooth/printer controls
- image capture/upload flows

## Empty states
- No orders yet: show a single “Go to Orders” CTA (no create from dashboard)
- No customers yet: link to Customers list (no create from dashboard)

## Performance & UX notes
- Dashboard should render with **cached local aggregates** and then refresh in background:
  - store a small `dashboard_cache` locally (optional)
- Charts are optional; if used, keep it minimal (tiny sparkline only) to preserve speed.

## Definition of Done
- Loads in < 300ms on mid device from local DB
- All KPIs correct offline
- RTL verified (Dari/Pashto)
- Dashboard contains **no CRUD or status-changing actions**
