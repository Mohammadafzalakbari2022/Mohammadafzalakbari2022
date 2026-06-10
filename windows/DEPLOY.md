# Khayat — Windows desktop build

## Requirements

- Flutter stable (with `flutter config --enable-windows-desktop`)
- **Visual Studio 2022** with **Desktop development with C++**
- Internet on first build (plugins such as `sentry_flutter` fetch native deps)

## Release build

From repo root:

```powershell
cd C:\Users\Moh.Akbari\Desktop\Pride-v3
.\scripts\build-flutter-with-defines.ps1 build windows --release
```

Output folder:

```text
build\windows\x64\runner\Release\
```

Run `pride_v3.exe` (Windows app name shown as **Khayat** in properties/taskbar).

Full release (APK + AAB + Windows zip):

```powershell
.\scripts\build-all-release.ps1 -SkipTests
```

## If build fails on `sentry-native`

1. Ensure stable internet, then delete `build\windows` and retry.
2. Or run once with VPN off/on if GitHub downloads are blocked.
3. Verify: `flutter doctor -v` shows Visual Studio OK.

## Microsoft Store (MSIX)

```powershell
.\scripts\build-windows-msix.ps1
```

- **Store upload:** copy `config\msix_publisher.txt.example` → `config\msix_publisher.txt` and paste your Partner Center **Publisher ID** (`CN=...`).
- Output: `Khayat-windows.msix` and `microsoft store ready files\Khayat-windows.msix`

See [`microsoft store ready files/MICROSOFT_STORE_DEPLOY.md`](../microsoft%20store%20ready%20files/MICROSOFT_STORE_DEPLOY.md).

## Play Store note

Android uses **AAB** (`Khayat-release.aab`) with `android\key.properties` (upload keystore).
