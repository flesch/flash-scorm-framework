/*
****************************************************************************************************
Extension:		LMS Connection Error
Description:	When the API wrapper detects a loss of connection, alert the learner.
Version:		2.1
Author:			John Flesch
Modified:		May 27, 2009
****************************************************************************************************
*/
application.extend(function(){

	var baseURI:String = timeline._url.split("shell.swf")[0];

	var mcConnectionErrorContainer:MovieClip = timeline.createEmptyMovieClip("mcConnectionErrorContainer", timeline.getNextHighestDepth());
	mcConnectionErrorContainer.loadMovie(baseURI+"assets/swf/lms-connection-error.swf");
	
	function onLMSConnectionError():Void {
		if (timeline.mcConnectionErrorContainer.showError && timeline.mcConnectionErrorContainer._y !== 0) {
			timeline.mcLoadingAnimation._visible = false;
			timeline.mcConnectionErrorContainer._y = 0;
			timeline.mcConnectionErrorContainer.swapDepths(timeline.getNextHighestDepth()+1);
			timeline.mcConnectionErrorContainer.showError();
		}
	}
	
	timeline.mcConnectionErrorContainer._y = -Stage.height;
	vzw.external.ExternalProxy.addCallback("onLMSConnectionError", onLMSConnectionError);

	// If the page doesn't load, kick the user out (but give the page 1 second to load).
	//application.addEventListener("onLoadError", onLMSConnectionError);
	application.addEventListener("onLoadError", function(event:Object):Void {
		setTimeout(function(){
			onLMSConnectionError();
		}, 1000);
	});

});