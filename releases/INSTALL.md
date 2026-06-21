# Release APK — 3.6.7+35320

Binary APK is **not stored in git** (large file; build locally or use GitHub Releases).

## Build on Windows

```powershell
$env:PATH = "C:\flutter\bin;" + $env:PATH
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
cd Pride-v3
flutter pub get
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

Copy to phone or to `Desktop\Pride-APK-3.6.7\Pride-3.6.7.apk` for easy access.

- **versionName:** 3.6.7
- **versionCode:** 35320
- **applicationId:** com.pridev3.pride_v3 (update-over-install)
