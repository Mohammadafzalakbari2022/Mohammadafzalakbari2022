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

**Multi-garment (Phase 5+):** List row may show a non-localized summary key such as `perahan_tunban+waistcoat` mapped via l10n. Phase 1 does not change list behavior.

Empty state:
- “No orders yet” → button “Create order”

## Screen 2: Order Details

### Sections (collapsible, like composer)
1) Customer (view/edit while not delivered/cancelled)
2) Measurements snapshot (view only; never changes after creation)
3) Style (view/edit while not delivered/cancelled)
4) Payment ledger (append-only)
5) Audit trail (optional later; at least show created_by + timestamps)
   - **Implemented (MVP):** local `createdAt` / `updatedAt`, internal id, current status/delivery, and payment-ledger time range (append-only payments).

**Multi-garment detail (Phase 5+):** Separate collapsible sections per garment item (Perahan/Tunban, Waistcoat) when present; shared payment section shows per-item costs and order total/paid/remaining. Phase 1 does not change detail UI.

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

### Editing rule (selected; implemented in client)
- **All statuses** (including Delivered and Cancelled) allow editing customer, delivery, measurements, style, fabric, internal notes, order total, and status (fix mistaken delivery/cancel).
- **Payments** remain append-only; edit total only if `newTotal ≥ sum(payments)`; new payments cannot exceed remaining due.
- **Confirmations:** delete order or set status to Cancelled → user types **customer name**; other field edits → simple confirm dialog; other status changes → confirm message. **No owner password** on order flows.

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
- Full edit on all statuses works consistently
- Status/delete confirmations use customer-name typing or simple dialog (no owner password)
- Payments behave as append-only ledger

