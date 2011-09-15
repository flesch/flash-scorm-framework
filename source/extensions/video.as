/*
****************************************************************************************************
Extension:		Video
Description:	This extension makes it easy to launch videos.
Version:		1.4
Author:			John Flesch
Modified:		September 14, 2011
Usage:			Call launchExternalVideo("video1"); from your slides ("video1" = "/video/video1.html")
****************************************************************************************************
*/
application.extend(function(){
							 
	// This really just abstracts the Javascript "launchExternalWindow" function.
	function launchExternalVideo(name:String):Void {
		vzw.external.ExternalProxy.call("launchExternalWindow", ["video/"+name+".html", 640, 385, 0, 0]);
	}	
	
	// Globalize this function.
	application.global.launchExternalVideo = launchExternalVideo;
		
});

 