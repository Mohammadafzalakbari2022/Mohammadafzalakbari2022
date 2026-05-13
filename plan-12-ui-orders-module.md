# Afghan Pride — Frontend UI Plan: Orders Module

This document defines the **Orders** module UX (list + filters + details), consistent across Android/iOS/Web.

## Selected decisions (from discussion)
- Default view: **List/table view with filters**
- Row behavior: **no quick actions** (tap opens Order Details)
- Payments: **append-only ledger** + adjustment/reversal entries
- After Delivered/Cancelled: **lock editing** for consistency

## Orders module entry (bottom navigation)
- Bottom tab: **Orders**
- Primary header actions:
  - Search
  - Filter
  - “New Order” (opens `plan-11-ui-order-composer.md`)

## Screen 1: Orders List (default)

### Layout
- App bar: “Orders”
- Search bar (collapsible):
  - order number
  - customer name
  - phone
- Filter chips row:
  - Status: New / In Progress / Ready / Delivered / Cancelled
  - Unpaid: Only unpaid
  - Date: Today / This week / Custom range
- Main list/table:
  - optimized for fast scan

Row fields (minimal, high signal):
- display_order_no
- customer name
- delivery date
- status chip
- remaining balance chip

Row tap:
- opens Order Details

Empty state:
- “No orders yet” → button “Create order”

## Screen 2: Order Details

### Sections (collapsible, like composer)
1) Customer (view/edit while not delivered/cancelled)
2) Measurements snapshot (view only; never changes after creation)
3) Style (view/edit while not delivered/cancelled)
4) Payment ledger (append-only)
5) Audit trail (optional later; at least show created_by + timestamps)

### Status banner + actions
- Status shown prominently at top (chip + last updated time)
- Status changes are done via a dedicated “Change status” button (not inline quick actions).

Change status flow:
- Options: Mark Ready / Mark Delivered / Cancel
- Delivered/Cancel require:
  - confirmation dialog
  - **owner password confirmation**
- On success:
  - show global action feedback bar (success)
  - create in-app notification for all shop users

### Editing lock rule (selected)
If status is Delivered or Cancelled:
- lock editing for:
  - customer link changes
  - delivery date
  - style
  - measurement snapshot
- allow:
  - viewing all data
  - adding payment entries (selected: payments can be added after delivery/cancel)
  - adding internal notes (optional)

If you want the strictest consistency:
- allow status revert only with owner password (optional later).

## Payment ledger UI (append-only)
- List of payments (date/time, amount, method, created_by)
- Button: “Add payment”
- Button: “Add adjustment/reversal” (optional label: “Correction”)
- Totals card:
  - total, paid, remaining

## Web scope
- Same visuals as mobile.
- No printing/Bluetooth/images features; Orders module remains functional.

## Definition of Done
- Orders list is fast and clear in RTL/LTR
- No row quick actions (details only)
- Delivered/Cancelled lock works consistently
- Status change confirmation uses global dialog design + owner password confirmation
- Payments behave as append-only ledger

