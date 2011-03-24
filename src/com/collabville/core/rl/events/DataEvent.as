package com.collabville.core.rl.events
{
	import flash.events.Event;
	
	public class DataEvent extends Event
	{
		private var _data:Object;
		
		public function DataEvent ( type:String, data:Object = null, bubbles:Boolean = false ) {
			_data = data;
			super(type, bubbles);
		}
		
		override public function clone ():Event {
			return new DataEvent(type, data, bubbles);
		}
		
		public function get data ():Object {
			return _data;
		}
	}
}