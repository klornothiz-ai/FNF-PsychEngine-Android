# 🎨 Psych Engine Mobile - Modding Guide

## 📁 Mod Structure

```
/storage/emulated/0/.PsychEngine/mods/
└── MyMod/
    ├── pack.json
    ├── data/songs/
    ├── data/characters/
    ├── data/stages/
    └── scripts/
```

## 📦 pack.json
```json
{"name":"My Mod","description":"Cool mod","version":"1.0.0","author":"You","color":"#FF6600"}
```

## 🎮 Adding Songs
```
data/songs/my-song/
├── my-song-metadata.json
├── my-song-easy.json
└── Inst.ogg
```

metadata.json:
```json
{"song":{"name":"my-song","bpm":160},"stage":"stage","characters":{"player":"bf","opponent":"dad","girlfriend":"gf"}}
```

## 🕹️ Lua Scripts on Android

```lua
function onCreate()
    makeLuaText('watermark', 'My Mod | Mobile', 0, 0, 0)
    addLuaText('watermark')
end
function onUpdate() end
function onBeatHit() end
```

## 🎯 Compatibility
Any existing Psych Engine mod works if:
1. Placed in `.PsychEngine/mods/`
2. All assets present
3. Lua uses Psych Engine compatible functions

## 📝 Tips
- PNG images max 1024x1024
- OGG audio
- Avoid too many simultaneous effects
- Test on 2+ devices