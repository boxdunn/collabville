package com.collabville.core.components
{	
	import com.collabville.core.components.supportClasses.IDisposable;
	
	import flash.geom.Point;
	
	import mx.core.IVisualElement;

	public interface IMapEntity extends IVisualElement, IDisposable
	{
		function get column ():uint;
		function set column ( value:uint ):void;
		function moveToPosition ( x:Number, y:Number, animate:Boolean = false ):void;
		function get occupancyGrid ():Vector.<uint>;
		function set occupancyGrid ( value:Vector.<uint> ):void;
		function get offset ():Point;
		function set offset ( value:Point ):void;
		function get row ():uint;
		function set row ( value:uint ):void;
		function get ID():uint;
		function set ID(value:uint):void;
		
		
	}
}