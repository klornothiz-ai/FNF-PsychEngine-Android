package mobile.extension;

#if android
import lime.system.JNI;
#end

class AndroidExtension
{
	#if android
	public static function showKeyboard():Void { try { JNI.createStaticMethod("org/libsdl/app/SDLActivity", "showTextInput", "()V")(); } catch (e:Dynamic) {} }
	public static function hideKeyboard():Void { try { JNI.createStaticMethod("org/libsdl/app/SDLActivity", "hideTextInput", "()V")(); } catch (e:Dynamic) {} }
	public static function isKeyboardVisible():Bool { try { return JNI.createStaticMethod("org/libsdl/app/SDLActivity", "isTextInputVisible", "()Z")(); } catch (e:Dynamic) { return false; } }
	public static function vibrate(durationMs:Int = 50):Void { try { JNI.createStaticMethod("org/libsdl/app/SDLActivity", "vibrate", "(I)V")(durationMs); } catch (e:Dynamic) {} }
	public static function getScreenWidth():Int { try { return JNI.createStaticMethod("org/libsdl/app/SDLActivity", "getDisplayWidth", "()I")(); } catch (e:Dynamic) { return 1280; } }
	public static function getScreenHeight():Int { try { return JNI.createStaticMethod("org/libsdl/app/SDLActivity", "getDisplayHeight", "()I")(); } catch (e:Dynamic) { return 720; } }
	public static function getAndroidVersion():String { try { return JNI.createStaticField("android/os/Build$VERSION", "RELEASE").get(); } catch (e:Dynamic) { return "Unknown"; } }
	public static function getDeviceModel():String { try { return JNI.createStaticField("android/os/Build", "MODEL").get(); } catch (e:Dynamic) { return "Unknown"; } }
	public static function showToast(message:String, duration:Int = 0):Void { try { JNI.createStaticMethod("org/libsdl/app/SDLActivity", "showToast", "(Ljava/lang/String;I)V")(message, duration); } catch (e:Dynamic) {} }
	public static function openURL(url:String):Void { try { JNI.createStaticMethod("org/libsdl/app/SDLActivity", "openURL", "(Ljava/lang/String;)V")(url); } catch (e:Dynamic) {} }
	#else
	public static function showKeyboard():Void {}
	public static function hideKeyboard():Void {}
	public static function isKeyboardVisible():Bool { return false; }
	public static function vibrate(durationMs:Int = 50):Void {}
	public static function getScreenWidth():Int { return 1280; }
	public static function getScreenHeight():Int { return 720; }
	public static function getAndroidVersion():String { return "N/A"; }
	public static function getDeviceModel():String { return "N/A"; }
	public static function showToast(message:String, duration:Int = 0):Void {}
	public static function openURL(url:String):Void {}
	#end
}