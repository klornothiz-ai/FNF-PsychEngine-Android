package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import states.TitleState;
import mobile.MobileTouchControls;
import mobile.MobileInputHandler;
import mobile.Hitbox;
import mobile.AndroidStorage;
import haxe.Exception;

class Main extends Sprite
{
	public static var gameWidth:Int = 1280;
	public static var gameHeight:Int = 720;
	public static var fpsVar:FPS;
	public static var initialState:Class<FlxState> = TitleState;

	public static var isMobile:Bool = false;
	public static var touchControls:MobileTouchControls;
	public static var inputHandler:MobileInputHandler;
	public static var hitboxSystem:Hitbox;

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();
		if (stage != null) init();
		else addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, init);
		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		#if (android || ios)
		isMobile = true;
		#end

		if (isMobile) initMobileSystems();

		if (stageWidth == 0 || stageHeight == 0)
		{
			stageWidth = gameWidth;
			stageHeight = gameHeight;
		}

		var ratioX:Float = stageWidth / gameWidth;
		var ratioY:Float = stageHeight / gameHeight;
		var ratio:Float = Math.min(ratioX, ratioY);
		var gameWidthActual:Int = Math.ceil(gameWidth * ratio);
		var gameHeightActual:Int = Math.ceil(gameHeight * ratio);

		#if mobile
		gameWidthActual = stageWidth;
		gameHeightActual = stageHeight;
		#end

		addChild(new FlxGame(gameWidthActual, gameHeightActual, initialState, 60, 60, true, false));

		#if !mobile
		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = "noScale";
		#end

		#if html5
		FlxG.autoPause = false;
		#end

		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end

		#if DISCORD_ALLOWED
		DiscordClient.initialize();
		#end
	}

	private function initMobileSystems():Void
	{
		trace('[Main] Initializing Mobile Systems...');
		AndroidStorage.init();
		MobileInputHandler.init();
		Hitbox.init();
		trace('[Main] Mobile systems ready');
	}

	#if CRASH_HANDLER
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var callStack:Array<StackItem> = ExceptionStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();
		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");
		var path = "crash/" + "PsychEngine_" + dateNow + ".txt";
		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Std.string(stackItem);
			}
		}
		errMsg += "\nUncaught Error: " + e.error;
		if (!sys.FileSystem.exists("crash/"))
			sys.FileSystem.createDirectory("crash/");
		sys.io.File.saveContent(path, errMsg + "\n");
		Sys.println(errMsg);
		#if android
		mobile.extension.AndroidExtension.showToast("Game crashed! Report saved.", 1);
		#end
		Lib.application.window.alert(errMsg, "Error! The game crashed...");
	}
	#end
}