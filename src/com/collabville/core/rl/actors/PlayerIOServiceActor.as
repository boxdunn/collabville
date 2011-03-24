package com.collabville.core.rl.actors
{
	import com.collabville.core.rl.events.PlayerIOEvent;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
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
		
		public function PlayerIOServiceActor () {
			super();
			
			
			
		}
		
		
		
		public function playerIOconnect(gameID:String,userId:String="testuser",connectionID:String="public",auth:String=""):void
		{
			
		
			PlayerIO.connect(FlexGlobals.topLevelApplication.stage,gameID,connectionID,userId,"",onPlayerIOConnect,onPlayerIOConnectError);
		}
		
		public function onPlayerIOConnect(client:Client):void
		{
			//Alert.show("connected");
			this.client=client;
			dispatch(new PlayerIOEvent(PlayerIOEvent.CONNECTED));
			
			
			client.multiplayer.createJoinRoom("MyRoom","MyGame",true,{},{},onJoinRoom,onJoinError);
		}
		
		public function onJoinRoom(connection:Connection):void
		{
			//Alert.show("onJoinRoom");
			this.connection=connection;
			
			connection.addMessageHandler("ChatInit", onInit)
			connection.addMessageHandler("ChatMessage", onMessage)
			connection.addMessageHandler("ChatJoin",onChatJoin);
				
			connection.addMessageHandler("ChatLeft", onChatLeft);
			
			
		}
		
		private function onInit(m:Message, id:String){
			dispatch(new PlayerIOEvent(PlayerIOEvent.INIT_CHAT));
			
		}
		
		private function onMessage(m:Message, id:String,name:String,message:String):void
		{
			dispatch(new PlayerIOEvent(PlayerIOEvent.CHAT_MESSAGE,m,id,name));
		}
		
		private function onChatLeft(m:Message, id:String)
		{
			
			dispatch(new PlayerIOEvent(PlayerIOEvent.ROOM_LEFT,m,id));
		}
		
		private function onChatJoin(m:Message, id:String, name:String){
			dispatch(new PlayerIOEvent(PlayerIOEvent.ROOM_JOIN,m,id,name)); 
		}
		
		public function onJoinError(error:PlayerIOError):void
		{
			Alert.show("error"+error.message);
		}
		
		public function onPlayerIOConnectError(error:PlayerIOError):void
		{
			Alert.show("error"+error.message);
		}
		
		public function sendMessage(message:String):void
		{
			
			connection.send("ChatMessage", message);
		}
		
	
	}
}