/*
****************************************************************************************************
Extension:		Navigation
Description:	Give the Framework basic navigation functionality.
Version:		2.0
Author:			John Flesch
Modified:		November 26, 2008
****************************************************************************************************
*/
application.extend(function(){

	function addReleaseCallback(buttonInstance:Object, callback:Function):Void {
		if (buttonInstance) {
			if (buttonInstance instanceof vzw.controls.MovieClipButton) {
				buttonInstance.addEventListener("onRelease", callback);
			} else {
				buttonInstance.onRelease = callback;
			}
		}
	}							 
	
	addReleaseCallback(timeline.mcNextButton, function(event:Object):Void {
		if (this.enabled) {
			application.gotoNextSlide();
		}		
	});
	
	addReleaseCallback(timeline.mcBackButton, function(event:Object):Void {
		if (this.enabled) {
			application.gotoPreviousSlide();
		}		
	});
	
	addReleaseCallback(timeline.mcHomeButton, function(event:Object):Void {
		if (this.enabled) {
			application.gotoSlide(1);
		}		
	});

	addReleaseCallback(timeline.mcExitButton, function(event:Object):Void {
		if (this.enabled) {
			vzw.external.ExternalProxy.call("quit");
		}		
	});							
	
	application.addEventListener("onStartSlideLoad", function(event:Object):Void {
		timeline.mcNextButton.enabled = false;
		timeline.mcBackButton.enabled = false;
		timeline.mcHomeButton.enabled = false;
	});								 

	application.addEventListener("onSlideStart", function(event:Object):Void {
		var slide:Number = application.getCurrentSlide();
		timeline.mcBackButton.enabled = slide > 1;
		timeline.mcHomeButton.enabled = slide > 1;
		timeline.mcNextButton.enabled = !application.global.isSlideLocked(slide) && (slide < application.getTotalSlides());
	});
	
	application.addEventListener("onLoadError", function(event:Object):Void {
		timeline.mcNextButton.enabled = false;
		timeline.mcBackButton.enabled = true;
		timeline.mcHomeButton.enabled = true;
	});	
	
	if (application.domain === "localhost" || application.domain.indexOf("pselm-utb")+1) {
		application.addEventListener("onKeyDown", function(event:Object):Void {
			if (Key.isDown(Key.CONTROL) && event.data == 39) {
				application.gotoNextSlide();
			}
			if (Key.isDown(Key.CONTROL) && event.data == 37) {
				application.gotoPreviousSlide();
			}
		});
	}
							 
});