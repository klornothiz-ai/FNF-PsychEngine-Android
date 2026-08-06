#!/bin/bash
set -e
BT="${1:-release}"
echo "🚀 Psych Engine Quick Android Build"
haxelib install flixel 5.6.1 --quiet 2>/dev/null || true
haxelib install flixel-addons 3.2.2 --quiet 2>/dev/null || true
haxelib install tjson 1.4.0 --quiet 2>/dev/null || true
haxelib install flxanimate --quiet 2>/dev/null || true
haxelib install lime --quiet 2>/dev/null || true
haxelib install openfl --quiet 2>/dev/null || true
haxelib remove linc_luajit 2>/dev/null || true
haxelib git linc_luajit https://github.com/nebulazorua/linc_luajit.git --quiet 2>/dev/null || haxelib install linc_luajit --quiet 2>/dev/null || true
haxelib install hscript-iris 1.1.3 --quiet 2>/dev/null || true
BF=""
if [ "$BT" = "release" ]; then BF="-final"; echo "🔨 RELEASE"; else BF="-debug"; echo "🔨 DEBUG"; fi
haxelib run lime build android $BF
echo "✅ Done!"
find export/ -name "*.apk" 2>/dev/null