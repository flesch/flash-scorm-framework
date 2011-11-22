import mx.events.EventDispatcher;
import vzw.utils.OnEnterFrameBeacon;
import vzw.controls.Slides;
import vzw.events.ApplicationEvents;

class vzw.application.Application extends vzw.controls.Slides {

	private static var _instance:Application;
	private static var _allowInstance:Boolean;
	private static var _active;

	private var _timeline:MovieClip;
	
	public var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;	

	public var version:String = "2.7.0";
	public var session:Number, domain:String, global:Object, data:Object, xml:XML;
		
	public function Application() {	
		if (!Application._allowInstance) {
			throw new Error("Error: Use Application.getInstance() instead of the new keyword.");
		} else {		
			EventDispatcher.initialize(this);
			OnEnterFrameBeacon.init();
			OnEnterFrameBeacon.addListener(ApplicationEvents);
			this.session = Number(new Date());
			this.domain = (new LocalConnection()).domain();
			this.global = {};
			this.data = {};
			this.xml = _parent.applicationXML;
		}
	}
	
	public static function getInstance():Application {
		if (Application._instance == null) {
			Application._allowInstance = true;
			Application._instance = new Application();
			Application._allowInstance = false;
		}
		return Application._instance;
	}
	
	public function getTimeline():MovieClip {
		return this._timeline;
	}
	
	public function getFlashVar(flashVar:String):String {
		var timeline:MovieClip = this.getTimeline() || _root;
		while (timeline) {
			if (timeline[flashVar]) {
				return timeline[flashVar];
			} else {
				timeline = timeline._parent;
			}
		}	
		return null;
	}

	public function extend(callback:Function, scope:Object):Void {
		var timeline:MovieClip = this.getTimeline();
		vzw.utils.Delegate.create(scope || timeline, callback)();
	}
	
	public function override(method:String, closure:Function):Void {
		if (typeof this[method] === "function") {
			this[method] = closure;
		}
	}
	
	public function init(timeline:MovieClip):Void {
		if (Application._active == null) {
			
			this._timeline = timeline;
			this._timeline.stop();
			
			// Include the extension that should run when the Application is initialized.
			var application:Application = Application.getInstance();
			var timeline:MovieClip = application.getTimeline();
			#include "../../../extensions/application.as"					
			
			if (!this.xml) {				
				this.xml = new XML();
				this.xml.ignoreWhite = true;
				this.xml.load("assets/xml/application.xml");
				this.xml.onLoad = vzw.utils.Delegate.create(this, function(success:Boolean):Void {
					if (success) {
						this.dispatchEvent({type:"onInitialize", target:this._timeline});
					}
				});
			} else {
				this.dispatchEvent({type:"onInitialize", target:this._timeline});
			}
			Application._active = true;			
		}			
	}

}