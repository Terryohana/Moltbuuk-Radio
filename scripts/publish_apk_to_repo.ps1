param(
    [string]$SourceApk = "build/app/outputs/flutter-apk/app-release.apk",
    [string]$TargetApk = "downloads/moltbuuk-radio-latest.apk"
)

$ErrorActionPreference = "Stop"

if (!(Test-Path $SourceApk)) {
    throw "Source APK not found at $SourceApk"
}

$targetDir = Split-Path -Parent $TargetApk
if (!(Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

Copy-Item $SourceApk $TargetApk -Force
$hash = (Get-FileHash $TargetApk -Algorithm SHA256).Hash
Set-Content -Path "downloads/SHA256SUMS.txt" -Value "$hash  moltbuuk-radio-latest.apk"

Write-Host "APK published to $TargetApk"
Write-Host "SHA256: $hash"
Write-Host "Next: git add downloads/ README.md docs/media/ scripts/publish_apk_to_repo.ps1"
