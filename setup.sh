#!/bin/bash
set -e
echo "🎮 Psych Engine Android - Setup"
echo ""
if [ -d "assets/base_game" ] && [ -f "assets/readme.txt" ]; then
    echo "✅ All assets already present!"
    du -sh assets/
    exit 0
fi
if [ -d "assets" ] && [ ! -d "assets/base_game" ]; then
    echo "📥 Downloading base_game assets only (~470MB)..."
    git clone --depth 1 --filter=blob:none --sparse https://github.com/ShadowMario/FNF-PsychEngine.git _psych_temp 2>/dev/null
    cd _psych_temp && git sparse-checkout set assets/base_game && cd ..
    cp -r _psych_temp/assets/base_game ./assets/base_game
    rm -rf _psych_temp
    echo "✅ All assets ready!"
    du -sh assets/
    exit 0
fi
echo "📥 Downloading assets from original Psych Engine (~542MB total)..."
git clone --depth 1 --filter=blob:none --sparse https://github.com/ShadowMario/FNF-PsychEngine.git _psych_temp 2>/dev/null
cd _psych_temp && git sparse-checkout set assets && cd ..
rm -rf assets
cp -r _psych_temp/assets ./assets
rm -rf _psych_temp
echo "✅ All assets ready!"
du -sh assets/
echo "🔨 Now run: ./quick_build.sh"