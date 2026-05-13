# Afghan Pride — Frontend UI Plan: Customers Module

This document defines the **Customers** module UI (full customer list + customer profile), consistent across Android/iOS/Web.

## Goals
- Fast search and lookup (tailor workflow)
- No duplication with Orders module
- Clear separation:
  - Customers list = customers only
  - Orders list = orders only (in Orders module)

## Selected decisions
- Bottom tab **Customers** opens the **full lifetime customer list**.
- Do **not** mix customers and orders into one combined list.
- Customer Profile includes an embedded list: **Today’s orders for this customer** (and optional “All orders” section).
- Customer list supports **Card view** and **List view** toggle.

## Screen 1: Customers List (lifetime)

### Header
- Title: “Customers”
- Search (always visible or collapsible):
  - name
  - phone
- View toggle:
  - List view
  - Card view
- Filter button (opens bottom sheet)

### Filters (bottom sheet)
- Created date:
  - All time (default)
  - Today
  - This week
  - Custom range
- Activity:
  - Has orders
  - No orders yet
- Financial:
  - Unpaid customers (remaining balance > 0) (optional if computed cheaply)
- Sort:
  - Most recent activity (default)
  - Name (A–Z)
  - Most orders (optional)

### Row/Card content (customers only)
Minimal, scannable fields:
- Customer name
- Phone
- Optional small summary (not mandatory; keep simple):
  - last order date
  - total orders count
  - unpaid balance

Tap:
- Opens Customer Profile

Empty state:
- “No customers yet” → CTA “Add customer”

## Screen 2: Customer Profile

### Sections (collapsible)
1) Customer info
- name, phone, address, notes
- Edit allowed for all users

2) Measurement profiles (customer)
- list profiles (latest first)
- actions:
  - create new profile
  - edit in place
  - save as new version

3) Orders for this customer

#### 3a) Today’s orders (selected)
- A small list (max 5–10) of orders for this customer created today (or delivery today; choose later)
- Row shows:
  - order number
  - status chip
  - remaining balance
- Tap opens Order Details

#### 3b) All orders (optional but recommended)
- “View all orders for this customer” link → opens Orders module with customer filter applied

### Customer actions (destructive)
- Delete customer:
  - confirmation dialog
  - follow your global deletion policy (soft-delete recommended)

## Web scope
- Same visuals as mobile.
- Editing allowed for non-device features, consistent with overall web scope.

## Definition of Done
- Customers list search is instant offline (name, phone, address, notes).
- Card/List toggle works and stays consistent with the design system.
- Sort includes recent activity, name, and most orders; filters include activity, created window, and unpaid balance.
- Rows show order count and unpaid total when the customer has orders.
- Customer profile shows name, phone, address, notes; edit and soft-delete (with confirmation).
- Customer Profile shows Today’s orders (for this customer).
- No duplicated “all orders table” inside Customers module; Orders module remains the single full orders list (deep link with `?customer=`).

