/*
****************************************************************************************************
Extension:		Lock Slides
Description:	Lock and Unlock Slides.
Version:		1.3
Author:			John Flesch
Modified:		October 09, 2009
****************************************************************************************************
*/
application.extend(function(){
							 
	var SLIDES_TO_LOCK:Array = [];
	//var SLIDES_TO_LOCK:Array = [10, 20, 30];
	
	// Set up a list of what FRAMES we want to lock.
	var slidesToLock:Array = application.data.unlocks || SLIDES_TO_LOCK;
	
	function lockSlide(event:Object):Void {
		if (timeline.mcNextButton.enabled) {
			timeline.mcLockIcon._visible = false;
			var _length:Number = slidesToLock.length, i:Number = 0;
			for (; i<_length; i++) {
				if (slidesToLock[i] == application.getCurrentSlide()) {
					timeline.mcNextButton.tabEnabled = false;
					timeline.mcNextButton.enabled = false;
					timeline.mcLockIcon._visible = true;
					Accessibility.updateProperties();
					application.dispatchEvent({type:"onSlideLocked", data:application.getCurrentSlide()});
					break;
				}
			}
		}
	}
	
	function unlockSlide():Void {
		if (!timeline.mcNextButton.enabled) {
			var _length:Number = slidesToLock.length, i:Number = 0;
			for (; i<_length; i++) {
				if (slidesToLock[i] == application.getCurrentSlide()) {
					// Enable the Next button.
					timeline.mcNextButton.tabEnabled = true;
					timeline.mcNextButton.enabled = true;
					timeline.mcLockIcon._visible = false;
					Accessibility.updateProperties();
					// Remove the Slide from the "locked" array (so if the
					// user goes back he won't have to re-unlock the Slide).
					var slideUnlocked:Array = slidesToLock.splice(i, 1);
					application.data.unlocks = slidesToLock;
					application.global.serialize(application.data);
					// Broadcast that the Slide was unlocked, in case any other extensions want to do something also.
					application.dispatchEvent({type:"onSlideUnlocked", data:slideUnlocked});
					break;
				}
			}
		}
	}
	
	function isSlideLocked(slide:Number):Boolean {
		var slideToCheck:Number = slide || application.getCurrentSlide();
		var _length:Number = slidesToLock.length, i:Number = 0;
		for (; i<_length; i++) {
			if (slidesToLock[i] == slideToCheck) {
				return true;
			}
		}
		return false;
	}	
	
	timeline.mcLockIcon._visible = false;
	
	// Lock the Slide as soon as it's interactive.
	application.addEventListener("onSlideStart", lockSlide);

	// If the developer REMOVES a locked slide after the course has launched,
	// learners who have taken the course will see the old lock data.
	// This listener checks that the slide should really be locked.
	// NOTE: Developers cannot ADD a locked slide after launch.
	application.addEventListener("onSlideLocked", function(event):Void {
		var defaultSlideLocked:Boolean = vzw.utils.ArrayUtils.arrayIncludes(SLIDES_TO_LOCK, application.getCurrentSlide());
		if (!defaultSlideLocked && isSlideLocked(application.getCurrentSlide())) {
			unlockSlide();
		}
	});

	// Expose the unlock functionaility.	
	vzw.external.ExternalProxy.addCallback("unlock", unlockSlide);

	application.global.unlock = unlockSlide;
	application.global.isSlideLocked = isSlideLocked;
	
	// Allow the developer to unlock the slide with the SPACE.
	if (application.domain === "localhost" || application.domain.indexOf("pselm-utb")+1) {
		application.addEventListener("onKeyDown", function(event:Object):Void {		
			if (isSlideLocked() && Key.isDown(Key.CONTROL) && event.data === Key.SPACE) {
				unlockSlide();
			}
		});
	}
	
});