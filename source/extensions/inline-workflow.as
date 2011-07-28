/*
****************************************************************************************************
Extension:		Inline Workflow
Description:	Allows a developer to create all slides in one MovieClip.
Version:		1.2
Author:			John Flesch
Modified:		May 27, 2009
****************************************************************************************************
*/

application.extend(function(){ 
	if (timeline._totalframes === 1 && timeline.mcContentContainer.content._totalframes) {
		
		application.override("getCurrentSlide", function():Number {
			return timeline.mcContentContainer.content._currentframe;
		});
	
		application.override("getTotalSlides", function():Number {
			return timeline.mcContentContainer.content._totalframes;
		});
	
		application.override("gotoSlide", function(slideNumber:Object):Void {
			var application:Application = Application.getInstance();
			var timeline:MovieClip = application.getTimeline();
			if (typeof slideNumber == "string") {
				timeline.mcContentContainer.content.gotoAndStop(slideNumber);
			} else {
				if (slideNumber > 0 && slideNumber <= application.getTotalSlides()) {
					timeline.mcContentContainer.content.gotoAndStop(slideNumber);
				}
			}	
			vzw.events.SlideEvents.onLoadComplete(timeline.mcContentContainer.content);
			vzw.events.SlideEvents.onLoadInit(timeline.mcContentContainer.content);
		});
		
		application.addEventListener("ready", function(event:Object):Void {
			application.gotoSlide(1);
		});
	
		timeline.mcContentContainer.content.stop();
	}
});