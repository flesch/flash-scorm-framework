class vzw.utils.ArrayUtils {
	public static function arrayIncludes(arr:Array, val:Object):Boolean {
		var _length:Number = arr.length, i:Number = 0;
		for (; i<_length; i++) {
			if (arr[i] == val) {
				return true;
			}
		}
		return false;
	}	
}