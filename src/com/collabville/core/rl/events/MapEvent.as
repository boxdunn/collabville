package com.collabville.core.rl.events
{
	import flash.events.Event;

	public class MapEvent extends DataEvent
	{
		public static const CHANGE:String = "com.collabville.core.rl.events.MapEvent.CHANGE";
		public static const MOVE:String = "com.collabville.core.rl.events.MapEvent.MOVE";
		public static const CLICK:String = "com.collabville.core.rl.events.MapEvent.CLICK";
		
		public function MapEvent ( type:String, data:Object = null, bubbles:Boolean = false ) {
			super(type, data, bubbles);
		}
		
		override public function clone():Event {
			return new MapEvent(type, data, bubbles);
		}
	}
}