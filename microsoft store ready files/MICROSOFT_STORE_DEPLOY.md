# Microsoft Store — Khayat (Windows desktop)

**Version:** `3.6.2.35313` (from `pubspec.yaml` `3.6.2+35313`)

## What you have now

| File | Use |
|------|-----|
| `Khayat-windows.msix` | **Sideload / QA** (signed with msix dev test cert — **not** Partner Center upload) |
| `Khayat-msix-dev-cert.cer` | Trust cert on PC **before** installing MSIX (see below) |
| `Khayat-windows-x64.zip` | Extract and run `pride_v3.exe` with all DLLs (no cert needed) |

### Install MSIX on your PC (no Microsoft Store)

Error `0x800B010A` means Windows does not trust the dev signing certificate yet.

**Option A — one script (recommended):** open **PowerShell as Administrator**, from repo root:

```powershell
.\scripts\install-khayat-windows.ps1
```

This installs the cert and the MSIX.

**Option B — manual:** Admin PowerShell:

```powershell
certutil -addstore Root "microsoft store ready files\Khayat-msix-dev-cert.cer"
```

Then double-click `Khayat-windows.msix`.

## What to upload to Microsoft Store

Partner Center requires an **unsigned** MSIX built with your **Publisher ID** (`CN=...`). After you add `config/msix_publisher.txt`, re-run `.\scripts\build-windows-msix.ps1` — that produces a Store-upload `Khayat-windows.msix` (unsigned; Microsoft re-signs on publish).

| File | Use |
|------|-----|
| `Khayat-windows.msix` (Store build) | **Partner Center → Submit → Packages** |

## One-time setup

1. **Partner Center** — reserve app name **Khayat**, create Windows app submission.
2. **Product identity** — copy **Publisher ID** (starts with `CN=...`).
3. In this repo:
   ```powershell
   copy config\msix_publisher.txt.example config\msix_publisher.txt
   ```
   Paste your Publisher ID into `config/msix_publisher.txt` (one line).

## Build MSIX

From repo root (Visual Studio 2022 + Flutter required):

```powershell
.\scripts\build-windows-msix.ps1
```

Output:

- `Khayat-windows.msix` (repo root)
- `microsoft store ready files\Khayat-windows.msix`

Version comes from `pubspec.yaml` (e.g. `3.6.2+35313` → MSIX `3.6.2.35313`).

## Partner Center checklist

1. **Packages** — upload `Khayat-windows.msix`.
2. **Store listings** — description, screenshots (1366×768+), icon 300×300.
3. **Privacy policy** — same URL as Play Store if applicable.
4. **Age rating** — complete IARC questionnaire.
5. **Submit for certification**.

## Notes

- With `config/msix_publisher.txt` set, the script passes `--store` (unsigned; Store re-signs on publish).
- Package identity in `pubspec.yaml` → `msix_config.identity_name` must match Partner Center **Package identity** (`pridev3.khayat` unless you change both).
- Do **not** distribute `pride_v3.exe` alone — always ship the full `Release` folder or the MSIX.
