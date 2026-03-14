# Moltbuuk Radio

Cyberpunk internet radio + real-time AI host conversations.

[![Download Latest APK](https://img.shields.io/badge/Download-Latest_APK-00F0FF?style=for-the-badge&logo=android&logoColor=black)](https://github.com/Terryohana/Moltbuuk-Radio/raw/main/downloads/moltbuuk-radio-latest.apk)
[![View Releases](https://img.shields.io/badge/GitHub-Releases-181717?style=for-the-badge&logo=github)](https://github.com/Terryohana/Moltbuuk-Radio/releases)

## Download APK (Android)

### Quick Install

- **Latest APK (direct):** [Download Moltbuuk Radio APK](https://github.com/Terryohana/Moltbuuk-Radio/raw/main/downloads/moltbuuk-radio-latest.apk)
- **Checksum:** [SHA256SUMS.txt](downloads/SHA256SUMS.txt)

### One-Tap Install (QR)

Scan this QR code on your phone to open the direct APK download:

<p align="center">
  <a href="https://github.com/Terryohana/Moltbuuk-Radio/raw/main/downloads/moltbuuk-radio-latest.apk">
    <img src="docs/media/download-apk-qr.png" width="280" alt="Scan to download Moltbuuk APK" />
  </a>
</p>

### Install on Phone

1. Open the APK link on your Android phone.
2. Download `moltbuuk-radio-latest.apk`.
3. If prompted, allow installs from your browser/files app.
4. Tap the APK and install.

If Android blocks install, go to **Settings → Security/Apps → Install unknown apps** and allow your browser or file manager.

## What You Get

- 🔊 Live radio stream playback
- 🤖 Dual AI hosts with live chat responses
- 🎤 Hold-to-talk voice input (speech-to-text) + text chat
- 🌈 Fast, cyberpunk-style mobile UI

## Run Locally (Full Setup)

### 1) Install Core Tools

- **Flutter SDK**: 3.10+ (project SDK constraint is `^3.10.1`)
- **Dart SDK**: comes with Flutter
- **Android Studio** with Android SDK + platform tools
- **Java**: JDK 17
- **Python**: 3.11+
- **Google Cloud CLI** (`gcloud`)
- **Docker Desktop** (optional, for backend container deploys)

Verify:

```powershell
flutter doctor
python --version
gcloud --version
docker --version
```

### 2) Android Build Prereq (NDK)

Some plugins require newer NDK. In `android/app/build.gradle.kts`, ensure:

```kotlin
android {
    ndkVersion = "28.2.13676358"
}
```

### 3) Flutter App Dependencies

From repo root:

```powershell
flutter clean
flutter pub get
```

Packages used include radio + live tools such as `just_audio`, `audio_service`, `speech_to_text`, `flutter_tts`, `web_socket_channel`, and `http`.

### 4) Run App (Local / Device)

If you want to use default built-in demo endpoints:

```powershell
flutter run
```

If you want your deployed live backend:

```powershell
flutter run --release `
  --dart-define=LIVE_SHOW_SOCKET=wss://<your-cloud-run-host>/ws `
  --dart-define=LIVE_SHOW_REST=https://<your-cloud-run-host>/api
```

### 5) Backend Dependencies (FastAPI + Gemini)

From `live_backend/`:

```powershell
cd live_backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

This installs: `fastapi`, `uvicorn`, `python-multipart`, `google-genai`, `google-auth`, `pydantic-settings`, `requests`.

### 6) Run Backend Locally

Set required env vars and run:

```powershell
$env:PROJECT_ID="<your-gcp-project-id>"
$env:LOCATION="us-central1"
$env:MODEL_NAME="gemini-2.5-flash"
$env:SHOW_ID="neon_duality_showcase"
$env:SYNTH_NAME="Synth DJ"
$env:BYTE_NAME="Byte Poet"
uvicorn app.main:app --host 0.0.0.0 --port 8080 --reload
```

Health checks:

```powershell
curl http://localhost:8080/healthz
curl http://localhost:8080/healthz/gemini
```

### 7) Google Cloud Setup (for Cloud Run)

```powershell
gcloud auth login
gcloud config set project <your-gcp-project-id>
gcloud services enable run.googleapis.com aiplatform.googleapis.com artifactregistry.googleapis.com cloudbuild.googleapis.com
```

If using service account auth:

```powershell
gcloud auth activate-service-account --key-file <path-to-service-account.json>
```

Then deploy backend from `live_backend/` using Docker + Cloud Run (or your existing deploy script flow).

### 8) Radio Stream Tooling Notes

- Audio stream URL is configured in [lib/config/constants.dart](lib/config/constants.dart).
- Playback stack: `just_audio` + `audio_service` + `just_audio_background`.
- Mic speech input stack: `speech_to_text`.
- Host voice playback stack: `flutter_tts`.
- Live messaging stack: `web_socket_channel` + FastAPI WebSocket endpoint.

## Screenshots

<p align="center">
  <img src="docs/media/Moltbuuk1.jpg" width="23%" alt="Moltbuuk screenshot 1" />
  <img src="docs/media/Moltbuuk2.jpg" width="23%" alt="Moltbuuk screenshot 2" />
  <img src="docs/media/Moltbuuk3.jpg" width="23%" alt="Moltbuuk screenshot 3" />
  <img src="docs/media/Moltbuuk4.png" width="23%" alt="Moltbuuk screenshot 4" />
</p>

<p align="center">
  <img src="docs/media/Moltbuuk5.png" width="23%" alt="Moltbuuk screenshot 5" />
  <img src="docs/media/Moltbuuk6.png" width="23%" alt="Moltbuuk screenshot 6" />
  <img src="docs/media/Moltbuuk7.png" width="23%" alt="Moltbuuk screenshot 7" />
  <img src="docs/media/Moltbuuk8.png" width="23%" alt="Moltbuuk screenshot 8" />
</p>

## Keep APK Updated (for repo owner)

From project root:

```powershell
flutter build apk --release
./scripts/publish_apk_to_repo.ps1
```

When GitHub CLI is available/authenticated, also publish a Release asset:

```powershell
git tag -f v1.0.2
git push -f origin v1.0.2
gh release create v1.0.2 downloads/moltbuuk-radio-latest.apk --title "Moltbuuk Radio v1.0.2" --notes "Latest public Android APK build."
```

Then commit and push:

```powershell
git add README.md downloads/ docs/media/ scripts/publish_apk_to_repo.ps1
git commit -m "Update latest APK and landing page"
git push
```

## Dev Notes

- Flutter app source is in `lib/`.
- Backend live agent service is in `live_backend/`.
