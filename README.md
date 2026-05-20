# Afghan Pride (Pride v3)

Offline-first tailoring shop app — **Flutter** (Android, iOS, Web) + **NestJS API**.

## Download for customers (مشتریان)

| Platform | Link |
|----------|------|
| **Android APK** | https://github.com/Mohammadafzalakbari2022/Mohammadafzalakbari2022/releases/latest/download/Pride-android.apk |
| **Install guide (Dari / دری)** | [docs/INSTALL_FA.md](docs/INSTALL_FA.md) |
| **Download landing page** | [docs/index.html](docs/index.html) — enable [GitHub Pages](https://docs.github.com/en/pages) from `/docs` for a public URL |
| **Web app** | https://pride-v3-web.pages.dev |
| **All releases** | https://github.com/Mohammadafzalakbari2022/Mohammadafzalakbari2022/releases |

**Share with customers (Android):** send the APK link + Dari guide `docs/INSTALL_FA.md`.

**iPhone:** customers cannot install the APK. Use the **web app** or **TestFlight / App Store** when available — see [docs/INSTALL_FA.md](docs/INSTALL_FA.md).

## Developers

- **Project handoff (closure, upgrades, deferred work):** [docs/PROJECT_HANDOFF.md](docs/PROJECT_HANDOFF.md)
- Commands: [COMMANDS.md](COMMANDS.md)
- Testing: [TESTING.md](TESTING.md)
- Agent rules: [AGENTS.md](AGENTS.md)
- API deploy: [api/DEPLOY.md](api/DEPLOY.md)
- iOS (Mac): [ios/DEPLOY.md](ios/DEPLOY.md)
- Web deploy: [web/DEPLOY.md](web/DEPLOY.md)

## Publish a new Android release

```powershell
git tag v1.0.1
git push origin v1.0.1
```

Or: **GitHub → Actions → Release Android APK → Run workflow** (enter tag e.g. `v1.0.1`).

Customers always get the latest APK from `/releases/latest/download/Pride-android.apk`.
