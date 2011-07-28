class vzw.external.ExternalProxy {

	// NOTE: VZW Flash SCORM Framework v2.6.0 dropped support for Flash 7 and lower.
	// Therefore, "fscommand" has been removed from this file, which now serves as
	// legacy code.

	// Is ExternalInterface really available?
	public static var available:Boolean = flash.external.ExternalInterface.available && flash.external.ExternalInterface.call("(function(){return true;})");
	
	// Call a function, with an optional callback.
	public static function call(methodName:String, args:Array, callback:Function):Void {
		if (available) {
			callback(flash.external.ExternalInterface.call.apply(null, [methodName].concat(args)));
		}
	}
	
	public static function addCallback(methodName:String, callback:Function):Void {
		if (available) {
			flash.external.ExternalInterface.addCallback(methodName, null, callback);
		}
	}
	
}