# Afghan Pride — Complete Master Project Blueprint

## Split Plan Documents (Full System)

This file is the **master blueprint**. For a production-grade full system plan, see:
- `plan-00-index.md` (reading order)
- `plan-01-architecture.md` (app architecture + module boundaries)
- `plan-02-data-model.md` (tables/entities, IDs, constraints)
- `plan-03-sync-offline.md` (offline-first + conflict strategy)
- `plan-04-backend-api.md` (NestJS TypeScript API + responsibilities)
- `plan-05-admin-portal.md` (in-app developer/admin portal)
- `plan-06-security-licensing.md` (auth, licensing, anti-abuse, RLS)
- `plan-07-hosting-devops.md` (Supabase + API hosting + environments)
- `plan-08-qa-release.md` (testing, QA, release checklist)
- `plan-09` … `plan-19` (UI + routes; see `plan-00-index.md`)
- `plan-20-flutter-tooling-and-environments.md` (dev/staging/prod URLs, codegen, build rules)

## Project Identity

### Project Name
Afghan Pride

### Project Type
Offline-first Afghan traditional tailoring management platform.

### Target Market
Traditional Afghan men’s tailoring businesses creating Perahan Tonban / Birahan clothing.

### Supported Platforms
- Android
- iOS
- Web

---

# Product Vision

Afghan Pride is designed to modernize Afghan tailoring businesses with a simple, fast, offline-first, multilingual system that works on phones, tablets, and web browsers.

The application combines:
- Tailor business management
- Visual tailoring workflows
- Measurement management
- Design catalogs
- Thermal invoice printing
- Multi-user collaboration
- Subscription licensing

The app must remain:
- Simple
- Fast
- Easy for non-technical users
- Offline-friendly
- Scalable
- AI-development-friendly

---

# Core Product Philosophy

The application should:
- Work without internet
- Save data locally first
- Sync later automatically
- Use minimal clicks
- Use large touch-friendly UI
- Support Afghan business workflows
- Support RTL and LTR layouts
- Be optimized for real tailoring shops

---

# Technology Stack

## Frontend
Flutter

Reason:
- Single codebase
- Android/iOS/Web support
- Excellent RTL support
- Responsive layouts
- Strong ecosystem

---

## State Management
Riverpod

Reason:
- Simpler than Bloc
- Better AI code generation
- Cleaner architecture
- Less boilerplate

---

## Backend
Supabase

Reason:
- PostgreSQL support
- Easier authentication
- Easier subscription logic
- Easier future scaling

---

## Online Database
PostgreSQL

---

## Offline Database
Isar

Reason:
- Fast local storage
- Offline-first support
- Good Flutter integration

---

# Application Architecture

## Architecture Type
Feature-first modular architecture.

---

## Folder Structure

/lib
  /core
  /features
    /auth
    /dashboard
    /customers
    /orders
    /measurements
    /designs
    /catalog
    /payments
    /reports
    /invoices
    /settings
    /backup_restore
    /subscription
    /admin
  /services
  /repositories
  /models
  /widgets
  /shared
  /l10n

---

# Architecture Principles

## Required
- Small reusable widgets
- Modular features
- Clean naming
- Repository pattern
- Offline-first logic
- Minimal dependencies

## Avoid
- Overengineering
- Huge files
- Complicated permissions
- Deep abstractions

---

# Design System

## Colors
- White background
- Dark green primary color
- Gold accent color
- Soft gray cards

---

## UI Style
- Rounded corners
- Card-based layouts
- Large buttons
- Large typography
- Fast workflows
- Minimal clicks

---

## Navigation

### Mobile
Bottom navigation

### Web/Desktop
Use the **same five-tab bottom navigation** as mobile for MVP and per `plan-19-ui-routes-navigation-map.md` (Android + Web + iOS parity). A **navigation rail / sidebar** for large breakpoints is optional later and must not replace the tab model without updating the plan set.

---

## Theme Support
- Light mode
- Dark mode

---

# Language System

## Supported Languages

### Default
Dari (RTL)

### Secondary
Pashto (RTL)

### Third
English (LTR)

---

# RTL/LTR Requirements

The application must support:
- Dynamic text direction
- Layout inversion
- Proper alignment
- RTL invoices
- LTR English layouts

---

# Authentication System

## Authentication Type
Custom authentication.

No:
- SMS OTP
- WhatsApp OTP

---

## Registration Fields
- Shop name
- Username
- Password
- Phone number
- Email optional

---

# Trial System

## Free Trial
15-day free trial.

---

## Trial Limitations
Trial users cannot:
- Use backup/restore

---

# Subscription Plans

## Plans
- 1 Year
- 2 Year
- Lifetime

---

# Activation Code System

Inside:
Settings → Subscription

User can:
- Enter activation code
- Activate plan
- View current plan
- View expiration date

---

# HesabPay System

## MVP
Only payment instructions.

No API integration initially.

Users:
- Pay manually
- Contact support
- Receive activation code

Future:
- Full HesabPay integration

---

# Multi-User Shop System

## Structure
One shop can have:
- Maximum 5 users

Selected limits by subscription:
- Trial: maximum **2 users**
- Paid: maximum **5 users**

User creation (in-app; shop admin controlled):
- Shop admin can create users (username + password)
- Shop admin can remove users
- Enforced server-side when online; enforced via cached license snapshot when offline

---

## Permissions
All users have SAME access.

No:
- Cashier role
- Limited roles
- Measurement-only roles

This simplifies:
- Development
- Sync
- Permissions
- UI

---

# Shared Data System

All users inside same shop share:
- Customers
- Orders
- Measurements
- Payments
- Catalog
- Settings

Using:
shop_id

---

# Offline-First Architecture

## Core Principle
The application must fully work offline.

---

# Offline Features

Users must be able to:
- Create orders
- Edit orders
- Create customers
- Use measurements
- Use catalog
- Print invoices
- Access settings

Without internet.

---

# Sync Strategy

Workflow:
1. Save locally
2. Mark unsynced
3. Sync automatically later

---

# Sync Requirements
- Retry failed syncs
- Background sync
- Conflict handling
- Soft delete support

---

# Master Order ID System

## Structure
Single master ID for:
- Orders
- Payments
- Measurements
- Invoices
- Delivery

---

## Format

8-digit incremental IDs.

Examples:
00000001
00000002
00000003

---

## Shop-Specific IDs

Each shop starts from:
00000001

---

# Customer Module

## Fields

### Required
- Name
- Phone number

### Optional
- Notes
- Address

---

## Phone Number Format
Default country code:
+93

---

# Order Workflow

## Flow

1. Customer information
2. Measurements
3. Design selection
4. Style figure selection
5. Catalog selection
6. Payment information
7. Delivery date
8. Save order

---

# Order Statuses
- New
- In Progress
- Ready
- Delivered
- Cancelled

---

# Measurement System

## Dynamic Measurements

Measurements are NOT hardcoded.

Users can:
- Add fields
- Rename fields
- Delete fields

---

## Examples
- Sleeve
- Neck
- Shoulder
- Chest
- Length
- Pants length

---

# Measurement Units

Inside:
Settings → Preferences

Units:
- Inch
- Centimeter

---

# Measurement Structure

Each measurement contains:
- Name
- Value
- Unit

---

# Design System

## Traditional Design Names

Examples:
- Qasimi
- Karzai

Users can:
- Add designs
- Edit designs
- Delete designs

---

# Style Figure System

The app supports visual tailoring symbols similar to traditional tailoring notebooks.

Examples:
- Sleeve styles
- Collar styles
- Pocket styles
- Bottom cuts
- Front styles

---

# Style Figure Structure

Each figure contains:
- Figure image
- Figure name
- Category

---

# Figure Categories
- Sleeve
- Neck
- Pocket
- Bottom
- Collar

---

# Figure Management

Inside:
Settings → Style Figures

User can:
- Add figure image
- Add figure name
- Add category
- Delete figure

---

# Visual Selection Workflow

During order creation:
- User visually selects style figures

This matches Afghan tailoring workflow.

---

# Catalog System

## Purpose
Visual gallery of tailoring designs.

---

# Catalog Features
- Add image
- Capture image from camera
- Select from gallery
- Add design name
- Add designer name
- Add notes

---

# Storage Strategy

All images stored locally on device.

No cloud image storage initially.

Database stores:
- image_path
- thumbnail_path

---

# Future Community Feature

Future feature:
- Users share catalog designs with each other

Not part of MVP.

Architecture should remain extendable.

---

# Payment Module

## Features
- Total amount
- Paid amount
- Remaining balance

---

# Reports & Analytics

## Dashboard Analytics
- Total orders
- Pending orders
- Delivered orders
- Today's orders
- Total revenue
- Remaining payments

---

## Reports
- Daily reports
- Weekly reports
- Monthly reports
- Yearly reports

---

## Payment Analytics
- Paid amounts
- Remaining balances
- Revenue summaries

---

## Customer Analytics
- Most active customers
- Recent customers

---

## UI Style
- Simple cards
- Simple charts
- Fast loading
- Clean business-focused analytics

---

# Invoice & Printing System

## Invoice Includes
- Order ID
- Customer information
- Measurements
- Design information
- Delivery date
- Payment summary
- Shop logo
- Shop information

---

# Thermal Printer Support

Supported sizes:
- 58mm
- 80mm

---

# Printer Settings

Inside:
Settings → Printer

User can:
- Connect printer
- Test printer
- Select paper size

---

# Sharing & Export System

Users can share:
- WhatsApp
- Telegram
- SMS
- PDF

---

# Shared Information
- Order details
- Status
- Delivery date
- Payment summary

---

# Settings Module

## Sections

### General
- Language
- Theme
- Dark mode

### Preferences
- Measurement units
- Default printer

### Shop
- Shop logo
- Address
- Contact information

### Measurements
- Manage measurement fields

### Designs
- Manage design names

### Style Figures
- Manage visual figures

### Catalog
- Manage catalog

### Subscription
- Activation codes
- Current plan

### Printer
- Thermal printer settings

### Backup & Restore
- Export backup
- Restore backup

---

# Backup & Restore System

## Availability
Only for paid users.

Disabled for trial accounts.

---

# Backup Includes
- Orders
- Customers
- Measurements
- Payments
- Settings
- Catalog references

---

# Restore
Users can:
- Import backup file
- Restore local data

---

# Admin System

## Admin Features
- Create activation codes
- View users
- Track subscriptions
- Track activations
- Track payments

Admin portal exists inside same application.

---

# Database Tables

Main tables:
- shops
- users
- customers
- orders
- measurements
- measurement_types
- designs
- style_figures
- catalog_items
- payments
- activation_codes
- reports_cache

---

# Flutter Packages

## Core
- flutter_riverpod
- go_router

## Backend
- supabase_flutter

## Offline
- isar

## Localization
- intl

## Printing
- pdf
- printing

## Sharing
- share_plus

## Images
- image_picker

## Thermal Printing
- esc_pos_utils
- flutter_esc_pos_network

---

# Development Workflow

## Recommended Strategy
Build module-by-module.

Never generate entire app at once.

---

# Module-by-Module Development Plan (Trackable)

This section converts the blueprint into **trackable modules** with clear “Definition of Done” checklists.

## Global Definition of Done (applies to every module)
- Feature screens work fully offline (create/edit/view)
- Local DB persistence (Isar) + repository wired
- Basic validations + error states
- Localization ready (Dari/Pashto/English text keys used, no hardcoded strings)
- RTL/LTR layout verified on at least 1 screen
- Routes added (go_router)
- Minimal tests where valuable (at least model/repository/service logic when non-trivial)

## Data Identity Rules (important for sync + multi-user)
- Use **two IDs**:
  - **internal_id**: globally unique (UUID/ULID) used for sync/conflict resolution
  - **display_order_no**: 8-digit shop-specific incremental number shown to user (e.g., 00000001)
- Never use display numbers as foreign keys.

## Module 0 — Foundation (Project Baseline)
Deliverables:
- App shell + responsive navigation (bottom nav on mobile, optional sidebar for tablet/desktop)
- Theme (light/dark) + design tokens (colors/typography/radius)
- Localization scaffolding (Dari/Pashto RTL + English LTR)
- Routing base (go_router) + guarded routes
- App-level error handling + logging strategy

## Module 1 — Local Database & Repository Base (Isar)
Deliverables:
- Isar initialization + collections base
- Repository interfaces + implementations
- Local change tracking fields in every entity:
  - created_at, updated_at, deleted_at (soft delete)
  - sync_state (synced/dirty/conflict) or equivalent
  - last_modified_by_user_id (for debugging/conflicts)

## Module 2 — Authentication & Shop Bootstrap (Supabase)
Deliverables:
- Login/register UI (Shop name, Username, Password, Phone, optional Email)
- Shop creation/join flow + shop_id stored locally
- Multi-user limit enforcement (max 5 users per shop)
- “All users same permissions” rule enforced by design (no role matrix)

Notes:
- Custom auth is fine, but for speed/safety prefer using Supabase Auth under the hood while presenting a custom UI.

## Module 3 — Customers
Deliverables:
- Customer CRUD (Name, Phone required; Address/Notes optional)
- +93 default handling + input formatting rules
- Fast search (name/phone) optimized for shop usage

## Module 4 — Measurement Types (Dynamic Fields)
Deliverables:
- Manage measurement fields (add/rename/delete)
- Units settings (inch/cm) in Settings → Preferences
- Migration behavior defined when a measurement type is renamed/deleted (preserve old values vs map/disable)

## Module 5 — Orders (Core Workflow)
Deliverables:
- Order creation wizard flow (as defined in blueprint)
- Order statuses (New/In Progress/Ready/Delivered/Cancelled)
- Order list filters (status, delivery date, customer, unpaid)
- Order detail screen (single source of truth)

## Module 6 — Payments
Deliverables:
- Total/paid/remaining tracking
- Payment history per order (supports partial payments)
- Dashboard rollups (revenue, remaining payments)

## Module 7 — Designs + Style Figures (Visual Tailoring)
Deliverables:
- Manage design names (Qasimi, Karzai, etc.)
- Style figure categories + image management
- Attach selected figures to orders (store references, not images inside DB)

## Module 8 — Catalog (Local Images)
Deliverables:
- Capture/select images (camera/gallery)
- Store images locally (file path + thumbnail path in DB)
- Catalog browsing + attach catalog item to order (reference)

## Module 9 — Invoice + Sharing + Thermal Printing
Deliverables:
- PDF invoice generator (RTL invoice supported)
- Share invoice/order summary (WhatsApp/Telegram/SMS/PDF)
- Thermal print output (58mm/80mm) + printer settings + test print

## Module 10 — Backup & Restore (Paid Only)
Deliverables:
- Export backup file (include all required tables + catalog references)
- Restore flow (local replace/merge behavior explicitly defined)
- Access control (disabled in trial)

## Module 11 — Subscription & Activation Codes
Deliverables:
- Trial countdown (15 days)
- Activation entry screen + plan display + expiration
- Admin code creation + tracking (inside app admin area or separate admin build)

## Module 12 — Sync (Post-MVP hardening)
Deliverables:
- Background sync strategy (push local changes, pull remote changes)
- Conflict policy defined per entity (customer/order/payment/etc.)
- Retry with backoff + “last sync time” visibility
- Soft delete propagation

---

# Tooling & Extensions (Speed + Quality)

## Flutter/Dart packages to strongly consider
- `freezed` + `freezed_annotation`: immutable models + unions (great for sync states)
- `json_serializable` + `build_runner`: reliable serialization
- `riverpod_generator` + `build_runner`: less provider boilerplate
- `isar_flutter_libs` + `isar_generator`: Isar runtime + codegen
- `flutter_localizations` + `intl`: proper i18n foundation (RTL/LTR)
- `flutter_gen_runner`: typed asset access (avoid string asset paths)
- `uuid` or `ulid`: internal unique IDs for offline sync safety

## Dev tools (recommended)
- Flutter DevTools (performance, memory, network)
- Riverpod DevTools (provider inspection)

## VS Code / Cursor extensions (recommended)
- Dart
- Flutter
- Flutter Widget Snippets (optional)
- Error Lens (optional)
- YAML (for `pubspec.yaml`)

## CLI helpers (optional but useful)
- FVM (Flutter Version Management) to lock Flutter SDK per project
- Mason (code templates) for generating feature modules consistently

---

# AI Development Workflow

1. Generate architecture
2. Generate models
3. Generate repositories
4. Generate services
5. Generate Riverpod providers
6. Generate UI
7. Generate sync system

---

# AI Development Rules

## Important
- Use small prompts
- Generate one module at a time
- Keep files modular
- Avoid huge generated files

---

# Deployment Plan

**Canonical detail:** **`plan-21-launch-deployment.md`** — store uploads, signing, listings, privacy/compliance, web hosting, versioning, branding asset pack (`pride_full_platform_icon_pack`), and post-launch operations. **QA before ship:** `plan-08-qa-release.md`.

**Build commands and smoke tests:** **`TESTING.md`**.

At a glance:

- **Android** — Google Play Console: AAB (`flutter build appbundle`), Play App Signing, internal/closed/production tracks, Data safety, privacy policy, screenshots + feature graphic, staged rollout.
- **iOS** — Apple Developer + App Store Connect: signing, Archive/TestFlight, App Privacy, review demo account, device-class screenshots; verify on a **Mac** before submission.
- **Web** — static deploy of `build/web/` (e.g. Cloudflare Pages, Firebase Hosting, Netlify, Vercel); HTTPS, optional `--base-href`, PWA manifest/icons, CORS for API, production `dart-define` per `plan-20`.

---

# MVP Development Phases

## Phase 1
Foundation
- Flutter setup
- Supabase
- Isar
- Localization
- Authentication

---

## Phase 2
Core business
- Customers
- Orders
- Measurements
- Payments

---

## Phase 3
Visual tailoring
- Designs
- Style figures
- Catalog

---

## Phase 4
Invoices
- PDF
- Thermal printing
- Sharing

---

## Phase 5
Subscription system
- Activation codes
- Backup/restore

---

## Phase 6
Optimization
- Sync improvements
- UI refinement
- Performance improvements

---

# Final Product Definition

Afghan Pride is:

“An offline-first multi-user Afghan traditional tailoring management platform with visual tailoring workflows, thermal printing, multilingual support, and subscription licensing.”

---

# Final Important Recommendations

## Keep the App Simple
Tailors prioritize:
- Speed
- Simplicity
- Reliability

Avoid unnecessary complexity.

---

## Prioritize Offline Stability
Offline reliability is one of the app’s biggest strengths.

---

## Build MVP First
Do not build advanced features too early.

Launch fast.
Improve later.

---

## Keep Architecture Modular
AI development works best with:
- Small modules
- Clear responsibilities
- Clean architecture

---

## Future Features (Not MVP)
Possible future additions:
- Community design sharing
- Online catalog marketplace
- Full HesabPay API
- Cloud image sync
- Advanced analytics
- Customer notifications
- SMS reminders