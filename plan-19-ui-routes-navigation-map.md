# Afghan Pride — Implementation-Ready UI Routes + Navigation Map

This document defines the **route map**, **navigation structure**, and **route guards** for implementation.

## Navigation model (selected)
- Bottom navigation tabs (primary):
  - Orders
  - Customers
  - Catalog
  - Reports
  - Settings
- Dashboard is **not** a tab:
  - opens as a start-edge swipe panel (RTL/LTR aware) + optional hamburger for discoverability

## Global route guards

### Auth guard
- If not authenticated:
  - route to Auth flow

### License guard
- If license expired:
  - app becomes read-only (except Subscription page)
  - route guard can redirect any blocked “edit” routes to Subscription, but “view” routes remain accessible

### Developer guard
- Developer routes are enabled only if server confirms developer account (`is_developer=true`)
- Developer portal requires internet

## Route map (go_router)

### Auth
- `/auth/login`
- `/auth/register-shop` (create shop + owner user)

### Shell (bottom nav)
- `/app/orders`
- `/app/customers`
- `/app/catalog`
- `/app/reports`
- `/app/settings`

Dashboard panel:
- not a route; it is a UI overlay/panel accessible from any shell tab.

### Orders
- `/app/orders/new` (Order Composer; see `plan-11-ui-order-composer.md`)
- `/app/orders/:orderId` (Order Details; see `plan-12-ui-orders-module.md`)

### Customers
- `/app/customers/new`
- `/app/customers/:customerId`
- `/app/customers/:customerId/measurement-profiles/new`
- `/app/customers/:customerId/measurement-profiles/:profileId` (edit in place / save as new version)

### Catalog
- `/app/catalog/:catalogItemId`
- `/app/catalog/new` (mobile only: camera/gallery)
- `/app/catalog/shared` (public directory; only when shop sharing enabled)

### Reports
- `/app/reports/monthly-income`
- `/app/reports/unpaid`
- `/app/reports/payments-ledger` (optional)

### Settings
- `/app/settings/subscription`
- `/app/settings/users` (owner only)
- `/app/settings/backup-restore` (owner only; password confirm)
- `/app/settings/notifications`
- `/app/settings/sync-diagnostics`
- `/app/settings/appearance-language`
- `/app/settings/about`

**Fabric & cloth stock (plan-31):**
- `/app/settings/fabric` (hub)
- `/app/settings/fabric/names`
- `/app/settings/fabric/colors`
- `/app/settings/fabric/stock` (+ `/new`, `/:skuId`)
- `/app/settings/fabric/suppliers`
- `/app/settings/fabric/purchases` (+ `/new`, `/:purchaseId`)

Developer portal (developer only):
- `/app/settings/developer`
- `/app/settings/developer/codes`
- `/app/settings/developer/shops`
- `/app/settings/developer/password-resets`
- `/app/settings/developer/diagnostics`

## Deep-linking rules
- Allow opening Order Details and Customer Profile by internal_id
- If opened while unauthenticated, store pending route and redirect after login

## Editing vs viewing routes (license/read-only)
- Viewing routes must remain accessible in expired mode:
  - Order Details (view)
  - Customer Profile (view)
  - Catalog browsing
  - Reports viewing
- Editing entry points must be disabled/guarded:
  - New Order
  - Add payment
  - Edit customer/style
  - Add catalog image
  - Backup/restore (already owner-only)

## Implementation checklist
- Create `AppShell` with bottom nav + nested navigation stacks per tab
- Implement route guards:
  - auth
  - developer
  - edit-blocking when license expired
- Centralize navigation helpers:
  - openOrder(orderId)
  - openCustomer(customerId)
  - openCatalogItem(id)

## Definition of Done
- All routes compile and are reachable
- Guards work (auth/license/developer)
- Bottom nav preserves each tab’s navigation stack
- RTL/LTR does not break dashboard edge swipe direction

