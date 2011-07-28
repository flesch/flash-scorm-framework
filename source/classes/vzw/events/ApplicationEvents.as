import vzw.application.Application;
import vzw.data.APIWrapper;
class vzw.events.ApplicationEvents {
	
	public static function onEnterFrame():Void {
		var application:Application = Application.getInstance();
		var timeline:MovieClip = application.getTimeline();
		// Broadcast the "onEnterFrame" to the Application.
		application.dispatchEvent({type:"onEnterFrame", target:timeline, data:timeline._currentframe});
	}
	
	public static function onMouseDown():Void {
		var application:Application = Application.getInstance();
		var timeline:MovieClip = application.getTimeline();
		application.dispatchEvent({type:"onMouseDown", target:timeline, data:{x:timeline._xmouse, y:timeline._ymouse}});
	}

	public static function onMouseMove():Void {
		var application:Application = Application.getInstance();
		var timeline:MovieClip = application.getTimeline();		
		application.dispatchEvent({type:"onMouseMove", target:timeline, data:{x:timeline._xmouse, y:timeline._ymouse}});
	}
	
	public static function onMouseUp():Void {
		var application:Application = Application.getInstance();
		var timeline:MovieClip = application.getTimeline();		
		application.dispatchEvent({type:"onMouseUp", target:timeline, data:{x:timeline._xmouse, y:timeline._ymouse}});
	}
	
	public static function onMouseWheel(delta:Number, scrollTarget:Object):Void {
		var application:Application = Application.getInstance();
		var timeline:MovieClip = application.getTimeline();		
		application.dispatchEvent({type:"onMouseWheel", target:timeline, data:{delta:delta, scrollTarget:scrollTarget}});
	}
	
	public static function onKeyDown():Void {
		var application:Application = Application.getInstance();
		var timeline:MovieClip = application.getTimeline();		
		application.dispatchEvent({type:"onKeyDown", target:timeline, data:Key.getCode()});
	}

	public static function onKeyUp():Void {
		var application:Application = Application.getInstance();
		var timeline:MovieClip = application.getTimeline();		
		application.dispatchEvent({type:"onKeyUp", target:timeline, data:Key.getCode()});
	}

	public static function onResize():Void {
		var application:Application = Application.getInstance();
		var timeline:MovieClip = application.getTimeline();		
		application.dispatchEvent({type:"onResize", target:timeline, data:{width:Stage.width, height:Stage.height}});
	}	
	
}