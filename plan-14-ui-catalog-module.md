# Afghan Pride — Frontend UI Plan: Catalog Module (DEPRECATED)

> **Deprecated**: This document is an older draft. The canonical Catalog plan is
> **`plan-14-ui-catalog.md`** (see `AGENTS.md` / Cursor rule). Keep this file only for history; do not implement from it.

This document defines the **Catalog** module UI (local images + metadata + optional P2P sharing).

## Goals
- Fast local gallery of tailoring designs (offline)
- Simple add/edit/delete catalog entries
- Clear metadata: design name, designer (shop name), date added
- Optional “Public sharing” directory with **mutual opt-in**

## Data fields shown on UI (selected)
Each catalog item displays:
- Design name
- Designer/Created by: **shop name**
- Date added
- Image thumbnail

## Screen 1: Catalog List (bottom navigation)

### Layout
- Header: “Catalog”
- Search:
  - design name
  - designer/shop name (for public directory items)
- View toggle:
  - Grid (default)
  - List
- Filter:
  - Local only
  - Public directory (only if sharing enabled)
  - Favorites (optional later)

### Item card/grid tile
- Thumbnail (fixed aspect ratio; crop center)
- Design name
- Designer/shop name (small)
- Date added (small)

Tap:
- opens Catalog Item Details

### Add design (mobile only)
- FAB or header button: “Add”
- Options:
  - Camera
  - Gallery

Rules:
- Store images in app-private storage (not visible in phone gallery).
- Generate thumbnail for fast scrolling.

Web scope:
- Web can view local metadata and public directory, but cannot add images.

## Screen 2: Catalog Item Details
- Full image view
- Metadata:
  - Design name
  - Designer/shop name
  - Date added
- Actions:
  - Edit metadata (all users)
  - Delete (confirmation dialog)
  - Share toggle (if shop sharing enabled; see below)

## Public sharing (P2P, no cloud storage)

### Concept (selected)
- The “Public directory” shows **metadata only** from any shop that opted in.
- Actual images are transferred **peer-to-peer** (WebRTC) when both parties are online.
- Mutual opt-in rule:
  - If your shop does not share → you cannot browse public directory.

### UX flows

#### A) Enable sharing (Settings)
- Settings → Catalog sharing:
  - Toggle “Share my designs publicly”
  - Explanation: “If you share, you can browse other shared designs.”

#### B) Browse public directory
- Catalog → filter “Public directory”
- Show cards with:
  - design name
  - creator shop name (watermark label)
  - date added
  - placeholder thumbnail if image not downloaded yet

#### C) Acquire/download an image (P2P)
On a public item:
- Button: “Get image”
- App starts a P2P session:
  - show “Waiting for other shop to be online”
  - when online, transfers image and stores it locally
  - apply watermark overlay on preview (shop name)

Rules:
- Do not store images on server.
- If transfer fails, show retry.

## Watermarking (selected)
- Display watermark as creator shop name on image preview:
  - subtle (low opacity), bottom corner, RTL/LTR aware
- Watermark is informational (not strong DRM).

## Definition of Done
- Local catalog works fully offline
- Add from camera/gallery on iOS/Android works; images stored privately + thumbnails generated
- Public directory respects mutual opt-in
- P2P transfer UX is clear and robust (retry, progress, success feedback bar)

