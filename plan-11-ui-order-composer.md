# Afghan Pride — Frontend UI Plan: Order Composer (Single Screen)

This document defines the **Order Create** experience as one screen with **collapsible sections**:
Customer → Measurements → Style → Payment → Save.

## Selected behavior (important)
- **No drafts**: nothing is saved until the user completes Payment (or final step) and taps **Save Order**.
- Each section opens a full-screen “frame” for data entry, then returns to the composer with a minimal summary.

Permissions (selected)
- Customer/Measurements/Style/Payment entry in the composer is available to **all users** (not owner-only).

## Screen: Create Order (Composer)

### Layout
- Top app bar:
  - Back
  - Title: “New Order”
  - Optional action: “Reset form” (owner password confirmation not required; just confirm dialog)
- Body: collapsible section list (accordion)
- Bottom sticky bar:
  - Primary CTA: **Save Order**
  - Disabled until required sections are complete

### Sections (accordion)

#### 1) Customer (required)
Collapsed summary (minimal):
- Customer name (and phone optional)

Expanded content:
- Button: “Select customer”
- Button: “Add new customer”

Full-screen frame behaviors:
- **Add new customer** opens Customer Create screen (modal route):
  - fields: name, phone, address/notes optional
  - Save returns to composer and auto-selects this customer
- **Select customer** opens searchable list:
  - search by name/phone
  - selecting returns to composer

#### 2) Measurements (required)
Collapsed summary (minimal):
- Measurement profile label (or “New profile”)

Expanded content:
- Button: “Select measurement profile”
- Button: “Create/Update profile”

Full-screen frame:
- Measurement Profile screen:
  - choose: edit in place OR save as new version (per data model plan)
  - record measurement values (dynamic fields)
  - Save returns to composer and selects that profile

Rule:
- The currently selected customer is pre-filled for this step.

#### 3) Style (required)
Collapsed summary (minimal):
- Design name + count of selected style figures (e.g., “Karzai • 3 figures”)

Expanded content:
- Button: “Select design”
- Button: “Select style figures”
- Optional notes field

Full-screen frames:
- Design picker (simple list)
- Style figures picker (visual grid by category)

#### 4) Payment (required)
Collapsed summary (minimal):
- Total amount • Paid • Remaining

Expanded content:
- total amount
- paid amount (initial payment)
- remaining auto-calculated
- delivery date

Rule:
- Payment entries are append-only later; in composer you record only the initial amounts.

### Save behavior
- Save validates required sections:
  - customer selected
  - measurement profile selected
  - style selected
  - payment totals valid
- On success:
  - show global action feedback bar (success)
  - navigate to Order Details screen (or clear composer and keep customer selected if desired later)

## “Recent Orders” table (within composer screen)
Purpose: reduce user confusion and give immediate context.

Placement:
- After Payment section OR at the bottom of the page.

Selected scope:
- Show **recent orders for the selected customer** (e.g., last 5–10).

Row shows:
- order number
- date
- status
- remaining balance

Row tap:
- opens Order Details (read-only view if license expired)

## Separate tab: All Orders
- A dedicated “Orders” module/tab contains the full orders table:
  - filters (status, date, unpaid)
  - search (order number, customer, phone)
  - create new order opens this composer

## Confusion-prevention rules (key UX)
- Only one visible primary action: **Save Order**.
- Collapsed sections show **only** the selected minimal summary (name/label/amount), nothing more.
- If a user tries to open Measurements/Style/Payment before selecting Customer:
  - show a dialog: “Select customer first.”

## Definition of Done
- User can complete an order with minimal steps and no confusion
- No data is written locally until Save Order
- Accordion summaries are minimal and RTL/LTR safe
- Recent orders list updates immediately after save

