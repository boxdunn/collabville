package com.collabville.core.components
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import mx.core.IVisualElement;
	
	import spark.components.Group;
	
	public class MapEntity extends Group implements IMapEntity
	{
		public var graphic:IVisualElement;
		
		private var _offset:Point;
		
		private var _column:uint;
		private var _row:uint;
		private var _ID:uint;
		
		
		private var _occupancyGrid:Vector.<uint> = new Vector.<uint>();
		
		public function MapEntity ( graphic:IVisualElement = null ) {
			super();
			if ( graphic ) {
				this.graphic = graphic;
				addElement(this.graphic);
			}
		}
		
		public function get ID():uint
		{
			return _ID;
		}
		
		public function set ID(value:uint):void
		{
			_ID = value;
		}

		public function get column ():uint {
			return _column;
		}

		public function set column ( value:uint ):void {
			_column = value;
		}
		
		public function dispose ():void {
			occupancyGrid = null;
			if ( graphic && this.contains(DisplayObject(graphic)) )
				removeElement(graphic);
			
			graphic = null;
		}
		
		public function moveToPosition ( x:Number, y:Number, animate:Boolean = false ):void {
			this.x = x - (graphic.width / 2);
			this.y = y - graphic.height;
		}
		
		public function get occupancyGrid ():Vector.<uint> {
			return _occupancyGrid;
		}
		
		public function set occupancyGrid ( value:Vector.<uint> ):void {
			_occupancyGrid = value;
		}
		
		public function get offset ():Point {
			return _offset;
		}
		
		public function set offset ( value:Point ):void {
			_offset = value;
		}
		
		public function get row ():uint {
			return _row;
		}
		
		public function set row ( value:uint ):void {
			_row = value;
		}
	}
}