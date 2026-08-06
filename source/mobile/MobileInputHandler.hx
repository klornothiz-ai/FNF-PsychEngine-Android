package mobile;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class MobileInputHandler
{
	public static var pressedKeys:Map<String, Bool> = new Map();
	public static var LEFT_BINDS:Array<FlxKey> = [FlxKey.LEFT, FlxKey.A];
	public static var DOWN_BINDS:Array<FlxKey> = [FlxKey.DOWN, FlxKey.S];
	public static var UP_BINDS:Array<FlxKey> = [FlxKey.UP, FlxKey.W];
	public static var RIGHT_BINDS:Array<FlxKey> = [FlxKey.RIGHT, FlxKey.D];
	public static var ENTER_BINDS:Array<FlxKey> = [FlxKey.ENTER, FlxKey.SPACE];
	public static var ESCAPE_BINDS:Array<FlxKey> = [FlxKey.ESCAPE, FlxKey.BACKSPACE];
	public static var multitouchEnabled:Bool = true;
	public static var activeTouches:Int = 0;
	private static var longPressTimers:Map<String, Float> = new Map();
	private static var LONG_PRESS_THRESHOLD:Float = 0.5;

	public static function init():Void { FlxG.touches.preventDefault = false; }

	public static function onButtonDown(button:String):Void
	{
		pressedKeys.set(button, true);
		activeTouches++;
		longPressTimers.set(button, 0);
		switch (button)
		{
			case "left": for (key in LEFT_BINDS) FlxG.keys.pressKey(key);
			case "down": for (key in DOWN_BINDS) FlxG.keys.pressKey(key);
			case "up": for (key in UP_BINDS) FlxG.keys.pressKey(key);
			case "right": for (key in RIGHT_BINDS) FlxG.keys.pressKey(key);
			case "pause": for (key in ENTER_BINDS) FlxG.keys.pressKey(key);
			case "back": for (key in ESCAPE_BINDS) FlxG.keys.pressKey(key);
		}
	}

	public static function onButtonUp(button:String):Void
	{
		pressedKeys.set(button, false);
		if (activeTouches > 0) activeTouches--;
		longPressTimers.remove(button);
		switch (button)
		{
			case "left": for (key in LEFT_BINDS) FlxG.keys.releaseKey(key);
			case "down": for (key in DOWN_BINDS) FlxG.keys.releaseKey(key);
			case "up": for (key in UP_BINDS) FlxG.keys.releaseKey(key);
			case "right": for (key in RIGHT_BINDS) FlxG.keys.releaseKey(key);
			case "pause": for (key in ENTER_BINDS) FlxG.keys.releaseKey(key);
			case "back": for (key in ESCAPE_BINDS) FlxG.keys.releaseKey(key);
		}
	}

	public static function update(elapsed:Float):Void
	{
		for (button in longPressTimers.keys())
			longPressTimers.set(button, longPressTimers.get(button) + elapsed);
	}

	public static function isLongPress(button:String):Bool
	{
		return longPressTimers.exists(button) && longPressTimers.get(button) >= LONG_PRESS_THRESHOLD;
	}

	public static function anyDirectionDown():Bool
	{
		return pressedKeys.exists("left") && pressedKeys.get("left") == true
			|| pressedKeys.exists("down") && pressedKeys.get("down") == true
			|| pressedKeys.exists("up") && pressedKeys.get("up") == true
			|| pressedKeys.exists("right") && pressedKeys.get("right") == true;
	}

	public static function getDirection():String
	{
		if (pressedKeys.exists("left") && pressedKeys.get("left") == true) return "left";
		if (pressedKeys.exists("down") && pressedKeys.get("down") == true) return "down";
		if (pressedKeys.exists("up") && pressedKeys.get("up") == true) return "up";
		if (pressedKeys.exists("right") && pressedKeys.get("right") == true) return "right";
		return null;
	}

	public static function clearAll():Void
	{
		for (button in pressedKeys.keys()) onButtonUp(button);
		pressedKeys = new Map();
		activeTouches = 0;
		longPressTimers = new Map();
	}

	public static function isMultitouch():Bool
	{
		#if android return true; #else return multitouchEnabled; #end
	}
}