package com.collabville.core.utils
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;

	public class KeyIndex
	{
		private var _index:Dictionary;
		private var _stage:Stage;
		
		public function KeyIndex ( stage:Stage ) {
			_stage = stage;
			init();
		}
		
		public function dispose ():void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
			_stage = null;
			clearDictionary();
		}
		
		public function get index ():Dictionary {
			return _index;
		}
		
		public function isDown ( keyCode:uint ):Boolean {
			return Boolean(keyCode in index);
		}
		
		public function get stage ():Stage {
			return _stage;
		}
		
		private function clearDictionary ():void {
			for each ( var value:* in index )
				delete index[value];
				
			_index = null;
		}
		
		private function init ():void {
			_index = new Dictionary(true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp, false, 0, true);
		}
		
		private function keyDown ( event:KeyboardEvent ):void {
			index[event.keyCode] = true;
		}
		
		private function keyUp ( event:KeyboardEvent ):void {
			delete index[event.keyCode];
		}
	}
}