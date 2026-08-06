# 🎮 Psych Engine - Android Build Guide

## 🏗️ How Haxe works on Android

```
Haxe (.hx) → hxcpp (C++) → Android NDK (.so) → APK (native)
```

## 📦 Requirements

| Tool | Version | Notes |
|------|---------|-------|
| Haxe | 4.2.5 | Recommended |
| hxcpp | 4.2.x | Critical |
| JDK | 11+ | Temurin recommended |
| Android SDK | API 34 | Via Android Studio |
| Android NDK | r21e | Or r15c |

## 🚀 Quick Setup

### 1. Install Haxe
```bash
sudo add-apt-repository ppa:haxe/releases -y && sudo apt-get update && sudo apt-get install haxe -y  # Linux
brew install haxe  # macOS
```

### 2. Setup Android SDK/NDK
Install Android Studio → SDK Manager → API 34 + NDK r21e

### 3. Setup Lime
```bash
haxelib install lime
haxelib run lime setup android
```

### 4. Build APK
```bash
chmod +x quick_build.sh && ./quick_build.sh
```

APK location: `export/release/android/bin/app/build/outputs/apk/debug/`

## 🔧 Troubleshooting

### `hxcpp.h not found`
```bash
haxelib remove hxcpp && haxelib install hxcpp 4.2.0 && haxelib set hxcpp 4.2.0
```

### `__atomic_compare_exchange_4` error
Use Haxe 4.2.5 or dev hxcpp:
```bash
haxelib git hxcpp https://github.com/HaxeFoundation/hxcpp.git
```

### `bits/c++config.h` not found
Use NDK r21e or r15c only.

### Missing extension
```bash
haxelib git extension-androidtools https://github.com/MAJigsaw77/extension-androidtools.git
```

## 📊 Google Play Requirements

- 64-bit: `arm64-v8a` built by default
- Target API 34
- App Bundle: `./build_android.sh --aab`
- Keystore: `<certificate path="key.keystore" alias="1" if="android" />`

## 📝 Notes

1. Haxe 4.2.5 is most stable for Android
2. First build takes 10-20 min (C++ compilation)
3. Subsequent builds are much faster
4. LuaJIT needs special `linc_luajit` for Android