/*
****************************************************************************************************
Extension:		Video
Description:	This extension makes it easy to launch videos.
Version:		1.3
Author:			John Flesch
Modified:		January 12, 2011
Usage:			Call launchExternalVideo([video]); from your slides ([video] = "/video/[video].html")
****************************************************************************************************
*/
application.extend(function(){
							 
	// This really just abstracts the Javascript "launchExternalWindow" function.
	function launchExternalVideo(video:String):Void {
		vzw.external.ExternalProxy.call("launchExternalWindow", ["assets/video/"+video+".html", 650, 544, 0, 0]);
	}
	
	// Globalize this function.
	application.global.launchExternalVideo = launchExternalVideo;
		
});

 