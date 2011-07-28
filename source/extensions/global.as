/*
****************************************************************************************************
Extension:		Global
Description:	Make application.global easier to use.
Version:		1.0
Author:			John Flesch
Modified:		December 01, 2008
****************************************************************************************************
*/
application.extend(function(){

	// Convert application.global to _global.
	for (var i:String in application.global) {
		_global[i] = application.global[i];
	}							 
	
	// In AS3, _global doesn't exist, so we'll attempt to make things a little easier
	// by adding each global function to the root of the slide.
	application.addEventListener("onSlideLoad", function(event:Object):Void {
		for (var i:String in application.global) {
			event.target[i] = application.global[i];
		}		
	});

});