# Afghan Pride — QA, Testing, Release Plan (Full System)

## Testing layers

### Unit tests
- model serialization (DTO ↔ domain)
- repositories (Isar persistence)
- sync diff/outbox logic

### Integration tests
- API auth verification (custom username+password auth)
- sync push/pull happy path
- license enforcement behaviors

### Device QA (must)
- low-end Android performance
- RTL UI verification (Dari/Pashto)
- printing tests (58mm/80mm)
- offline scenarios:
  - airplane mode create/edit orders
  - offline login (owner + normal user) after first online login
  - reconnect and sync
  - conflict scenario simulation

### Web QA (limited scope; UI testing only)
Web is not feature-parity. Verify only:
- navigation, layouts, responsiveness
- RTL/LTR layout correctness
- core CRUD UI flows that do not depend on device-only features
- login + license status display (basic)

Explicitly excluded on Web (do not test; should be disabled in UI):
- all printing (PDF/thermal)
- Bluetooth / printer pairing
- catalog image capture/upload (camera/gallery)

## Release checklist (mobile)
- versioning strategy
- crash reporting added (optional but recommended)
- analytics (optional; keep privacy in mind)
- store assets + localized screenshots

## Operational checklists
- backup/restore tested on real devices
- migration strategy for DB schema updates
- admin portal audit logs working

Backup encryption QA (required)
- backup export requires **owner login password confirmation**
- restore requires **owner login password confirmation**
- wrong password handling:
  - clear error message
  - no partial restore

Backup merge QA (selected)
- Restore performs **merge**, not “replace all”
- Conflicts on merge:
  - preserve both records when possible (prefer internal_id as identity)
  - if collisions occur (e.g., duplicated usernames inside same shop), report a clear restore summary and require owner action

Restore summary UX QA (selected)
- After restore, show a “Restore Summary” screen:
  - counts of records merged per entity
  - list of conflicts needing action
  - links to fix screens (e.g., duplicate username resolution)

Duplicate username resolution (required)
Usernames are unique per shop. During merge restore:
- If two users in the same shop share the same username:
  - mark restore as “needs action”
  - owner must resolve by:
    - renaming one user, OR
    - deleting (soft-delete) one user
- Until resolved:
  - keep both user records stored, but prevent the duplicate username from being used for login
  - show a clear error if a duplicate username tries to log in

Backup images QA (selected)
- Backup UI offers:
    - data-only backup
    - data + images backup (larger file)
- Verify restored images are not visible in phone gallery

**Store launch, signing, and deploy:** **`plan-21-launch-deployment.md`**.
