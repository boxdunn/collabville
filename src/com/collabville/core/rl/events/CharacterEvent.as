package com.collabville.core.rl.events
{
	import flash.events.Event;

	public class CharacterEvent extends DataEvent
	{
		public static const ADD:String = "com.collabville.core.rl.events.CharacterEvent.ADD";
		public static const CHANGE:String = "com.collabville.core.rl.events.CharacterEvent.CHANGE";
		
		public function CharacterEvent ( type:String, data:Object = null, bubbles:Boolean = false )	{
			super(type, data, bubbles);
		}
		
		override public function clone ():Event {
			return new CharacterEvent(type, data, bubbles);
		}
	}
}