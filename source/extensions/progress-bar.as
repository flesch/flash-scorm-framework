/*
****************************************************************************************************
Extension:		Progress Bar
Description:	Display a true progress bar.
Version:		1.1
Author:			John Flesch
Modified:		July 22, 2010
Usage:			"mcProgressBar" should be exactly 100 frames long.
****************************************************************************************************
*/
application.extend(function(){
	if (timeline.mcProgressBar) {
		application.addEventListener("onSlideStart", function(event:Object):Void {
			// We'll wrap this whole thing in a "setTimeout" function, so that it gets executed
			// after all the other "onSlideStart" listeners have fired.
			setTimeout(function(){
				
				// "history" is just a shortcut to "application.data.history".
				var history:Array = application.data.history, viewed:Array = [];
				var len:Number = history.length, slide:Number, i:Number = 0;
				for (; i<len; i++) {
					// The data format for each slide is this: 2@2133+0 (SLIDE@TIME+SESSION)
					// We just want the slide number, so split it and get rid of everything else.
					slide = Number(history[i].split("@").shift());
					// Ensure there are no duplicates.
					if (!vzw.utils.ArrayUtils.arrayIncludes(viewed, slide)) {
						viewed.push(slide);
					}
				}
				
				// Now we have an array of all the "viewed" slides, to calculate "percent viewed" we can
				// do something like this:
				var percentViewed:Number = Math.floor((viewed.length/application.getTotalSlides())*100);
				
				// Update the Progress Bar		
				timeline.mcProgressBar.gotoAndStop(percentViewed);
			
			}, 0);
		});
	}
});