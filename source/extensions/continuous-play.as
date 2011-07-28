/*
****************************************************************************************************
Extension:		Continuous Play
Description:	Jump to the next slide when the last frame is reached.
Version:		1.1
Author:			John Flesch
Modified:		October 09, 2008
Usage:			This assumes there is not a stop() action before the end
				of the slide timeline.
****************************************************************************************************
*/
application.extend(function(){

	var ENABLED:Boolean = false;
	var SECONDS_BETWEEN_SLIDES:Number = 5;	
	
	if (ENABLED) {
		application.addEventListener("onSlideEnd", function(event:Object):Void {
			setTimeout(application.gotoNextSlide, SECONDS_BETWEEN_SLIDES*1000);
		});
	}

});