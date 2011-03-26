package com.collabville.core.components
{
	import com.collabville.core.rl.events.MapEvent;
	import com.collabville.core.rl.models.CharacterModel;
	import com.collabville.core.rl.models.Characters;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import mx.core.FlexGlobals;
	
	public class PlayerCharacter extends CharacterEntity
	{
		public function PlayerCharacter () {
			super(null);//Characters.pandaModel
			this.addEventListener(Event.ADDED_TO_STAGE, stageAdded, false, 0, true);
		}
		
		private function keyDown ( event:KeyboardEvent ):void {
			switch ( event.keyCode ) {
				case 37:
					var direction:String = MapDirections.WEST;
					break;
				case 38:
					direction = MapDirections.NORTH;
					break;
				case 39:
					direction = MapDirections.EAST;
					break;
				case 40:
					direction = MapDirections.SOUTH;
					break;
				default:
					return;
			}
			
			dispatchEvent(new MapEvent(MapEvent.MOVE, direction));
		}
		
		private function stageAdded ( event:Event ):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, stageAdded);
			FlexGlobals.topLevelApplication.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
			FlexGlobals.topLevelApplication.setFocus();
		}
	}
}