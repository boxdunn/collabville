package com.collabville.core.rl.events
{
	import flash.events.Event;
	
	import playerio.Message;
	
	public class PlayerIOEvent extends Event
	{
		public var message:Message;
		public var name:String;
		public var id:uint;
		public static const CONNECTED:String="playerIOConnected";
		public static const CHAT_MESSAGE:String="playerIOchatmessage";
		public static const ROOM_JOIN:String="playerIOroomjoin";
		public static const ROOM_LEFT:String="playerIOroomleft";
		public static const PLAYERS_LIST:String="playerIOUserList";
		public static const PLAYER_MOVE:String="playerIOMove";
		
		
		public function PlayerIOEvent(type:String,message:Message=null,id:uint=0,name:String=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.name=name;
			this.id=id;
			this.message=message;
			super(type, bubbles, cancelable);
		}
	}
}