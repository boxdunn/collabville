package com.collabville.core.components
{
	import com.collabville.core.rl.models.maps.GoogleplexData;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IVisualElement;
	
	import spark.components.Group;

	public class PositionMarker extends Group implements IMapMarker
	{	
		private var _accessible:Boolean = true;
		private var _occupant:IVisualElement;
		
		private var _column:uint;
		private var _row:uint;		
		
		public function PositionMarker () {
			super();
		}
		
		public function get accessible ():Boolean {
			return _accessible;
		}
		
		public function set accessible ( value:Boolean ):void {
			_accessible = value;
			draw();
		}
		
		public function get center ():Point {
			var point:Point = new Point(this.x, this.y);
			point.offset(this.width / 2, this.height / 2);
			return point;
		}

		public function get column ():uint {
			return _column;
		}

		public function set column ( value:uint ):void {
			_column = value;
		}
		
		public function dispose ():void {
			graphics.clear();
			occupant = null;
		}
		
		public function draw ():void {
			var g:Graphics = this.graphics;
			var halfWidth:Number = this.width / 2;
			var halfHeight:Number = this.height / 2;
			
			if ( !accessible || occupied )
				var fill:uint = 0x990000;
			else
				fill = 0x009900;
			
			g.clear();
			g.lineStyle(0, fill, 0.0);
			g.beginFill(fill, 0.4);
			g.moveTo(halfWidth, 0);
			g.lineTo(width, halfHeight);
			g.lineTo(halfWidth, height);
			g.lineTo(0, halfHeight);
			g.lineTo(halfWidth, 0);
			g.endFill();
		}

		public function get occupant ():IVisualElement {
			return _occupant;
		}

		public function set occupant ( value:IVisualElement ):void {
			_occupant = value;
			draw();
		}
		
		public function get occupied ():Boolean {
			return _occupant != null;
		}
		
		public function get row ():uint {
			return _row;
		}
		
		public function set row ( value:uint ):void {
			_row = value;
		}
	}
}