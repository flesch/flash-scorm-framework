/*
****************************************************************************************************
Extension:		Branching XML
Description:	
Version:		2.0
Author:			John Flesch
Modified:

<?xml version="1.0" encoding="utf-8"?>
<application>

	<timeline branch="VZW">
		<slide src="001.swf"/>
		<slide src="002.swf" lock="true"/>
		<slide src="003.swf"/>
	</timeline>

	<timeline branch="IND">
		<slide src="001.swf"/>
		<slide src="002-ind.swf"/>
		<slide src="003.swf"/>
		<slide src="004-ind.swf"/>
		<slide src="005.swf"/>
	</timeline>

</application>
		
****************************************************************************************************
*/

application.extend(function(){
							 
	var DEFAULT_BRANCH:String = "VZW";
	var branch:String = application.getFlashVar("branch") || DEFAULT_BRANCH;
							 
	function getScaffolding():XMLNode {
		var _length:Number = application.xml.firstChild.childNodes.length, i:Number = 0;
		for (; i<_length; i++) {
			if (application.xml.firstChild.childNodes[i].nodeName === "timeline" && application.xml.firstChild.childNodes[i].attributes["branch"] === branch) {
				return application.xml.firstChild.childNodes[i];
			}
		}		
		return null;
	}						 

	application.override("getCurrentSlide", function():Number {
		var applicationXML:XMLNode = application.global.getScaffolding();
		var _length:Number = applicationXML.childNodes.length, i:Number = 0;
		for (; i<_length; i++) {
			if (application.currentSlide.indexOf(applicationXML.childNodes[i].attributes["src"]) != -1) {
				return i+1;
			}
		}
	});

	application.override("getTotalSlides", function():Number {
		return application.global.getScaffolding().childNodes.length;
	});
	
	
	application.override("gotoSlide", function(slideNumber:Object):Void {
		var applicationXML:XMLNode = application.global.getScaffolding();
		var _length:Number = applicationXML.childNodes.length+1, i:Number = 1;
		for (; i<_length; i++) {
			if (typeof slideNumber == "string") {
				if (slideNumber == applicationXML.childNodes[i-1].attributes["src"]) {
					application.getSlide(applicationXML.childNodes[i-1].attributes["src"]);
					this.currentSlide = applicationXML.childNodes[i-1].attributes["src"];
					break;
				}
			} else {
				if (slideNumber > 0 && slideNumber <= getTotalSlides() && i == slideNumber) {
					application.getSlide(applicationXML.childNodes[slideNumber-1].attributes["src"]);
					this.currentSlide = applicationXML.childNodes[slideNumber-1].attributes["src"];
					break;
				}
			}
		}
	});

	application.global.getScaffolding = getScaffolding;
	
	application.gotoSlide(1);
	
});