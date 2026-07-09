# plan-31 — Cloth stock and financing

Status: **implemented** (offline-first; sync outbox kinds defined; backend shapes in plan-04).

## Locked product decisions

| Decision | Behavior |
|----------|----------|
| Stock deduct timing | On **order save** (create + edit item upsert) |
| Short stock | **Allowed** — small warning indicator in composer only; never blocks save |
| COGS | **Manual** per shop-stock sale line (`clothSaleCostAmountMinor`); meters metric |
| Customer cloth | Optional; default `clothSource=customerSupplied`; **zero stock impact** |
| Purchases | Full supplier records + **append-only** partial payments (mirror order payments) |
| Sell price | Always **manual** on order (`clothPriceAmountMinor`) |
| Presets vs SKUs | Fabric name/color **presets stay**; **SKUs are inventory**; inline SKU create from composer |
| COGS field visibility | **Shop-stock only** in composer UI |

## Local data model (Isar)

### Order item extensions

On `OrderItemEntity` / summaries / composer draft:

- `clothSourceIndex` — `0` customer supplied, `1` shop stock
- `clothStockSkuInternalId` — nullable FK to SKU
- `clothSaleCostAmountMinor` — manual COGS (shop stock only)

Existing cloth fields unchanged: `clothMetersSnapshot`, `clothPriceAmountMinor`, fabric presets.

### Cloth inventory entities

| Entity | Purpose |
|--------|---------|
| `ClothStockSkuEntity` | SKU catalog + cached `qtyOnHandMilli` |
| `ClothStockMovementEntity` | Append-only ledger (purchase, sale, saleVoid, adjustment) |
| `ClothSupplierEntity` | Vendor directory |
| `ClothPurchaseEntity` | Purchase header + `totalAmountMinor` |
| `ClothPurchaseLineEntity` | Lines: SKU, qty milli-meters, unit cost |
| `ClothPurchasePaymentEntity` | Append-only supplier payments |

Qty stored as **milli-meters** (meters × 1000).

### Movement engine (`ClothStockService`)

- **Sale**: on order save when `clothSource=shopStock`, void prior sale movements for item, append `-qty` sale movement
- **Void**: append compensating `saleVoid` movement (does not delete ledger rows)
- **Purchase**: upsert purchase replaces lines; voids old purchase movements before writing new ones
- **Cache**: SKU `qtyOnHandMilli` updated on each movement append

## Settings UI (under Fabric hub)

Routes (plan-19):

- `/app/settings/fabric/stock` — SKU list + form
- `/app/settings/fabric/suppliers` — supplier CRUD
- `/app/settings/fabric/purchases` — purchase list, form, detail + payment sheet

## Composer UI

`OrderComposerFabricPanel`:

- Source segmented control (customer / shop stock)
- SKU dropdown + inline create
- Manual sell price + COGS (shop stock)
- Short-stock warning icon/text when projected qty &lt; 0

Save path calls `ClothStockService.reconcileOrderItemStock` after each item upsert.

## Reports

`ReportClothCalculations` extended:

- COGS, margin (revenue − COGS)
- Purchases in month
- Supplier payables (purchase total − payments)
- Stock on hand (sum SKU meters)

## Sync outbox kinds

- `cloth_sku_upsert` / `cloth_sku_delete`
- `cloth_supplier_upsert` / `cloth_supplier_delete`
- `cloth_purchase_upsert`
- `cloth_purchase_payment_append`
- `cloth_movement_append`

Helpers: `lib/features/settings/cloth/cloth_sync_helpers.dart`

## Backup

`IsarBackupV1.currentExportVersion = **5**` — includes cloth entities + new order item fields. Imports v1–v5.

## Web parity

`MemoryClothStockRepository` mirrors IO repository for streams and local mutations; sync merge stubs acceptable on web.
