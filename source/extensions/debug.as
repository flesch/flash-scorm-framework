/*
****************************************************************************************************
Extension:		Debug
Description:	Troubleshooting Easter Eggs
Version:		2.1
Author:			John Flesch
Modified:		January 12, 2011
****************************************************************************************************
*/
application.extend(function(){

	// Let's track what version of the application the user is seeing, and the Flash player version.
	if (!application.data.version) {
		application.data.version = {
			app: application.version,
			//player: System.capabilities.version,
			player: System.capabilities.version.split(",").splice(0, 4).join(".").substr(4)
		};
	}
	
	application.data.domain = application.domain;
	
	if (!application.data.path) {
		vzw.external.ExternalProxy.call("(function(){return escape(window.location.pathname);})", null, function(pathName:String):Void {
			application.data.path = pathName;			
		});
	}	

	// CTRL+J: Serialize and copy the JSON text to the clipboard when the user presses CTRL+J.
	// CTRL+M: IE7 seems to overide CTRL+J, so CTRL+M can be used instead.
	application.addEventListener("onKeyDown", function(event:Object):Void {
		if (Key.isDown(Key.CONTROL) && !Key.isDown(Key.SHIFT) && (event.data === 74 || event.data === 77)) {
			vzw.external.ExternalProxy.call("JSON.stringify", [application.data], function(json:String):Void {
				System.setClipboard(escape(json));
				vzw.external.ExternalProxy.call("alert", ["Your tracking data has been copied to the clipboard."]);
			});
		}		
	});

	// If SHIFT is pressed in conjunction with CTRL+J/M, just show the unescaped JSON.
	application.addEventListener("onKeyDown", function(event:Object):Void {
		if (Key.isDown(Key.CONTROL) && Key.isDown(Key.SHIFT) && (event.data === 74 || event.data === 77)) {
			vzw.external.ExternalProxy.call("JSON.stringify", [application.data, null, "\\t"], function(json:String):Void {
				System.setClipboard(unescape(json));
				vzw.external.ExternalProxy.call("alert", [unescape(json)]);
			});
		}		
	});	
	
	if (application.domain === "localhost" || application.domain.indexOf("pselm-utb")+1) {
		
		// CTRL+K: Output the content slide's source file.
		application.addEventListener("onKeyDown", function(event:Object):Void {		
			if (Key.isDown(Key.CONTROL) && event.data === 75) {		
				var sourceFileName:String = application.currentSlide.split("swf").join("fla").split("?session")[0];
				vzw.external.ExternalProxy.call("alert", [application.getCurrentSlide()+": "+sourceFileName]);
				trace(application.getCurrentSlide()+": "+sourceFileName);
			}
		});
	
		// CTRL+G: Allow the developer to jump to a slide.
		application.addEventListener("onKeyDown", function(event:Object):Void {		
			if (Key.isDown(Key.CONTROL) && event.data === 71) {
				vzw.external.ExternalProxy.call("prompt", ["Go to slide:", application.getTotalSlides()], function(slide:Number):Void {
					if (slide) {
						application.gotoSlide(slide);
					}
				});
			}
		});
	
		// CTRL+.: Enable "scrubbing" through the timeline by using the MouseWheel.
		application.addEventListener("onKeyDown", function(event:Object):Void {			
			if (Key.isDown(Key.CONTROL) && event.data === 190) {				
				application.addEventListener("onMouseWheel", function(event:Object):Void {
					if (event.data.delta < 0) {
						application.gotoNextSlide();
					} else {
						application.gotoPreviousSlide();
					}
				});
				application.removeEventListener("onKeyDown", arguments.callee);
			}
		});
		
	}

});