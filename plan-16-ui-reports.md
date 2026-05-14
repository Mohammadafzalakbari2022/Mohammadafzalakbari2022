# Afghan Pride — Frontend UI Plan: Reports (Financial Analysis)

This document defines the **Reports** module (Financial analysis) as a bottom navigation tab.

## Goals
- One place for all financial analysis
- Works fully offline from local ledger data
- Clear, fast, minimal charts (optional)

## Bottom navigation placement (selected)
- Bottom tab: **Reports**
- Order: Orders / Customers / Catalog / Reports / Settings

## Data sources (offline-first)
- Payments ledger (append-only)
- Orders statuses + delivery dates
- Remaining balances (order total - sum(payments))

## Screen 1: Reports Home (Overview)

Cards/sections:
- **This month income** (sum of payments received in current month)
- **This month unpaid** (sum of remaining balances for open orders)
- **Orders summary** (counts by status)
- Quick shortcuts:
  - Monthly report
  - Unpaid report
  - Delivered report

## Screen 2: Monthly Income Report

Controls:
- Month selector (current month default)
- Optional compare toggle (vs previous month)

Outputs:
- Total income for month
- Breakdown:
  - paid amounts (sum payments)
  - unpaid remaining (sum remaining)
- Optional minimal chart:
  - daily totals sparkline/bar (keep lightweight)

## Screen 3: Unpaid / Remaining Balances

Filters:
- by due date (overdue / due soon)
- by amount range (optional)

List rows:
- order number
- customer
- delivery date
- remaining balance

Tap → Order Details

## Screen 4: Paid Payments Ledger (optional)
- Show payments list by date range
- Group by day/week/month

## Web scope
- Same visuals as mobile (no printing/Bluetooth/images)

## Performance rules
- Reports must be instant offline:
  - use local aggregates
  - optionally cache computed monthly totals and recompute in background

## Definition of Done
- Reports tab works offline: this-month payment income, open-order unpaid total, status summary, and shortcuts to unpaid / monthly / delivered reports.
- **This month income** on the Reports overview uses the **same calendar system** as Settings (Gregorian vs solar Hijri) for month boundaries.
- Monthly income screen shows payments received for the selected month plus unpaid remaining on orders due in that month (by delivery date).
- Unpaid report supports **delivery window** filters, **remaining balance amount range** (optional), and sort.
- Delivered report lists delivered orders by delivery month with navigation to Order Details.
- Payments ledger supports grouping **by day, week, or month** in the selected date range.
- Money amounts use the same formatted currency style as the rest of the app (`moneyAfn`).
- RTL/LTR verified (layout uses standard Material / directional widgets).

## Implementation status (Flutter repo)

As of **plan-25-implementation-backlog.md**, the items above are implemented in the client. Server sync, push notifications, and other backend-dependent features remain documented separately.

