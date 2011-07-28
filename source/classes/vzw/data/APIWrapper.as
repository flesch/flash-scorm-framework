import vzw.external.ExternalProxy;
class vzw.data.APIWrapper {
	static function LMSSetValue(dataModel:String, dataValue:String):Void {
		ExternalProxy.call("LMSSetValue", [dataModel, dataValue]);
	}
	static function LMSCommit():Void {
		ExternalProxy.call("LMSCommit");
	}
}
