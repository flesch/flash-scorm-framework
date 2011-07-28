/*
****************************************************************************************************
Extension:		Data
Description:	Data Serialization.
Version:		2.0
Author:			John Flesch
Modified:		May 27, 2009
****************************************************************************************************
*/

application.extend(function(){
						 
	// By default, we're using JSON as the data-exchange format.
	if (vzw.external.ExternalProxy.available && application.getFlashVar("fvSuspendData")) {
		vzw.external.ExternalProxy.call("JSON.parse", [unescape(application.getFlashVar("fvSuspendData"))], vzw.utils.Delegate.create(application, function(object:Object):Void {
			application.data = object || {};
		}));
	}
						 
	function serialize(object:Object):Void {
		vzw.external.ExternalProxy.call("JSON.stringify", [object], function(json:String):Void {
			vzw.data.APIWrapper.LMSSetValue("cmi.suspend_data", escape(json));
			trace("JSON: "+escape(json));
		});
	}
	
	application.global.serialize = serialize;

}, application);