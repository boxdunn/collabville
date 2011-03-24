package com.collabville.core.components
{
	import com.collabville.core.components.supportClasses.IDisposable;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IVisualElement;

	public interface IMapMarker extends IVisualElement, IDisposable
	{
		function get accessible ():Boolean;
		function set accessible ( value:Boolean ):void;
		function get center ():Point;
		function get column ():uint;
		function set column ( value:uint ):void;
		function getBounds ( targetCoordinateSpace:DisplayObject ):Rectangle;
		function get occupant ():IVisualElement;
		function set occupant ( value:IVisualElement ):void;
		function get occupied ():Boolean;
		function get row ():uint;
		function set row ( value:uint ):void;
	}
}