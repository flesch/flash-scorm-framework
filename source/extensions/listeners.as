/*
****************************************************************************************************
Extension:		Listeners
Description:	Add the top-level listeners.
Version:		1.1
Author:			John Flesch
Modified:		December 04, 2008
****************************************************************************************************
*/

application.extend(function(){
					  
	Mouse.addListener(vzw.events.ApplicationEvents);
	Key.addListener(vzw.events.ApplicationEvents);
	Stage.addListener(vzw.events.ApplicationEvents);
		
});