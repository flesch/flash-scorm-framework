import mx.events.EventDispatcher;
class vzw.controls.MovieClipButton extends MovieClip {

	private var _overStateFrame:Number;
	private var _downStateFrame:Number;

	private var _enabled:Boolean = true;
	private var _selected:Boolean = false;
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;	
	
	private var onEnterFrame:Function;
	
	public function MovieClipButton() {
		EventDispatcher.initialize(this);
		
		this.stop();
		this._visible = false;
		
		this.gotoAndStop("over");
		this._overStateFrame = this._currentframe;
		this.gotoAndStop("down");
		this._downStateFrame = this._currentframe;
		
		this.gotoAndStop("up");
		this._visible = true;

		dispatchEvent({type:"onLoad", target:this});
		
		this.enabled = this.enabled;
		this.selected = this.selected;		
		
	}

	private function onPress():Void {
		this.gotoAndStop("down");
		dispatchEvent({type:"onPress", target:this});
	}
	
	private function onRelease():Void {
		this.gotoAndStop(this._downStateFrame-1);
		dispatchEvent({type:"onRelease", target:this});
	}	

	private function onReleaseOutside():Void {
		this.onRollOut();
		dispatchEvent({type:"onReleaseOutside", target:this});
	}	
	
	private function onRollOver():Void {
		if (this.enabled && !this.selected) {
			this.gotoAndStop(this._overStateFrame);
			if (this._overStateFrame<this._downStateFrame-1) {
				this.onEnterFrame = this.onRollOverAnimation;
			}
		dispatchEvent({type:"onRollOver", target:this});
		}
	}
	
	private function onRollOut():Void {
		if (this.enabled && !this.selected) {
			this.stop();
			if (this._overStateFrame<this._downStateFrame-1) {
				this.onEnterFrame = this.onRollOutAnimation;
			} else {
				this.gotoAndStop(this._overStateFrame);
			}
		dispatchEvent({type:"onRollOut", target:this});
		}
	}
	
	private function onRollOverAnimation():Void {
		if (this._currentframe<this._downStateFrame-1) {
			this.nextFrame();
		} else {
			this.stop();
			delete this.onEnterFrame;
		}
	}
	
	private function onRollOutAnimation():Void {
		if (this._currentframe>this._overStateFrame) {
			this.prevFrame();
		} else {
			this.gotoAndStop("up");
			delete this.onEnterFrame;
		}
	}
	
	private function onDragOver():Void {
		dispatchEvent({type:"onDragOver", target:this});
	}
	
	private function onDragOut():Void {
		dispatchEvent({type:"onDragOut", target:this});
	}
	
	private function onSetFocus():Void {
		this.onRollOver();
		dispatchEvent({type:"onSetFocus", target:this});
	}
	
	private function onKillFocus():Void {
		if (this.enabled && !this.selected) {
			this.onRollOut();
		}
		dispatchEvent({type:"onKillFocus", target:this});
	}
	
	public function get enabled():Boolean {
		return this._enabled;
	}
	
	public function set enabled(state:Boolean):Void {
		this._enabled = state;
		this.useHandCursor = this._enabled;
		this.gotoAndStop((this._enabled) ? "up" : "disabled");
		if (this.hitTest(_root._xmouse, _root._ymouse, true)) {
			this.onRollOver();
		}
		dispatchEvent({type:"onEnabled", target:this, data:this._enabled});
	}
	
	public function get selected():Boolean {
		return this._selected;
	}
	
	public function set selected(state:Boolean):Void {
		this._selected = state;
		this.gotoAndStop((this._selected) ? "selected" : (this.enabled) ? "up" : "disabled");
		if (this.hitTest(_root._xmouse, _root._ymouse, true)) {
			this.onRollOver();
		}		
		dispatchEvent({type:"onSelected", target:this, data:this._selected});
	}	
	
}
