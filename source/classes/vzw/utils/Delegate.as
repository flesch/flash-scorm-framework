// http://dynamicflash.com/2005/02/delegate-class-refined/
class vzw.utils.Delegate {
	public static function create(target:Object, handler:Function):Function {
		var args:Array = arguments.slice(2);
		var delegate:Function = function ():Function {
			var self:Function = arguments.callee;
			return self.handler.apply(self.target, arguments.concat(self.args, [self]));
		};
		delegate.args = args;
		delegate.handler = handler;
		delegate.target = target;
		return delegate;
	}
}
