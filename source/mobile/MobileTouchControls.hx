package mobile;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.ui.FlxButton;
import flixel.text.FlxText;

class MobileTouchControls
{
	public static var dpadButtons:FlxTypedGroup<FlxButton>;
	public static var extraButtons:FlxTypedGroup<FlxButton>;

	public static var leftPressed(get, never):Bool;
	public static var downPressed(get, never):Bool;
	public static var upPressed(get, never):Bool;
	public static var rightPressed(get, never):Bool;
	public static var pausePressed(get, never):Bool;
	public static var backPressed(get, never):Bool;

	public static var buttonLeft:FlxButton;
	public static var buttonDown:FlxButton;
	public static var buttonUp:FlxButton;
	public static var buttonRight:FlxButton;
	public static var buttonPause:FlxButton;
	public static var buttonBack:FlxButton;

	public static var leftPos:FlxPoint = new FlxPoint(100, 520);
	public static var downPos:FlxPoint = new FlxPoint(220, 600);
	public static var upPos:FlxPoint = new FlxPoint(220, 440);
	public static var rightPos:FlxPoint = new FlxPoint(340, 520);

	public static var buttonAlpha:Float = 0.35;
	public static var buttonSize:Int = 120;

	private static var initialized:Bool = false;

	static function get_leftPressed():Bool return buttonLeft != null && buttonLeft.pressed;
	static function get_downPressed():Bool return buttonDown != null && buttonDown.pressed;
	static function get_upPressed():Bool return buttonUp != null && buttonUp.pressed;
	static function get_rightPressed():Bool return buttonRight != null && buttonRight.pressed;
	static function get_pausePressed():Bool return buttonPause != null && buttonPause.pressed;
	static function get_backPressed():Bool return buttonBack != null && buttonBack.pressed;

	public static function init():Void
	{
		if (initialized) return;
		initialized = true;
		dpadButtons = new FlxTypedGroup<FlxButton>();
		extraButtons = new FlxTypedGroup<FlxButton>();
		createDPadButtons();
		createExtraButtons();
		loadCustomPositions();
		applyAlpha();
	}

	private static function createDPadButtons():Void
	{
		buttonLeft = createButton(leftPos.x, leftPos.y, "◀", 0xFF00BFFF);
		buttonLeft.onDown.callback = function() { MobileInputHandler.onButtonDown("left"); };
		buttonLeft.onUp.callback = function() { MobileInputHandler.onButtonUp("left"); };
		buttonDown = createButton(downPos.x, downPos.y, "▼", 0xFFFF00FF);
		buttonDown.onDown.callback = function() { MobileInputHandler.onButtonDown("down"); };
		buttonDown.onUp.callback = function() { MobileInputHandler.onButtonUp("down"); };
		buttonUp = createButton(upPos.x, upPos.y, "▲", 0xFFFF0000);
		buttonUp.onDown.callback = function() { MobileInputHandler.onButtonDown("up"); };
		buttonUp.onUp.callback = function() { MobileInputHandler.onButtonUp("up"); };
		buttonRight = createButton(rightPos.x, rightPos.y, "▶", 0xFF00FF00);
		buttonRight.onDown.callback = function() { MobileInputHandler.onButtonDown("right"); };
		buttonRight.onUp.callback = function() { MobileInputHandler.onButtonUp("right"); };
		dpadButtons.add(buttonLeft);
		dpadButtons.add(buttonDown);
		dpadButtons.add(buttonUp);
		dpadButtons.add(buttonRight);
	}

	private static function createExtraButtons():Void
	{
		buttonPause = createButton(FlxG.width - 80, 20, "⏸", 0xFFFFFFFF, 60);
		buttonPause.onDown.callback = function() { MobileInputHandler.onButtonDown("pause"); };
		buttonPause.onUp.callback = function() { MobileInputHandler.onButtonUp("pause"); };
		buttonBack = createButton(20, 20, "←", 0xFFFFFFFF, 60);
		buttonBack.onDown.callback = function() { MobileInputHandler.onButtonDown("back"); };
		buttonBack.onUp.callback = function() { MobileInputHandler.onButtonUp("back"); };
		extraButtons.add(buttonPause);
		extraButtons.add(buttonBack);
	}

	private static function createButton(x:Float, y:Float, label:String, color:Int, ?size:Int):FlxButton
	{
		if (size == 0) size = buttonSize;
		var btn = new FlxButton(x, y, "");
		var graphic = new FlxSprite().makeGraphic(size, size, color);
		btn.loadGraphic(graphic.graphic);
		btn.alpha = buttonAlpha;
		var txt = new FlxText(0, 0, size, label);
		txt.setFormat(null, Std.int(size * 0.4), FlxColor.WHITE, CENTER, CENTER);
		txt.alpha = 0.8;
		btn.label = txt;
		btn.labelOff = txt;
		btn.labelAlphas = [0.5, 0.5];
		return btn;
	}

	public static function loadCustomPositions():Void
	{
		try {
			var saved = flixel.util.FlxSave.load("touchPositions", "psychEngineMobile");
			if (saved.data.leftX != null)
			{
				leftPos.set(saved.data.leftX, saved.data.leftY);
				downPos.set(saved.data.downX, saved.data.downY);
				upPos.set(saved.data.upX, saved.data.upY);
				rightPos.set(saved.data.rightX, saved.data.rightY);
				buttonAlpha = saved.data.alpha != null ? saved.data.alpha : 0.35;
				buttonSize = saved.data.size != null ? saved.data.size : 120;
			}
		} catch (e:Dynamic) {}
	}

	public static function saveCustomPositions():Void
	{
		var save = flixel.util.FlxSave.bind("touchPositions", "psychEngineMobile");
		save.data.leftX = leftPos.x;
		save.data.leftY = leftPos.y;
		save.data.downX = downPos.x;
		save.data.downY = downPos.y;
		save.data.upX = upPos.x;
		save.data.upY = upPos.y;
		save.data.rightX = rightPos.x;
		save.data.rightY = rightPos.y;
		save.data.alpha = buttonAlpha;
		save.data.size = buttonSize;
		save.flush();
	}

	public static function updatePositions():Void
	{
		if (buttonLeft != null) { buttonLeft.x = leftPos.x - buttonSize / 2; buttonLeft.y = leftPos.y - buttonSize / 2; }
		if (buttonDown != null) { buttonDown.x = downPos.x - buttonSize / 2; buttonDown.y = downPos.y - buttonSize / 2; }
		if (buttonUp != null) { buttonUp.x = upPos.x - buttonSize / 2; buttonUp.y = upPos.y - buttonSize / 2; }
		if (buttonRight != null) { buttonRight.x = rightPos.x - buttonSize / 2; buttonRight.y = rightPos.y - buttonSize / 2; }
	}

	public static function applyAlpha():Void
	{
		if (buttonLeft != null) buttonLeft.alpha = buttonAlpha;
		if (buttonDown != null) buttonDown.alpha = buttonAlpha;
		if (buttonUp != null) buttonUp.alpha = buttonAlpha;
		if (buttonRight != null) buttonRight.alpha = buttonAlpha;
	}

	public static function setVisible(visible:Bool):Void
	{
		if (dpadButtons != null) dpadButtons.visible = visible;
		if (extraButtons != null) extraButtons.visible = visible;
	}

	public static function anyDirectionPressed():Bool
	{
		return leftPressed || downPressed || upPressed || rightPressed;
	}

	public static function getPressStates():MobileInputState
	{
		return { left: leftPressed, down: downPressed, up: upPressed, right: rightPressed, pause: pausePressed, back: backPressed };
	}
}

typedef MobileInputState = {
	var left:Bool;
	var down:Bool;
	var up:Bool;
	var right:Bool;
	var pause:Bool;
	var back:Bool;
}