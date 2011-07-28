import vzw.application.Application;
import vzw.utils.OnEnterFrameBeacon;
class vzw.events.SlideEvents {
	
	public static function onLoadStart(target:MovieClip):Void {
		// Get the instance.
		var application:Application = Application.getInstance();
		// Get the Application's timeline.
		var timeline:MovieClip = application.getTimeline();
		// Turn on the loading animation.
		timeline.mcLoadingAnimation._visible = true;
		// Prevent the user from skipping forward.
		timeline.mcNextButton.enabled = false;
		application.dispatchEvent({type:"onStartSlideLoad", target:target});
	}
	
	public static function onLoadProgress(target:MovieClip, loadedBytes:Number, totalBytes:Number):Void {
		var application:Application = Application.getInstance();
		var percent:Number = Math.ceil((loadedBytes/totalBytes)*100);
		application.dispatchEvent({type:"onSlideLoading", target:target, data:{loadedBytes:loadedBytes, totalBytes:totalBytes, percentLoaded:percent}});		
	}

	public static function onLoadComplete(target:MovieClip, httpStatus:Number):Void {
		var application:Application = Application.getInstance();
		application.dispatchEvent({type:"onSlideLoad", target:target});
	}	
	
	public static function onLoadInit(target:MovieClip):Void {
		var application:Application = Application.getInstance();
		// Get the Application's timeline.
		var timeline:MovieClip = application.getTimeline();
		// Turn off the loading animation.
		timeline.mcLoadingAnimation._visible = false;
		// Allow the user to go to the next slide.
		timeline.mcNextButton.enabled = true;
		OnEnterFrameBeacon.addListener(vzw.events.SlideEvents);
		application.dispatchEvent({type:"onSlideStart", target:target});
	}
	
	private static function onLoadError(target:MovieClip, errorCode:String, httpStatus:Number):Void {
		var application:Application = Application.getInstance();
		application.dispatchEvent({type:"onLoadError", target:target, data:{errorCode:errorCode, httpStatus:httpStatus}});
	}
	
	private static function onEnterFrame() {
		var application:Application = Application.getInstance();
		var timeline:MovieClip = application.getTimeline();
		// Broadcast the Slide's "onEnterFrame" to the Application.
		// To-do: Does this affect performance?
		application.dispatchEvent({type:"onSlideEnterFrame", target:timeline.mcContentContainer.content, data:application.getCurrentFrame()});
		// When we reach the end of the Slide, tell the Application.
		if (application.getCurrentFrame() === application.getTotalFrames()) {
			application.dispatchEvent({type:"onSlideEnd", target:timeline.mcContentContainer.content, data:application.getTotalFrames()});
			if (application.getCurrentSlide() === application.getTotalSlides()) {
				application.dispatchEvent({type:"onApplicationEnd", target:timeline, data:timeline._totalframes});
			}			
			OnEnterFrameBeacon.removeListener(vzw.events.SlideEvents);
		}
	}
	
}



