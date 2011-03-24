package com.collabville.core.components
{
	import com.collabville.core.rl.models.CharacterModel;
	import com.collabville.core.rl.models.maps.OccupancyGridTypes;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import mx.core.IVisualElement;
	
	import spark.components.Group;
	
	public class CharacterEntity extends Group implements ICharacterEntity
	{
		private var _skin:IVisualElement;
		
		private var _model:CharacterModel;
		private var _offset:Point = new Point();
		
		private var _direction:String;
		
		private var _column:uint;
		private var _row:uint;
		
		public function CharacterEntity ( model:CharacterModel, direction:String = null ) {
			super();
			_model = model;
			this.direction = direction == null ? MapDirections.SOUTH : direction;
		}

		public function get column ():uint {
			return _column;
		}
		
		public function set column ( value:uint ):void {
			_column = value;
		}
		
		public function get direction ():String {
			return _direction;
		}
		
		public function set direction ( value:String ):void {
			switch ( value ) {
				case MapDirections.EAST:
				case MapDirections.NORTH:
				case MapDirections.SOUTH:
				case MapDirections.WEST:
					_direction = value;
					changeCharacterModel();
					break;
				default:
					break;
			}
		}
		
		public function dispose ():void {
			if ( _skin && this.contains(DisplayObject(_skin)) )
				removeElement(_skin);
				
			_skin = null;
			model = null;
			occupancyGrid = null;
		}
		
		public function get model ():CharacterModel {
			return _model;
		}
		
		public function set model ( value:CharacterModel ):void {
			_model = value;
			changeCharacterModel();
		}
		
		public function moveToPosition ( column:Number, row:Number, animate:Boolean = false ):void {
			var duration:Number = animate ? 0.4 : 0.0;
			column -= (_skin.width / 2);
			row -= _skin.height;
			
			TweenMax.to(this, duration, { x: column, y: row, ease: Linear.easeNone }); 
		}
		
		public function get occupancyGrid ():Vector.<uint> {
			return OccupancyGridTypes.CENTER;
		}
		
		public function set occupancyGrid ( value:Vector.<uint> ):void {
			return;
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
		
		private function changeCharacterModel ():void {
			if ( _skin && this.contains(DisplayObject(_skin)) )
				removeElement(_skin)			
			
			switch ( direction ) {
				case MapDirections.EAST:
					_skin = model.topRightDisplay;
					break;
				case MapDirections.NORTH:
					_skin = model.topLeftDisplay;
					break;
				case MapDirections.SOUTH:
					_skin = model.bottomRightDisplay;
					break;
				case MapDirections.WEST:
					_skin = model.bottomLeftDisplay;
					break;
				default:
					break;
			}
			
			if ( _skin is IVisualElement )
				addElement(_skin);
		}
	}
}