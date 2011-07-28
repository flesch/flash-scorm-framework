import vzw.application.Application;
import vzw.events.SlideEvents;
class vzw.controls.Slides {

	private var _movieClipLoader:MovieClipLoader;
	public var currentSlide:String;
	
	public function Slides() {
		this._movieClipLoader = new MovieClipLoader();
		this._movieClipLoader.addListener(SlideEvents);
	}
		
	private function loadSlide(resource:String):Void {
		var application:Application = Application.getInstance();
		var timeline:MovieClip = application.getTimeline();		
		var baseURI:String = timeline._url.split("shell.swf")[0];
		var container:MovieClip = timeline.mcContentContainer.createEmptyMovieClip("content", 0);
		container._lockroot = true;
		var currentSlideURI:String = (timeline._url.indexOf("file:///") == -1) ? (resource + ((resource.indexOf("?") == -1) ? "?" : "&") + "session=" + application.session) : resource;
		this.currentSlide = currentSlideURI;
		this._movieClipLoader.loadClip(baseURI+"content/"+currentSlideURI, container);
	}
	
	private function attachSlide(resource:String):Void {
		var application:Application = Application.getInstance();
		var timeline:MovieClip = application.getTimeline();
		this.currentSlide = resource;
		timeline.mcContentContainer.attachMovie(resource, "content", 0);
		timeline.mcContentContainer.content._lockroot = true;
		this.triggerEvents(timeline.mcContentContainer.content);
	}
	
	public function getSlide(resource:String):Void {
		if (resource.lastIndexOf(".") != -1) {
			this.loadSlide(resource);
		} else {
			this.attachSlide(resource);
		}
	}
	
	// "triggerEvents" is a way to fake the events the MovieClipLoader will call.
	// This is only called when a Slide is attached from the library.
	private function triggerEvents(container:MovieClip):Void {
		var application:Application = Application.getInstance();
		SlideEvents.onLoadStart(container);
		application.addEventListener("onEnterFrame", triggerCallbacks);
		function triggerCallbacks(eventObject:Object):Void {
			var slideContent:MovieClip = eventObject.target.mcContentContainer.content;
			if ((slideContent.getBytesLoaded() == slideContent.getBytesTotal()) && (slideContent.getBytesTotal() > 0)) {
				SlideEvents.onLoadComplete(container);
				SlideEvents.onLoadInit(container);
				application.removeEventListener("onEnterFrame", triggerCallbacks);
			} else {
				SlideEvents.onLoadProgress(container, slideContent.getBytesLoaded(), slideContent.getBytesTotal());
				//trace("legacy: "+slideContent.getBytesLoaded()+"/"+slideContent.getBytesTotal());
			}			
		}
	}
	
	public function getCurrentSlide():Number {
		var application:Application = Application.getInstance();
		var timeline:MovieClip = application.getTimeline();
		return timeline._currentframe;
	}

	public function getTotalSlides():Number {
		var application:Application = Application.getInstance();
		var timeline:MovieClip = application.getTimeline();
		return timeline._totalframes;
	}
	
	public function getCurrentFrame():Number {
		var application:Application = Application.getInstance();
		var timeline:MovieClip = application.getTimeline();
		return timeline.mcContentContainer.content._currentframe;
	}
	
	public function getTotalFrames():Number {
		var application:Application = Application.getInstance();
		var timeline:MovieClip = application.getTimeline();
		return timeline.mcContentContainer.content._totalframes;
	}	

	public function gotoSlide(slideNumber:Object):Void {
		var application:Application = Application.getInstance();
		var timeline:MovieClip = application.getTimeline();
		if (typeof slideNumber == "string") {
			timeline.gotoAndStop(slideNumber);
		} else {
			if (slideNumber > 0 && slideNumber <= application.getTotalSlides()) {
				timeline.gotoAndStop(slideNumber);
			}
		}
	}
	
	public function gotoNextSlide():Void {
		var application:Application = Application.getInstance();
		application.gotoSlide(application.getCurrentSlide()+1);
	}

	public function gotoPreviousSlide():Void {
		var application:Application = Application.getInstance();
		application.gotoSlide(application.getCurrentSlide()-1);
	}		
	
}