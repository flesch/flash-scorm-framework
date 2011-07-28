/*
****************************************************************************************************
Extension:		Bookmark
Description:	Save the current page to the LMS, and return to the existing bookmark.
Version:		2.2
Author:			John Flesch
Modified:		May 11, 2009
****************************************************************************************************
*/
application.extend(function(){

	// Slides that SHOULDN'T boomark.
	var DO_NOT_BOOKMARK:Array = [];
	//var DO_NOT_BOOKMARK:Array = [10, 20, 30];							 
							 
	application.addEventListener("onStartSlideLoad", function(event:Object):Void {
		var fvLessonLocation:String = application.getFlashVar("fvLessonLocation");
		if (fvLessonLocation && Number(fvLessonLocation) > 1 && (application.getCurrentSlide() == 1)) {
			application.gotoSlide(Number(fvLessonLocation));
		}
		application.removeEventListener("onStartSlideLoad", arguments.callee);   
	});
	
	application.addEventListener("onSlideStart", function(event:Object):Void {
		if (!vzw.utils.ArrayUtils.arrayIncludes(DO_NOT_BOOKMARK, application.getCurrentSlide())) {
			vzw.data.APIWrapper.LMSSetValue("cmi.core.lesson_location", String(application.getCurrentSlide()));
		}
	});

});