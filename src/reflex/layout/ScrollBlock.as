package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import flight.binding.Bind;
	import flight.events.PropertyEvent;
	import flight.position.IPosition;
	import flight.position.Position;
	
	public class ScrollBlock extends Block
	{
		[Bindable]
		public var hPosition:IPosition = new Position();		// TODO: implement lazy instantiation of Position
		
		[Bindable]
		public var vPosition:IPosition = new Position();
		
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		public function ScrollBlock(target:DisplayObject=null, scale:Boolean=false)
		{
			Bind.addBinding(this, "hPosition.space", this, "width", true);
			Bind.addBinding(this, "vPosition.space", this, "height", true);
			Bind.addBinding(this, "hPosition.size", this, "displayWidth");
			Bind.addBinding(this, "vPosition.size", this, "displayHeight");
			
			Bind.addListener(onPositionChange, this, "hPosition.value");
			Bind.addListener(onPositionChange, this, "vPosition.value");
			Bind.addListener(onSizeChange, this, "hPosition.space");
			Bind.addListener(onSizeChange, this, "vPosition.space");
			
			hPosition.stepSize = vPosition.stepSize = 10;
			hPosition.skipSize = vPosition.skipSize = 100;
			
			super(target, scale);
		}
		
		override public function set target(value:DisplayObject):void
		{
			if (target == value) {
				return;
			}
			
			if (target != null) {
				target.scrollRect = null;
			}
			
			super.target = value;
		}
		
		override public function get width():Number
		{
			return _width;
		}
		override public function set width(value:Number):void
		{
			if (_width == value) {
				return;
			}
			
			super.width = value;
			_width = PropertyEvent.change(this, "width", _width, value);
			PropertyEvent.dispatch(this);
		}
		
		override public function get height():Number
		{
			return _height;
		}
		override public function set height(value:Number):void
		{
			if (_height == value) {
				return;
			}
			
			super.height = value;
			_height = PropertyEvent.change(this, "height", _height, value);
			PropertyEvent.dispatch(this);
		}
		
		override public function get blockBounds():Bounds
		{
			return bounds;
		}
		
		private function onPositionChange(event:PropertyEvent):void
		{
			if (target == null) {
				return;
			}
			
			if (hPosition.filled && vPosition.filled) {
				target.scrollRect = null;
			} else {
				var rect:Rectangle = target.scrollRect || new Rectangle(hPosition.value, vPosition.value, hPosition.space, vPosition.space);
				rect.x = hPosition.value;
				rect.y = vPosition.value;
				target.scrollRect = rect;
			}
		}
		
		private function onSizeChange(event:PropertyEvent):void
		{
			if (target == null) {
				return;
			}
			
			if (hPosition.filled && vPosition.filled) {
				target.scrollRect = null;
			} else {
				var rect:Rectangle = target.scrollRect || new Rectangle(hPosition.value, vPosition.value, hPosition.space, vPosition.space);
				rect.width = hPosition.space;
				rect.height = vPosition.space;
				target.scrollRect = rect;
			}
		}
		
	}
}