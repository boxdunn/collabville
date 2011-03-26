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
		private var _ID:uint=NaN;
		
		public function CharacterEntity ( model:CharacterModel, direction:String = null ):void {
			super();
			
			_direction = direction == null ? MapDirections.SOUTH : direction;
			_model = model;
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
		
		public function get direction ():String {
			return _direction;
		}
		
		public function set direction ( value:String ):void {
			
			if(_direction==value) return;
			_direction=value;
			
				
			changeCharacterModel(_model)
			//if(!changeCharacterModel(_model))
				//throw new Error("Setting Model Direction on NoModel ERROR. Set model first");
			
			
			
			
			
			
			
			
		}
		
		private function changeCharacterModel(mod:CharacterModel):Boolean
		{
			if(mod)
			{
				if ( _skin && this.contains(DisplayObject(_skin)) )
					
					removeElement(_skin)
				switch ( _direction ) {
					case MapDirections.EAST:
						_skin = _model.topRightDisplay;
						break;
					case MapDirections.NORTH:
						_skin = _model.topLeftDisplay;
						break;
					case MapDirections.SOUTH:
						_skin = _model.bottomRightDisplay;
						break;
					case MapDirections.WEST:
						_skin = _model.bottomLeftDisplay;
						break;
					default:
						break;
				}
				
				if ( _skin is IVisualElement )
					addElement(_skin);
				
				
				return true;
			}
			else
				return false;
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
			
			if(_model==value) return; //same model
			
			_model = value;
			
			changeCharacterModel(value);
					
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
		
	
	}
}