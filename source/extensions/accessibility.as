/*
****************************************************************************************************
Extension:		Accessibility
Description:	Flash "forgets" the tab index of animated buttons inside nested movieclips.
				This extension aims to re-add a tab index.
Version:		2.0
Author:			John Flesch
Modified:		October 08, 2008
****************************************************************************************************
*/
application.extend(function(){
					 
	var SLIDES_TO_IGNORE:Array = [];
	//var SLIDES_TO_IGNORE:Array = [10, 20, 30];							 
	
	function updateAccessibilityTabIndex(e:Object):Void {
		function getChildren(scope:Object):Array {
			var children:Array = [];
			for (var i:String in scope) {
				if ((scope[i] instanceof MovieClip || scope[i] instanceof Button) && !(scope[i] instanceof mx.core.UIObject)) {
					children = children.concat([scope[i]]).concat(arguments.callee(scope[i]));
				} 
			}
			return children;
		}
		if (!vzw.utils.ArrayUtils.arrayIncludes(SLIDES_TO_IGNORE, application.getCurrentSlide())) {
			var children:Array = getChildren(e.target || e);
			children.sort();
			var _length:Number = children.length, i:Number = 0;
			for (; i<_length; i++) {
				if (children[i]._accProps.name && children[i]._accProps.description && (typeof children[i].tabIndex === "undefined")) {
					children[i].tabIndex = Number(children[i]._accProps.description) || (i+200);
				}
			}
		}
		Accessibility.updateProperties();
	}
	
	application.addEventListener("onSlideEnd", updateAccessibilityTabIndex);
	
	// Allow the developer to force an update.
	application.global.updateAccessibilityTabIndex = updateAccessibilityTabIndex;
	
});