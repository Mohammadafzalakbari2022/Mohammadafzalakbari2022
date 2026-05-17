# Afghan Pride — Frontend UI Plan: Order Composer (Hub + modals)

This document defines the **Order Create** experience as one **hub** screen with **summary cards** for Customer, Measurements, and Style; **Payment** stays inline on the hub. Tapping a card or **Edit** opens a **modal bottom sheet**; **Save** on that sheet applies data and closes it. **Structured style** and the **style catalog** are configured under **Settings → Order style (designs & parts)**.

## Selected behavior (important)

- **No drafts**: nothing is saved as an order until the user completes required fields and taps **Save Order**.
- **Add new customer** from the composer uses `returnTo=orderComposer`: **notes are hidden** on that flow; after save the app **pops back** to the composer with the new customer **selected** (Customers tab “new customer” still navigates to the customer profile).
- **Post-save**: after a successful save, a sheet offers **Print receipt**, **Share invoice**, and **View order**; the user is then taken to order detail with `fromNew=1` for a one-time hint banner about print/share.

Permissions (selected)

- Customer / Measurements / Style / Payment entry in the composer is available to **all users** (not owner-only).

## Screen: Create Order (Composer)

### Layout

- Top app bar: Back, title “New Order”, **Reset form** (confirm dialog).
- Body: **hub cards** (Customer, Measurements, Style) + **Payment** card (inline fields + delivery date).
- Bottom sticky bar: **Save Order** (disabled until valid).

### Hub cards

#### 1) Customer (required)

Card summary: customer name (and phone when present). **Edit** opens a sheet with search, list, **Add new customer** (composer return path), and **Save** to confirm selection.

#### 2) Measurements (required)

Card summary: “Measurements captured” or required hint. **Edit** opens the **full measurements editor** driven by **Settings → Measurement fields** (one field per type). Optional: **Load from saved profile** for the selected customer. Optional footer: **Also save to customer measurement library** (creates a new profile + sync outbox). **Save** writes the text snapshot and structured `measurementSnapshotItems` for the order.

#### 3) Style (required)

Card summary: style text. **Edit** opens the style sheet: if the **style catalog** has designs/parts, user picks **design name** (preset or custom) and a **figure per garment part**; optional extra notes. If the catalog is empty, a single free-text field is used (legacy). Structured selection is stored in **`styleSelectionJson`** on the order entity; a human-readable summary is mirrored in **`styleSummary`** for receipts and sync.

**Optional complete design (photo catalog):** Inside the style sheet, **Choose from catalog** opens **My designs** only. Selection is optional. On save, the order stores frozen **`catalog_*_snapshot`** fields; the customer’s **`last_catalog_*`** fields update when a design was chosen. Thermal receipt prints design name only; PDF/text share may include designer shop name for traceability.

#### 4) Payment (required)

Remains on the hub: total, initial paid, summary card, delivery date picker.

Rule: payment entries are append-only later; in the composer you record only the initial amounts.

### Save behavior

- Validates: customer, non-empty measurements snapshot, non-empty style, valid payment, delivery date.
- On success: enqueue sync, optional initial payment, snackbar, **post-save sheet**, then navigate to **`/app/orders/{id}?fromNew=1`**.

## “Recent Orders” table (within composer screen)

Purpose: reduce user confusion and give immediate context.

- Placement: after Payment / bottom of the page.
- Show **recent orders for the selected customer** (e.g. last 5–10).
- Row tap: opens Order Details (read-only if license expired).

## Separate tab: All Orders

- Full orders table: filters, search, **New order** opens this composer.

## Confusion-prevention rules (key UX)

- Only one visible primary action: **Save Order**.
- Hub cards show minimal summary; **Edit** reopens the modal.
- Opening Measurements without a customer: dialog “Select customer first.”

## Definition of Done

- User can complete an order with minimal steps and no confusion.
- No order row is written locally until **Save Order**.
- Hub + modals are RTL/LTR safe.
- Recent orders list updates immediately after save.
- New customer from composer returns with selection; Customers-tab new customer still opens profile after save.
