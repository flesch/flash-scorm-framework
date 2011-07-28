/*
****************************************************************************************************
Extension:		Audio
Description:	Mute and Unmute the audio.
Version:		1.1
Author:			John Flesch
Modified:		November 05, 2008
****************************************************************************************************
*/
application.extend(function(){
							 
	var hasAudio:Boolean = true;
	
	var globalAudioControl:Sound = new Sound(timeline);
	
	function fadeAudio(fadeDirection:String):Void {
		application.data.volume = (fadeDirection == "out") ? 0 : 100;	
		globalAudioControl.setVolume(fadeDirection == "out" ? 100 : 0);
		var fadeInterval:Number = setInterval(function(){			
			//trace(globalAudioControl.getVolume());													
			if (fadeDirection == "out" && globalAudioControl.getVolume() > 0) {
				globalAudioControl.setVolume(globalAudioControl.getVolume()-5);
			} else if (fadeDirection == "in" && globalAudioControl.getVolume() < 100) {
				globalAudioControl.setVolume(globalAudioControl.getVolume()+1);
			} else {
				globalAudioControl.setVolume(fadeDirection == "out" ? 0 : 100);
				clearInterval(fadeInterval);
			}		
		}, 10);
		application.global.serialize(application.data);
	}
	
	function toggleMuteState(eventObject:Object):Void {
		this.selected = !this.selected;
		fadeAudio(this.selected ? "out" : "in");
	}
	
	if (hasAudio) {
		if (!application.data.volume) {
			application.data.volume = 100;
		}
		if (timeline.mcMuteButton instanceof vzw.controls.MovieClipButton) {
			timeline.mcMuteButton.addEventListener("onRelease", toggleMuteState);
		} else {
			timeline.mcMuteButton.onRelease = toggleMuteState;
		}
		if (Number(application.data.volume) <= 0) {
			timeline.mcMuteButton.selected = true;
			globalAudioControl.setVolume(0);
		}
	} else {
		timeline.mcMuteButton.swapDepths(timeline.getNextHighestDepth());
		timeline.mcMuteButton.removeMovieClip();
	}

});