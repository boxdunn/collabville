package com.collabville.core.rl.events
{
	import flash.events.Event;
	
	public class ChatViewEvent extends Event
	{
		public var message:String;
		
		public static const SEND:String="messageSend";
		
		public function ChatViewEvent(type:String,message:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.message=message;
			super(type, bubbles, cancelable);
		}
	}
}