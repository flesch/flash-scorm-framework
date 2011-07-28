/*******************************************************************************
* default.as
*******************************************************************************/

/* <extensions> */
//#include "timeline.as"
#include "listeners.as"
#include "navigation.as"
#include "history.as"
#include "bookmark.as"
#include "lock-slides.as"
#include "accessibility.as"
#include "thin-client.as"
#include "learner.as"
#include "audio.as"
#include "video.as"
#include "progress-bar.as"
#include "fade-in.as"
#include "lms-connection-error.as"
#include "context-menu.as"
#include "continuous-play.as"
#include "debug.as"
/* </extensions> */

setTimeout(function(){
	application.dispatchEvent({type:"after", target:application.getTimeline()});
}, 0);