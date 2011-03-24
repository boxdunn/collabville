package com.collabville.core.rl.events
{
	import flash.events.Event;
	
	public class MoveEvent extends Event
	{
		public static const DOWN:String = "com.collabville.core.rl.events.MoveEvent.DOWN";
		public static const LEFT:String = "com.collabville.core.rl.events.MoveEvent.LEFT";
		public static const RIGHT:String = "com.collabville.core.rl.events.MoveEvent.RIGHT";
		public static const UP:String = "com.collabville.core.rl.events.MoveEvent.UP";
		
		public function MoveEvent ( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone ():Event {
			return new MoveEvent(type, bubbles, cancelable);
		}
	}
}