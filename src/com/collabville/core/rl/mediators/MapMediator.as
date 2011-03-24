package com.collabville.core.rl.mediators
{
	import com.collabville.core.components.IMapEntity;
	import com.collabville.core.components.MapDirections;
	import com.collabville.core.components.PlayerCharacter;
	import com.collabville.core.components.supportClasses.IGridMap;
	import com.collabville.core.rl.events.DataEvent;
	import com.collabville.core.rl.events.MapEvent;
	import com.collabville.core.utils.GridUtils;
	
	import flash.geom.Point;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class MapMediator extends Mediator
	{
		[Inject] public var map:IGridMap;
		[Inject] public var player:PlayerCharacter;
		
		override public function onRegister ():void {
			addContextListener(MapEvent.MOVE, movePlayer, DataEvent);
			setMapAccessibility();
			addObjectSet();
			addPlayer();
		}
		
		override public function onRemove ():void {
			removePlayer();
		}
		
		private function addObjectSet ():void {
			var objects:Vector.<IMapEntity> = map.mapData.staticObjects;
			
			if ( !objects ) return;
			
			var n:uint = objects.length;
			for ( var i:uint = 0; i < n; i++ )
				map.addEntity(objects[i], objects[i].row, objects[i].column);
		}
		
		private function addPlayer ():void {
			map.addEntity(player, player.row, player.column);
			map.positionEntity(player, player.row, player.column);
		}
		
		private function determineDestination ( direction:String ):Point {
			switch ( direction ) {
				case MapDirections.EAST:
					var index:int = 5;
					break;
				case MapDirections.NORTH:
					index = 1;
					break;
				case MapDirections.SOUTH:
					index = 7;
					break;
				case MapDirections.WEST:
					index = 3;
					break;
				default:
					return null;
			}
			
			return GridUtils.getRelativeGridPoint(index, player.row, player.column);
		}
		
		private function movePlayer ( event:DataEvent ):void {
			if ( event.data ) {
				var direction:String = String(event.data);
				var point:Point = determineDestination(direction);
				
				if ( point == null ) return;
				
				player.direction = direction;
				
				if ( map.isPointAccessible(point.y, point.x) ) {
					if ( !map.isPointOccupied(point.y, point.x) ) {
						map.positionEntity(player, point.y, point.x, true);
						map.setEntityDepth(player);
					}
				}
			}			
		}
		
		private function removePlayer ():void {
			map.removeEntity(player);
		}
		
		private function setMapAccessibility ():void {
			var points:Vector.<Point> = map.mapData.inaccessiblePoints;
			
			if ( !points ) return;
			
			var n:uint = points.length;
			
			for ( var i:uint = 0; i < n; i++ )
				map.setPointAccessibility(points[i].y, points[i].x, false);
		}
	}
}