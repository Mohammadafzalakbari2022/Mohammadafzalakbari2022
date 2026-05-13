# Afghan Pride — Frontend UI Plan: Catalog Module (Local Images + P2P Sharing)

This document defines the **Catalog** module UI and the opt-in **public sharing** behavior.

## Goals
- Local-only catalog images (no cloud storage)
- Fast browsing with thumbnails
- Clear metadata: design name + shop name (designer) + date added
- Optional community sharing: public directory + direct device-to-device transfer

## Selected decisions
- Images are stored **locally** (camera/gallery on mobile).
- Sharing uses **direct peer-to-peer transfer (WebRTC)** when both shops are online.
- Public directory is **open to any shop**, but visibility is **mutual opt-in**:
  - if your shop shares, you can browse the public shared directory
  - if your shop does not share, you cannot browse others
- Watermark/label uses **shop name** as “designer name”.
- Web: no image add/upload; catalog browsing may be view-only.

## Bottom navigation placement
- Bottom tab: **Catalog**

## Screen 1: Catalog (My Designs)

### Header
- Title: “Catalog”
- Segmented control:
  - My Designs
  - Shared Designs (enabled only if sharing is ON)
- Search
- Filter button
- View toggle: Grid / List

### Item card (grid)
- Thumbnail (fixed aspect ratio)
- Design name
- Designer/shop name (small)
- Date added (small)

### Item row (list)
- Thumbnail left
- Design name + designer/shop name + date added

### Add design (mobile only)
- FAB: “Add design”
  - Camera
  - Gallery

Add form (full-screen):
- Design name (required)
- Designer/shop name auto-filled (shop name; not editable)
- Date added auto (today; not editable)
- Notes (optional)
- Save

Image sizing rules
- Store:
  - original image (kept for quality)
  - generated thumbnail for fast lists/grid
- Display:
  - thumbnails in grid/list
  - full image in detail view with pinch zoom (optional later)

## Screen 2: Catalog Item Detail
- Full image preview
- Metadata:
  - design name
  - designer/shop name (watermark label)
  - date added
  - notes
- Actions:
  - Edit metadata (no image edit required)
  - Delete (confirmation)
  - Share toggle (only if shop sharing enabled)

## Sharing UX (mutual opt-in)

### Catalog → Sharing (selected placement)
- Toggle: “Enable catalog sharing” lives in the **Catalog tab** (easy access).
- Explanation:
  - Enabling allows others to see your shared designs
  - You can browse the public directory only if sharing is enabled

Optional shortcut:
- Settings can show a “Catalog sharing” row that deep-links into Catalog → Sharing.

### Per-item sharing
- Each item has “Share publicly” toggle:
  - OFF: visible only to your shop
  - ON: appears in public directory (metadata only)

## Shared Designs (public directory)

### Screen: Shared Designs
- Search by:
  - design name
  - designer/shop name
- Filters:
  - newest
  - most downloaded (optional later)
- Grid/list view like My Designs

Item shows:
- thumbnail placeholder until downloaded
- design name
- designer/shop name (watermark label)
- date added

Action:
- “Download” (no approval required)

## P2P transfer (no cloud images)

Important: the server may store **metadata**, but **never stores image binaries**.

### Online requirements
- Both shops/devices must be online at the same time.
- Transfer uses WebRTC data channel:
  - API/Supabase used only for signaling (offer/answer/ICE)
  - image transferred device ↔ device

### Download flow (user-visible)
1) User taps Download on a shared design.
2) App shows “Waiting for sender to be online…”
3) When sender is online:
   - establish P2P connection
   - download chunks with progress UI
4) Save image locally as a new catalog item:
   - keep original designer/shop name + original date added
   - add “Imported at” timestamp (optional)

Approval rule (selected)
- Download requires **no sender approval**.
- Constraint is purely technical: both sides must be online for P2P transfer.

### Abuse controls (recommended)
- Rate limit downloads per shop/day
- Allow sender shop to disable sharing anytime (stops future transfers)

## Web scope
- Catalog on Web:
  - can browse metadata
  - no camera/gallery add
  - downloading images via P2P is optional; can be disabled to reduce complexity

## Definition of Done
- My Designs: grid/list + search + sort (newest/oldest/name) + add via camera/gallery (mobile)
- Metadata stored and displayed clearly
- Sharing toggle works (mutual opt-in gate enforced)
- Shared Designs directory browsable when sharing enabled
- P2P download flow works with progress + retry UI

