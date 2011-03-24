package com.collabville.core.rl.events
{
	import flash.events.Event;
	
	
	import playerio.Message;
	
	public class PlayerIOEvent extends Event
	{
		public var message:Message;
		public var name:String;
		public var id:String;
		public static const CONNECTED:String="playerIOConnected";
		public static const CHAT_MESSAGE:String="playerIOchatmessage";
		public static const ROOM_JOIN:String="playerIOroomjoin";
		public static const ROOM_LEFT:String="playerIOroomleft";
		public static const INIT_CHAT:String="playerIOinitchat";
		
		
		public function PlayerIOEvent(type:String,message:Message=null,id:String=null,name:String=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.name=name;
			this.id=id;
			this.message=message;
			super(type, bubbles, cancelable);
		}
	}
}