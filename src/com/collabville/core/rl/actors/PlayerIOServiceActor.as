package com.collabville.core.rl.actors
{
	import com.collabville.core.components.PlayerCharacter;
	import com.collabville.core.rl.events.PlayerIOEvent;
	import com.collabville.core.utils.PlayerIOMessages;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.utils.getQualifiedClassName;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	
	import org.robotlegs.mvcs.Actor;
	
	import playerio.Client;
	import playerio.Connection;
	import playerio.Message;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	
	public class PlayerIOServiceActor extends Actor
	{
		
		public var connection:Connection;
		public var client:Client;
		
		
		public var players:Message;
		
		private var _local:Boolean;
		private var _player
		
		
		public function PlayerIOServiceActor () {
			super();
			
			
			
		}
		
		
		
		public function playerIOconnect(player:PlayerCharacter,gameID:String,userId:String="testuser",local:Boolean=false,connectionID:String="public",auth:String=""):void
		{
			_local=local;
			_player=player;
		
			PlayerIO.connect(FlexGlobals.topLevelApplication.stage,gameID,connectionID,userId,"",onPlayerIOConnect,onPlayerIOConnectError);
		}
		
		public function onPlayerIOConnect(client:Client):void
		{
			//Alert.show("connected");
			this.client=client;
			dispatch(new PlayerIOEvent(PlayerIOEvent.CONNECTED));
			
			if(_local)
			{
				client.multiplayer.developmentServer = "127.0.0.1:8184";
			}
			
			
			client.multiplayer.createJoinRoom("Asd21ssr2(3hj1k232j3k#2hkj32hj23h2£$3kj2{hbdsao","MyGame",true,{},{model:_player.model.type,row:_player.row,col:_player.column,direction:_player.direction},onJoinRoom,onJoinError);
		}
		
		public function onJoinRoom(connection:Connection):void
		{
			//Alert.show("onJoinRoom");
			this.connection=connection;
			
			
			
			connection.addMessageHandler(PlayerIOMessages.PLAYERS_LIST, onInit)
			connection.addMessageHandler(PlayerIOMessages.CHAT, onMessage)
			connection.addMessageHandler(PlayerIOMessages.PLAYER_JOIN,onRoomJoin);
			connection.addMessageHandler(PlayerIOMessages.MOVE,onMove);
			connection.addMessageHandler(PlayerIOMessages.PLAYER_LEFT, onRoomLeft);
			
			
		}
		
		private function onMove(m:Message,row:uint,col:uint):void{
			
			if(m.getInt(0)!=_player.ID)
			dispatch(new PlayerIOEvent(PlayerIOEvent.PLAYER_MOVE,m));
		}
		
		private function onInit(m:Message):void{
			players=m;
			
			dispatch(new PlayerIOEvent(PlayerIOEvent.PLAYERS_LIST,m));
			
		}
		
		private function onMessage(m:Message, id:String,name:String,message:String):void
		{
			dispatch(new PlayerIOEvent(PlayerIOEvent.CHAT_MESSAGE,m,uint(id),name));
		}
		
		private function onRoomLeft(m:Message, id:String):void
		{
			
			dispatch(new PlayerIOEvent(PlayerIOEvent.ROOM_LEFT,m,uint(id)));
		}
		
		private function onRoomJoin(m:Message, id:String, name:String):void{
			
			if(!_player.ID) _player.ID=uint(id);
			
				dispatch(new PlayerIOEvent(PlayerIOEvent.ROOM_JOIN,m,uint(id),name)); 
			
		}
		
		public function onJoinError(error:PlayerIOError):void
		{
			Alert.show("error"+error.message);
		}
		
		public function onPlayerIOConnectError(error:PlayerIOError):void
		{
			Alert.show("error"+error.message);
		}
		
		
		
		public function sendMessage(m:Message):void
		{
			
			connection.sendMessage(m);
			//connection.send("ChatMessage", message);
		}
		
	
	}
}