/*
****************************************************************************************************
Extension:		Learner
Description:	Get info about the learner.
Version:		1.2
Author:			John Flesch
Modified:		September 17, 2009
****************************************************************************************************
*/
application.extend(function(){

	// Get the learner's first name: "Hello, Clark."							 
	function getLearnerFirstName():String {
		return (application.getFlashVar("fvStudentName") || "Kent, Clark").split(", ").pop().toString();
	}
	
	// Get the learner's last name: "Kent"
	function getLearnerLastName():String {
		return (application.getFlashVar("fvStudentName") || "Kent, Clark").split(", ").shift().toString();
	}
	
	// Get the formatted learner's name: "Clark Kent"
	function getLearnerName():String {
		return getStudentFirstName() + " " + getStudentLastName();
	}
	
	// Get the learner's Employee ID Number
	function getLearnerId():String {
		return (application.getFlashVar("fvStudentId") || "61938");
	}

	// Get the learner's "Learner Number" for display on the certificate.
	function getLearnerNumber():Number {
		return Number(getLearnerId()) * Number(getLearnerId());
	}
	
	function convertLearnerNumberToId(n:Number):String {
		return Math.sqrt(n).toString();
	}

	// Globalize these functions.
	application.global.getLearnerFirstName = getLearnerFirstName;
	application.global.getLearnerLastName = getLearnerLastName;
	application.global.getLearnerName = getLearnerName;
	
	// Legacy
	application.global.getStudentFirstName = getLearnerFirstName;
	application.global.getStudentLastName = getLearnerLastName;
	application.global.getStudentName = getLearnerName;	
	
});