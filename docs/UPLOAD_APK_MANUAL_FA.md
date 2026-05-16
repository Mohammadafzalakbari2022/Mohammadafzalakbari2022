# اگر لینک APK کار نکرد (404) — آپلود دستی در گیت‌هاب

لینک دانلود فقط وقتی کار می‌کند که **یک Release** با فایل **`Pride-android.apk`** ساخته شده باشد.

## روش ۱ — از مرورگر (بدون برنامهٔ اضافی)

1. APK را روی کامپیوتر بسازید (یا از کسی که ساخت گرفته):
   ```powershell
   cd C:\Users\Moh.Akbari\Desktop\Pride-v3
   .\scripts\build-apk-release.ps1
   ```
   فایل: `build\app\outputs\flutter-apk\app-release.apk`

2. همان فایل را کپی کنید و نامش را بگذارید: **`Pride-android.apk`**

3. در مرورگر باز کنید:  
   **https://github.com/Mohammadafzalakbari2022/Mohammadafzalakbari2022/releases/new**

4. **Choose a tag** → تایپ کنید `v1.0.0` → **Create new tag: v1.0.0**

5. **Release title:** `Pride v1.0.0`

6. زیر **Attach binaries** فایل **`Pride-android.apk`** را بکشید و رها کنید.

7. **Publish release** را بزنید.

8. بعد از چند ثانیه این لینک کار می‌کند:  
   **https://github.com/Mohammadafzalakbari2022/Mohammadafzalakbari2022/releases/latest/download/Pride-android.apk**

## روش ۲ — با GitHub CLI (ترمینال)

```powershell
gh auth login
cd C:\Users\Moh.Akbari\Desktop\Pride-v3
.\scripts\build-apk-release.ps1
.\scripts\upload-apk-release.ps1 -Tag v1.0.0
```

## روش ۳ — Actions (خودکار)

**GitHub → Actions → Release Android APK → Run workflow**  
ورژن مثلاً `v1.0.3` — اگر سبز شد، لینک بالا فعال می‌شود.

---

راهنمای نصب برای مشتری: [INSTALL_FA.md](INSTALL_FA.md)
