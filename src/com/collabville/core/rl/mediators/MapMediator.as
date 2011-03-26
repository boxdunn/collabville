package com.collabville.core.rl.mediators
{
	import com.collabville.core.components.IMapEntity;
	import com.collabville.core.components.MapDirections;
	import com.collabville.core.components.PlayerCharacter;
	import com.collabville.core.components.supportClasses.IGridMap;
	import com.collabville.core.rl.actors.PlayerIOServiceActor;
	import com.collabville.core.rl.events.DataEvent;
	import com.collabville.core.rl.events.MapEvent;
	import com.collabville.core.rl.events.PlayerIOEvent;
	import com.collabville.core.rl.models.CharacterModel;
	import com.collabville.core.rl.models.Characters;
	import com.collabville.core.utils.GridUtils;
	import com.collabville.core.utils.PlayerIOMessages;
	
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	import org.robotlegs.mvcs.Mediator;
	
	import playerio.Message;
	
	
	public class MapMediator extends Mediator
	{
		[Inject] public var map:IGridMap;
		[Inject] public var player:PlayerCharacter;
		[Inject] public var playerIOService:PlayerIOServiceActor;
		
		
		
		override public function onRegister ():void {
			addContextListener(MapEvent.MOVE, moveClientPlayer, DataEvent);
			addContextListener(PlayerIOEvent.ROOM_JOIN,onRoomJoin);
			addContextListener(PlayerIOEvent.ROOM_LEFT,onRoomLeft);
			addContextListener(PlayerIOEvent.PLAYERS_LIST,onPlayerList);
			addContextListener(PlayerIOEvent.PLAYER_MOVE,onPlayerMove);
			
			
			
			setMapAccessibility();
			addObjectSet();
			//addPlayer(player);
		}
		
		
		private function onPlayerMove(e:PlayerIOEvent):void
		{
			trace("client"+player.ID,"onSomePlayerMove",e.message.getUInt(0),e.message.getString(1));
				movePlayer(map.getEntityByID(e.message.getUInt(0)),e.message.getString(1));
			
		}
		
		private function onPlayerList(e:PlayerIOEvent):void
		{
			var currentUserID:uint;
			
			//create and position users
			for(var i:int=0;i<e.message.length;i+=6)
			{
				
				currentUserID=e.message.getUInt(i);
				
							
				if(!map.getEntityByID(currentUserID))
				addPlayer(createPlayer(e.message,i));
				
			}
		}
		
		private function createPlayer(m:Message,i:int=0):PlayerCharacter
		{
			var plyer:PlayerCharacter;
			var cls:Class;
			plyer=new PlayerCharacter();
			plyer.ID=m.getUInt(i);
			plyer.model=Characters[m.getString(i+2)];
			plyer.row=m.getUInt(i+3);
			plyer.column=m.getUInt(i+4);
			plyer.direction=m.getString(i+5);
			
			return plyer;
		}
		
		private function onRoomJoin(e:PlayerIOEvent):void
		{
			//create and postion new user
			if(e.id==player.ID)
			{
				
				
			 	addPlayer(player);
			}
			else
				addPlayer(createPlayer(e.message));
			
		}
		
		private function onRoomLeft(e:PlayerIOEvent):void
		{
			//remove player
			removePlayer(e.id);
		}
		
		override public function onRemove ():void {
			//removePlayer(player);
			map.removeEntity(player);
		}
		
		private function addObjectSet ():void {
			var objects:Vector.<IMapEntity> = map.mapData.staticObjects;
			
			if ( !objects ) return;
			
			var n:uint = objects.length;
			for ( var i:uint = 0; i < n; i++ )
				map.addEntity(objects[i], objects[i].row, objects[i].column);
		}
		
		private function addPlayer (plyr:PlayerCharacter):void {
			map.addEntity(plyr, plyr.row, plyr.column);
			map.positionEntity(plyr, plyr.row, plyr.column);
			
		}
		
		private function determineDestination ( direction:String ):Point {
			
			var index:int;
			
			switch ( direction ) {
				case MapDirections.EAST:
					index= 5;
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
		
		
		private function moveClientPlayer(event:DataEvent):void
		{
			var m:Message;
			
			if ( event.data ) {
				trace("client"+player.ID,"moveClientPlayer",player.ID,player.row,player.column);
				if(movePlayer(player,String(event.data))){
					
					m=playerIOService.connection.createMessage(PlayerIOMessages.MOVE,player.row,player.column,String(event.data));
					playerIOService.sendMessage(m);
				}
				
				
			}
		}
		
		private function movePlayer (plyr:IMapEntity,dir:String ):Boolean {
			
			
			   var point:Point = determineDestination(dir);
				
				if ( point == null ) return false;
				
				PlayerCharacter(plyr).direction = dir;
				
				if ( map.isPointAccessible(point.y, point.x) ) {
					if ( !map.isPointOccupied(point.y, point.x) ) {
						map.positionEntity(plyr, point.y, point.x, true);
						map.setEntityDepth(plyr);
						
						trace("client"+player.ID,"plyrMove",plyr.ID,plyr.row,plyr.column);
							
						return true;
					}
				}
				
				return false;
						
		}
		
		private function removePlayer (ID:int):void {
			
			var plyr:PlayerCharacter=PlayerCharacter(map.getEntityByID(ID));
			
			
			map.removeEntity(plyr);
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