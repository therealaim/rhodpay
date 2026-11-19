# RHODPAY Stage 2

Stage 2 adds a local-only demo entry screen, create-demo-profile flow, and profile/sign-out screen. It does not create real accounts, authenticate users against a server, store passwords, or connect to financial services.

## Android phone workflow
1. Install Termux from its official F-Droid/GitHub source (not an unofficial APK mirror).
2. In Termux run: `pkg update && pkg upgrade -y`
3. Install tools: `pkg install git unzip openssh -y`
4. Extract this project and use Git to push it to a private GitHub repository.
5. GitHub Actions builds the Android debug APK in the cloud. Open repository → Actions → Build RHODPAY Android APK → latest run → Artifacts → rhodpay-debug-apk.
6. Download and install the APK on your own test phone. Android may ask you to allow installation from the browser/file manager.

## Why cloud build
Flutter's supported Android build toolchain (Android SDK, Java/Gradle, Flutter) is resource-heavy and not a reliable supported native setup on an ordinary Android/Termux phone. Use Termux for editing and Git; use GitHub Actions for compilation. iOS builds require macOS/Xcode and cannot be produced on an Android phone.

## Demo safety
The demo email field is for placeholder/test values only. Do not enter real passwords, bank details, card numbers, or sensitive identity documents. Profile data is memory-only and disappears when the app restarts.
