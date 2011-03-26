package com.collabville.core.rl.models
{
	import mx.core.IVisualElement;

	public class CharacterModel
	{
		private var _bottomLeftDisplay:IVisualElement;
		private var _bottomRightDisplay:IVisualElement;
		private var _topLeftDisplay:IVisualElement;
		private var _topRightDisplay:IVisualElement;
		private var _type:String;
		

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get bottomLeftDisplay ():IVisualElement {
			return _bottomLeftDisplay;
		}

		public function set bottomLeftDisplay ( value:IVisualElement ):void {
			_bottomLeftDisplay = value;
		}

		public function get bottomRightDisplay ():IVisualElement {
			return _bottomRightDisplay;
		}

		public function set bottomRightDisplay ( value:IVisualElement ):void {
			_bottomRightDisplay = value;
		}

		public function get topLeftDisplay ():IVisualElement {
			return _topLeftDisplay;
		}

		public function set topLeftDisplay ( value:IVisualElement ):void {
			_topLeftDisplay = value;
		}

		public function get topRightDisplay ():IVisualElement {
			return _topRightDisplay;
		}

		public function set topRightDisplay ( value:IVisualElement ):void {
			_topRightDisplay = value;
		}
	}
}