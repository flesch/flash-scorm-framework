/*******************************************************************************
* shell.as
*******************************************************************************/

// The following variables are available for your convience.
var application:Application = Application.getInstance();
var timeline:MovieClip = application.getTimeline();
var content:MovieClip = timeline.mcContentContainer.content;

// Include the default extensions. You probably won't need to edit this file,
// unless there is a specific extension you need to disable.
#include "source/extensions/default.as"

/******************************************************************************/
// Enter your custom code here. Use the "timeline" variable to access _root.





/******************************************************************************/

/*******************************************************************************
// Use this template for "adhoc" customizations.
application.extend(function(){
	application.addEventListener("onSlideStart", function(event:Object):Void {
	});
});
*******************************************************************************/

/*******************************************************************************

// The "ready" event runs as soon as everything is loaded.
application.extend(function(){
	application.addEventListener("ready", function(event:Object):Void {
	});
});

// The "after" event runs after everything has executed. This is useful if you
// need to overwrite anything.
application.extend(function(){
	application.addEventListener("after", function(event:Object):Void {
	});
});
*******************************************************************************/