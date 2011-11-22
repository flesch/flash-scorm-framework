/*
****************************************************************************************************
Extension:		Thin Client
Description:	Detect if the user is viewing the application on a thin-client.
Version:			1.5
Author:				John Flesch
Modified:			November 22, 2011
****************************************************************************************************
*/
application.extend(function(){

	// If the first slide contains a long animation, skip it
	// when the user is on a thin client.
	var SKIP_FIRST_SLIDE:Boolean = true;
	
	// Simulate a thin client (used for debugging).
	var FORCE_LOFI:Boolean = false;

	// If the user is on a thin-client or using a screen-reader,
	// let's give them the lofi version.
	application.data.lofi = FORCE_LOFI;
	if (!FORCE_LOFI && vzw.external.ExternalProxy.available) {
		vzw.external.ExternalProxy.call("lofi", [], vzw.utils.Delegate.create(application, function(lofi:Boolean):Void {
			application.data.lofi = lofi;
		}));
	}
	application.global.lofi = application.data.lofi;
	
	if (SKIP_FIRST_SLIDE && application.data.lofi) {
		application.addEventListener("onStartSlideLoad", function(event:Object):Void {
			if (application.getCurrentSlide() === 1) {
				application.gotoNextSlide();
			}
		});
	}
	
});