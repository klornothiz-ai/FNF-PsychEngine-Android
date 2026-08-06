#!/bin/bash
set -e
echo "🎮 Psych Engine Android - Setup"
echo ""
if [ -d "assets" ] && [ -f "assets/readme.txt" ]; then
    echo "✅ Assets folder already exists!"
    du -sh assets/
    exit 0
fi
echo "📥 Downloading assets from original Psych Engine (~542MB)..."
git clone --depth 1 --filter=blob:none --sparse https://github.com/ShadowMario/FNF-PsychEngine.git _psych_temp 2>&1 | tail -1 || {
    echo "❌ Git failed. Please download manually:"
    echo "   git clone https://github.com/ShadowMario/FNF-PsychEngine.git temp"
    echo "   cp -r temp/assets ./ && rm -rf temp"
    exit 1
}
cd _psych_temp && git sparse-checkout set assets && cd ..
cp -r _psych_temp/assets ./assets && rm -rf _psych_temp
echo "✅ Assets downloaded!"
du -sh assets/
echo "🔨 Now run: ./quick_build.sh"