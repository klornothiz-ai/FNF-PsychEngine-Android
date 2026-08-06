package mobile;

#if android
import lime.system.JNI;
#end

class AndroidStorage
{
	public static var BASE_PATH(default, null):String;
	public static var MODS_PATH(default, null):String;
	public static var SAVE_PATH(default, null):String;
	public static var ASSETS_PATH(default, null):String;
	private static var initialized:Bool = false;

	public static function init():Void
	{
		if (initialized) return;
		initialized = true;
		#if android
		try { BASE_PATH = getExternalStoragePath() + "/.PsychEngine/"; } catch (e:Dynamic) { BASE_PATH = "/storage/emulated/0/.PsychEngine/"; }
		#else
		BASE_PATH = "./.PsychEngine/";
		#end
		MODS_PATH = BASE_PATH + "mods/";
		SAVE_PATH = BASE_PATH + "saves/";
		ASSETS_PATH = BASE_PATH + "assets/";
		createDirectories();
	}

	#if android
	private static function getExternalStoragePath():String
	{
		try {
			var getExt = JNI.createStaticMethod("android/os/Environment", "getExternalStorageDirectory", "()Ljava/io/File;");
			var file = getExt();
			var getPath = JNI.createMemberMethod("java/io/File", "getAbsolutePath", "()Ljava/lang/String;");
			return getPath(file);
		} catch (e:Dynamic) { return "/storage/emulated/0"; }
	}
	#end

	public static function createDirectories():Void
	{
		createDir(BASE_PATH);
		createDir(MODS_PATH);
		createDir(SAVE_PATH);
		createDir(ASSETS_PATH);
	}

	private static function createDir(path:String):Void
	{
		#if sys
		if (!sys.FileSystem.exists(path))
		{
			try { sys.FileSystem.createDirectory(path); }
			catch (e:Dynamic) {}
		}
		#end
	}

	public static function fileExists(path:String):Bool { #if sys return sys.FileSystem.exists(path); #else return false; #end }

	public static function readFile(path:String):String
	{
		#if sys
		try { return sys.io.File.getContent(path); } catch (e:Dynamic) { return null; }
		#else return null;
		#end
	}

	public static function writeFile(path:String, content:String):Bool
	{
		#if sys
		try { sys.io.File.saveContent(path, content); return true; } catch (e:Dynamic) { return false; }
		#else return false;
		#end
	}

	#if android
	public static function checkPermissions():Bool
	{
		try {
			var state = JNI.createStaticMethod("android/os/Environment", "getExternalStorageState", "()Ljava/lang/String;")();
			return state == "mounted";
		} catch (e:Dynamic) { return false; }
	}
	#else
	public static function checkPermissions():Bool { return true; }
	#end

	public static function getStorageInfo():StorageInfo
	{
		return { basePath: BASE_PATH, modPath: MODS_PATH, savePath: SAVE_PATH, assetsPath: ASSETS_PATH, hasPermissions: checkPermissions() };
	}
}

typedef StorageInfo = {
	var basePath:String;
	var modPath:String;
	var savePath:String;
	var assetsPath:String;
	var hasPermissions:Bool;
}