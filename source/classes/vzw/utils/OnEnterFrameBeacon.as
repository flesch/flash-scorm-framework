/*
var o:Object = new Object();
o.onEnterFrame = function() {
 	trace('onEnterFrame outside of a MovieClip');
}
import vzw.utils.OnEnterFrameBeacon;
OnEnterFrameBeacon.init();
OnEnterFrameBeacon.addListener(o);
*/
import mx.transitions.BroadcasterMX;
class vzw.utils.OnEnterFrameBeacon {
	public static function init():Void {
		if (!_root.__OnEnterFrameBeacon) {
			//trace('OnEnterFrameBeacon.init();');
			BroadcasterMX.initialize(_global.MovieClip);
			var frameMovieClip:MovieClip = _root.createEmptyMovieClip('__OnEnterFrameBeacon', 8872);
			frameMovieClip.onEnterFrame = function():Void  {
				_global.MovieClip.broadcastMessage('onEnterFrame');
			};
		}
	}
	public static function addListener(obj:Object):Void {
		MovieClip.addListener(obj);
	}
	public static function removeListener(obj:Object):Void {
		MovieClip.removeListener(obj);
	}
}
