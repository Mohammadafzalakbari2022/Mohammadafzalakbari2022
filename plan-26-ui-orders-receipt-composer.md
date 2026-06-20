# Plan 26 — Orders receipt composer (single-screen fast entry)

## Goal

Tailors need **fast order entry** with **fewer taps**. The Orders tab becomes a **single receipt-style screen** for **new and edit**. Order browsing moves to the **Customers** tab.

## UX contract

| Area | Behavior |
|------|----------|
| **Orders tab** (`/app/orders`) | Receipt composer home — customer search/create, garments, measurements, style/shapes, fabric, delivery, status, payment — **all on one scrollable screen**. No bottom sheets for core fields. |
| **New order** | App bar **New order** clears the form. Tab opens directly on the composer (not a list). |
| **Edit order** | `?orderId=` on `/app/orders` loads the same receipt form. Order rows in Customers tab navigate here. |
| **Customers tab** (`/app/customers`) | **Customers** segment (directory) + **Orders list** segment (existing `OrdersFilteredListBody` — same filters/search as today). |
| **Customer name** | **Required** — must select existing or type a new name; order cannot save without it. **Unique per shop** (exact name after trim; احمد ≠ Ahmad). Phone unique when provided. |
| **Everything else** | Optional (measurements, style, fabric, price, delivery, payment). Live soft-red hints when empty. |
| **Save** | Explicit **Save** button. Success snackbar → **form clears** (new mode). Order appears under customer in Customers tab. |
| **Data model** | Unchanged — same Isar entities, shapes from settings, garment types (Perahan/Tunban + waistcoat). |

## Section order (same as current composer)

1. Customer (search engine pick or new name inline)
2. Garment toggles (Perahan/Tunban · Waistcoat)
3. Per garment (when included):
   - Measurements (inline grid from shop measurement types)
   - Style name + catalog design + style figures/shapes (from settings)
   - Fabric (optional presets + text)
   - Item price
4. Delivery date (inline picker)
5. Status (edit mode; new orders default `new`)
6. Payment (item prices + paid now; ledger append on save)

## Routing map (after)

```
/app/orders                    → OrderComposerScreen (tab root)
/app/orders?customerId=        → composer prefill customer
/app/orders?orderId=           → composer edit mode
/app/orders/:orderId           → OrderDetailScreen (read-only quick view; optional)
/app/orders/new                → redirect → /app/orders?...

/app/customers                 → Customers + Orders list (segmented)
/app/customers?...             → same deep-link filters as old /app/orders
```

## Implementation phases

### Phase 1 — Tab & routing
- Swap Orders branch root to `OrderComposerScreen(isTabRoot: true)`.
- `CustomersOrdersTabScreen` with `tabCustomers` / `tabOrdersList` segments.
- Retarget dashboard deep links and `OrdersFilteredListBody` base path to `/app/customers`.
- License block `/app/orders` when editing disallowed.

### Phase 2 — Inline receipt panels
- `PrideOptionalField` — soft-red empty decoration.
- Extract `OrderComposerMeasurementsPanel`, `OrderComposerStylePanel`, `OrderComposerFabricPanel` from sheets (sheets keep thin wrappers for detail edit).
- `OrderComposerReceiptGarmentBlock` — always-expanded per-garment receipt section.

### Phase 3 — Composer behavior
- Tab root: no back button; **New order** resets; Save clears form (no auto-navigate to detail).
- Relaxed save: default delivery = today if unset; allow zero prices; create customer from typed name if needed.
- **Customer name required** (min 2 chars): save disabled, repositories reject empty names, thermal print blocked without name (`customer_name_rules.dart`).
- Edit load via `orderId` query.

## Files (primary)

- `lib/features/orders/order_composer_screen.dart`
- `lib/features/orders/order_composer_receipt_garment_block.dart`
- `lib/features/orders/order_composer_*_panel.dart`
- `lib/core/widgets/pride_optional_field.dart`
- `lib/features/customers/customers_orders_tab_screen.dart`
- `lib/router/app_router.dart`
- `lib/features/orders/orders_filtered_list_body.dart`

## Out of scope (this pass)

- Removing `OrderDetailScreen` entirely (kept for post-save print/share and status audit trail).
- Changing measurement type / shape catalog data in settings.
