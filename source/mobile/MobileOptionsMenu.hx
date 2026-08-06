package mobile;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class MobileOptionsMenu
{
	public static var isOpen:Bool = false;
	private static var bg:FlxSprite;
	private static var titleText:FlxText;
	private static var optionTexts:FlxTypedGroup<FlxText>;
	private static var options:Array<MobileOption> = [
		{ name: "Button Alpha", key: "alpha", value: 0.35, min: 0.05, max: 1.0, step: 0.05 },
		{ name: "Button Size", key: "size", value: 120, min: 60, max: 200, step: 10 },
		{ name: "Hitbox Mode", key: "hitboxMode", value: 0, min: 0, max: 1, step: 1 },
		{ name: "Vibrate on Hit", key: "vibrate", value: 1, min: 0, max: 1, step: 1 },
	];
	private static var selectedOption:Int = 0;

	public static function open():Void
	{
		if (isOpen) return;
		isOpen = true;
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0; bg.scrollFactor.set(0, 0);
		FlxG.state.add(bg);
		FlxTween.tween(bg, {alpha: 0.7}, 0.3, {ease: FlxEase.quartOut});
		titleText = new FlxText(0, 40, FlxG.width, "MOBILE OPTIONS", 32);
		titleText.setFormat(null, 32, FlxColor.WHITE, CENTER);
		titleText.alpha = 0; titleText.scrollFactor.set(0, 0);
		FlxG.state.add(titleText);
		FlxTween.tween(titleText, {alpha: 1}, 0.3);
		optionTexts = new FlxTypedGroup<FlxText>();
		var startY:Float = 120;
		for (i in 0...options.length)
		{
			var opt = options[i];
			var text = new FlxText(100, startY + i * 60, FlxG.width - 200, formatOptionText(opt), 24);
			text.setFormat(null, 24, FlxColor.WHITE, CENTER);
			text.alpha = 0; text.scrollFactor.set(0, 0);
			optionTexts.add(text);
			FlxG.state.add(text);
			FlxTween.tween(text, {alpha: 1}, 0.3, {startDelay: 0.05 * i});
		}
		var hintText = new FlxText(0, FlxG.height - 50, FlxG.width, "LEFT/RIGHT to change | UP/DOWN navigate | ENTER save | ESC close", 16);
		hintText.setFormat(null, 16, FlxColor.GRAY, CENTER);
		hintText.alpha = 0.7; hintText.scrollFactor.set(0, 0);
		FlxG.state.add(hintText);
	}

	private static function formatOptionText(opt:MobileOption):String
	{
		var vs = switch (opt.key) {
			case "hitboxMode": (opt.value == 0) ? "ARROWS" : "FULL";
			case "vibrate": (opt.value == 1) ? "ON" : "OFF";
			case "alpha": Std.string(Std.int(opt.value * 100)) + "%";
			default: Std.string(Std.int(opt.value));
		};
		return '> ${opt.name}: [$vs] <';
	}

	public static function update():Void
	{
		if (!isOpen) return;
		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W) { selectedOption--; if (selectedOption < 0) selectedOption = options.length - 1; refresh(); }
		if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S) { selectedOption++; if (selectedOption >= options.length) selectedOption = 0; refresh(); }
		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A) adjustOptionValue(-1);
		if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D) adjustOptionValue(1);
		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE) saveAndClose();
		if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE) close();
	}

	private static function adjustOptionValue(direction:Int):Void
	{
		var opt = options[selectedOption];
		opt.value += direction * opt.step;
		opt.value = FlxMath.bound(opt.value, opt.min, opt.max);
		refresh();
	}

	private static function refresh():Void
	{
		for (i in 0...optionTexts.length)
		{
			var text = optionTexts.members[i];
			text.text = formatOptionText(options[i]);
			text.color = (i == selectedOption) ? FlxColor.YELLOW : FlxColor.WHITE;
		}
	}

	private static function applySettings():Void
	{
		for (opt in options)
		{
			switch (opt.key)
			{
				case "alpha": MobileTouchControls.buttonAlpha = opt.value; MobileTouchControls.applyAlpha(); Hitbox.hitboxAlpha = opt.value;
				case "size": MobileTouchControls.buttonSize = Std.int(opt.value);
				case "hitboxMode": Hitbox.setMode((opt.value == 0) ? "arrows" : "full");
				case "vibrate": FlxG.save.data.vibrateEnabled = (opt.value == 1);
			}
		}
		MobileTouchControls.saveCustomPositions();
		FlxG.save.flush();
	}

	private static function saveAndClose():Void { applySettings(); close(); }

	public static function close():Void
	{
		if (!isOpen) return;
		isOpen = false;
		if (bg != null) { FlxG.state.remove(bg); bg.destroy(); }
		if (titleText != null) { FlxG.state.remove(titleText); titleText.destroy(); }
		if (optionTexts != null) { FlxG.state.remove(optionTexts); optionTexts.destroy(); }
	}
}

typedef MobileOption = {
	var name:String;
	var key:String;
	var value:Float;
	var min:Float;
	var max:Float;
	var step:Float;
}