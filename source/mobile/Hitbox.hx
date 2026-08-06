package mobile;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;

class Hitbox
{
	public static var hitboxGroup:FlxTypedGroup<FlxSprite>;
	public static var leftHitbox:FlxSprite;
	public static var downHitbox:FlxSprite;
	public static var upHitbox:FlxSprite;
	public static var rightHitbox:FlxSprite;
	public static var hitboxAlpha:Float = 0.15;
	public static var hitboxMode:String = "arrows";
	private static var initialized:Bool = false;
	private static var touchInLeft:Bool = false;
	private static var touchInDown:Bool = false;
	private static var touchInUp:Bool = false;
	private static var touchInRight:Bool = false;

	public static function init():Void
	{
		if (initialized) return;
		initialized = true;
		hitboxGroup = new FlxTypedGroup<FlxSprite>();
		if (hitboxMode == "arrows") createArrowHitboxes(); else createFullHitboxes();
	}

	private static function createArrowHitboxes():Void
	{
		var w:Float = 160; var h:Float = 160; var s:Float = 20;
		var sx:Float = 50; var sy:Float = FlxG.height - h - 40;
		leftHitbox = createHitboxSprite(sx, sy + h + s, w, h, FlxColor.fromRGB(0, 191, 255));
		downHitbox = createHitboxSprite(sx + w + s, sy + h * 2 + s * 2, w, h, FlxColor.fromRGB(255, 255, 0));
		upHitbox = createHitboxSprite(sx + w + s, sy, w, h, FlxColor.fromRGB(255, 0, 0));
		rightHitbox = createHitboxSprite(sx + (w + s) * 2, sy + h + s, w, h, FlxColor.fromRGB(0, 255, 0));
		hitboxGroup.add(leftHitbox);
		hitboxGroup.add(downHitbox);
		hitboxGroup.add(upHitbox);
		hitboxGroup.add(rightHitbox);
	}

	private static function createFullHitboxes():Void
	{
		var hw = FlxG.width * 0.5;
		var hh = FlxG.height * 0.5;
		leftHitbox = createHitboxSprite(0, 0, hw, FlxG.height, FlxColor.fromRGB(100, 100, 100));
		rightHitbox = createHitboxSprite(hw, 0, hw, FlxG.height, FlxColor.fromRGB(150, 150, 150));
		hitboxGroup.add(leftHitbox);
		hitboxGroup.add(rightHitbox);
	}

	private static function createHitboxSprite(x:Float, y:Float, w:Float, h:Float, color:FlxColor):FlxSprite
	{
		var sprite = new FlxSprite(x, y);
		sprite.makeGraphic(Std.int(w), Std.int(h), color);
		sprite.alpha = hitboxAlpha;
		sprite.scrollFactor.set(0, 0);
		return sprite;
	}

	public static function update():Void
	{
		if (!initialized) return;
		resetTouchStates();
		for (touch in FlxG.touches.list)
		{
			if (touch == null) continue;
			if (hitboxMode == "arrows") checkArrowHitboxes(touch.x, touch.y, touch.pressed);
			else checkFullHitboxes(touch.x, touch.y, touch.pressed);
		}
		if (touchInLeft) MobileInputHandler.onButtonDown("left") else MobileInputHandler.onButtonUp("left");
		if (touchInDown) MobileInputHandler.onButtonDown("down") else MobileInputHandler.onButtonUp("down");
		if (touchInUp) MobileInputHandler.onButtonDown("up") else MobileInputHandler.onButtonUp("up");
		if (touchInRight) MobileInputHandler.onButtonDown("right") else MobileInputHandler.onButtonUp("right");
	}

	private static function checkArrowHitboxes(tx:Float, ty:Float, pressed:Bool):Void
	{
		if (leftHitbox != null && tx >= leftHitbox.x && tx <= leftHitbox.x + leftHitbox.width && ty >= leftHitbox.y && ty <= leftHitbox.y + leftHitbox.height && pressed) touchInLeft = true;
		if (downHitbox != null && tx >= downHitbox.x && tx <= downHitbox.x + downHitbox.width && ty >= downHitbox.y && ty <= downHitbox.y + downHitbox.height && pressed) touchInDown = true;
		if (upHitbox != null && tx >= upHitbox.x && tx <= upHitbox.x + upHitbox.width && ty >= upHitbox.y && ty <= upHitbox.y + upHitbox.height && pressed) touchInUp = true;
		if (rightHitbox != null && tx >= rightHitbox.x && tx <= rightHitbox.x + rightHitbox.width && ty >= rightHitbox.y && ty <= rightHitbox.y + rightHitbox.height && pressed) touchInRight = true;
	}

	private static function checkFullHitboxes(tx:Float, ty:Float, pressed:Bool):Void
	{
		var hw = FlxG.width * 0.5;
		var hh = FlxG.height * 0.5;
		if (leftHitbox != null && tx <= hw && pressed)
		{
			if (ty < hh) touchInUp = true; else touchInLeft = true;
		}
		if (rightHitbox != null && tx > hw && pressed)
		{
			if (ty < hh) touchInRight = true; else touchInDown = true;
		}
	}

	private static function resetTouchStates():Void
	{
		touchInLeft = false; touchInDown = false; touchInUp = false; touchInRight = false;
	}

	public static function setVisible(visible:Bool):Void { if (hitboxGroup != null) hitboxGroup.visible = visible; }

	public static function toggleMode():Void
	{
		if (hitboxMode == "arrows") setMode("full"); else setMode("arrows");
	}

	public static function setMode(mode:String):Void
	{
		hitboxMode = mode;
		if (hitboxGroup != null) hitboxGroup.clear();
		initialized = false;
		init();
	}
}