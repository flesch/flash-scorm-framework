/*
****************************************************************************************************
Extension:		Fade In
Description:	Fade in each Slide
Version:		2.0
Author:			John Flesch
Modified:		October 20, 2009
****************************************************************************************************
*/
application.extend(function(){

	var FADE_FIRST_SLIDE:Boolean = true;
	var SLIDES_TO_IGNORE:Array = [];
							 
	if (!application.data.lofi) {
		
		application.addEventListener("onSlideLoad", function(event:Object):Void {
			if (!vzw.utils.ArrayUtils.arrayIncludes(SLIDES_TO_IGNORE, application.getCurrentSlide())) {
				if (FADE_FIRST_SLIDE || application.getCurrentSlide() != 1) {
					event.target._alpha = 0;
				}
			}
		});
		
		application.addEventListener("onSlideStart", function(event:Object):Void {
			if (!vzw.utils.ArrayUtils.arrayIncludes(SLIDES_TO_IGNORE, application.getCurrentSlide())) {																		   
				if (FADE_FIRST_SLIDE || application.getCurrentSlide() != 1) {
					var fadeInterval:Number = setInterval(function(){
						if (event.target._alpha < 100) {
							event.target._alpha += 10;
						} else {
							event.target._alpha = 100;
							clearInterval(fadeInterval);
						}
					}, 10);
				}
			}
		});	
	}
	
});