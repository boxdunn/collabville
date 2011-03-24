package com.collabville.core.rl.mediators
{
	import com.collabville.core.components.MapDirections;
	import com.collabville.core.components.PlayerCharacter;
	import com.collabville.core.rl.events.DataEvent;
	import com.collabville.core.rl.events.MapEvent;
	import com.collabville.core.utils.GridUtils;
	
	import flash.geom.Point;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class PlayerCharacterMediator extends Mediator
	{
		[Inject] public var player:PlayerCharacter;
		
		override public function onRegister ():void {
			addViewListener(MapEvent.MOVE, movePlayer, DataEvent);
		}
		
		private function movePlayer ( event:DataEvent ):void {
			if ( !event.data ) return;
			
			var direction:String = String(event.data);
			
			switch ( direction ) {
				case MapDirections.EAST:
				case MapDirections.NORTH:
				case MapDirections.SOUTH:
				case MapDirections.WEST:
					dispatch(new MapEvent(MapEvent.MOVE, direction));
					break;
				default:
					return;
			}
			
			 
		}
	}
}