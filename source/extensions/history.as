/*
****************************************************************************************************
Extension:		History
Description:	Track Session and Slide history.
Version:		1.1
Author:			John Flesch
Modified:		November 05, 2008
****************************************************************************************************
*/
application.extend(function(){

	// Let's track each session. This data is stored in a one-dimensional array.
	if (!application.data.sessions) {
		application.data.sessions = [];
	}
	
	// Define the "history" array if it doesn't already exists.
	if (!application.data.history) {
		application.data.history = [];
	}

	timeline.txtSlideProgress.text = "";
	application.data.sessions.push(application.session);

	application.addEventListener("onSlideStart", function(event:Object):Void {
		// Set the page number.
		timeline.txtSlideProgress.text = application.getCurrentSlide() + " of " + application.getTotalSlides();		
		// Add this slide to the tracking data.
		application.data.history.push(application.getCurrentSlide()+"@"+(Number(new Date())-application.session)+"x"+(application.data.sessions.length-1));
		application.global.serialize(application.data);
	});	
	
	// Mark the learner complete when the last slide is reached.
	application.addEventListener("onApplicationEnd", function():Void {
		vzw.data.APIWrapper.LMSSetValue("cmi.core.lesson_status", "completed");
	});

});