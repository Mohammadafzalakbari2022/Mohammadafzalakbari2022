# Deploy Pride on iOS (App Store / TestFlight)

Same Flutter codebase as Android: **Isar**, sync, shop finance, thermal printer (LAN TCP), camera/gallery, contacts. Web-only limits do not apply on iOS.

**Bundle ID:** `com.pridev3.prideV3` (see `ios/Runner.xcodeproj`).  
**Min iOS:** 13.0 (`IPHONEOS_DEPLOYMENT_TARGET` / `Podfile`).

## One-time on the Mac (friend’s laptop — do this first)

```bash
cd /path/to/Pride-v3
flutter doctor -v          # Xcode + CocoaPods must be OK
flutter pub get
flutter gen-l10n
cd ios && pod install && cd ..   # or: flutter build ios --config-only
```

### Xcode signing (required before device / TestFlight)

1. Open **`ios/Runner.xcworkspace`** in Xcode (not `.xcodeproj`).
2. Select **Runner** target → **Signing & Capabilities**.
3. Set your **Team** (Apple Developer account).
4. Confirm **Bundle Identifier** is unique for your team (or keep `com.pridev3.prideV3` if you own it).
5. Connect iPhone → **Product → Run** once to trust the developer certificate on the device.

`Info.plist` already includes usage strings for camera, photo library, contacts, and local network (printer).

## Development run (device or simulator)

```bash
flutter run -d ios --dart-define-from-file=config/dart_defines_prod.json
# Simulator:
flutter run -d "iPhone 16" --dart-define-from-file=config/dart_defines_prod.json
```

Production API URL is in [`config/dart_defines_prod.json`](../config/dart_defines_prod.json).

## Release build (TestFlight / App Store)

```bash
./scripts/build-ios-release.sh
```

Or manually:

```bash
flutter pub get
flutter gen-l10n
flutter build ipa --release --dart-define-from-file=config/dart_defines_prod.json
```

Output: **`build/ios/ipa/*.ipa`**. Upload with **Transporter** app or **Xcode → Organizer → Distribute App**.

### Archive from Xcode (alternative)

1. `flutter build ios --release --dart-define-from-file=config/dart_defines_prod.json`
2. Open `ios/Runner.xcworkspace` → **Product → Archive** → **Distribute App**.

## Parity checklist (iOS = Android)

After install, smoke-test on a real device:

| Area | iOS note |
|------|----------|
| Login + sync | Same `API_BASE_URL` as Android build |
| Orders / customers / Isar | Full offline DB (not web memory) |
| New order + style figures | Bundled `assets/style_figures/shape_*.png` |
| Shop finance (Reports) | Rent / expenses / charts |
| Developer portal | `GET /admin/me` → `is_developer` (Render env `PRIDE_DEVELOPER_IDS` / `PRIDE_DEVELOPER_USERS`) |
| Sounds / haptics | System sounds + haptics (no custom Android channel) |
| Thermal printer | LAN IP:port; allow **Local Network** if prompted |
| WhatsApp deep link | Android-only; iOS uses **Share** sheet |
| Backup & restore | Available (native) |

See [`TESTING.md`](../TESTING.md) click-test list — use the **Android (or iOS)** column.

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `pod install` fails | `cd ios && pod repo update && pod install` |
| Signing error | Set Team in Xcode; unique bundle ID |
| Local network / printer | Settings → Privacy → Local Network → enable Pride |
| Stale style images | Delete app and reinstall (seed runs once per shop) |

Full command index: [`COMMANDS.md`](../COMMANDS.md).
