/*
****************************************************************************************************
Extension:		Thin Client
Description:	
Version:		1.4
Author:			John Flesch
Modified:		January 12, 2011
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
	application.global.lofi = FORCE_LOFI;
	if (!FORCE_LOFI && vzw.external.ExternalProxy.available) {
		vzw.external.ExternalProxy.call("function(){ return /5.2/.test((/Windows NT 5.[0-9];/.exec(window.navigator.userAgent)||[]).pop()); }", [], vzw.utils.Delegate.create(application, function(lofi:Boolean):Void {
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
	
	// Allow a developer to use the "lofi" variable outside of the Application.
	vzw.external.ExternalProxy.addCallback("lofi", function():Boolean {
		return Boolean(application.data.lofi);
	});
	
});