package
{
	import flash.display.MovieClip
	import flash.text.TextField
	import flash.events.Event
	import flash.events.MouseEvent
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormat;
	import flash.geom.Point;
	import playerio.*;
	
	public interface IMovingGameEntity
	{
		function SetConnection(connectionp:Connection):void;
		function GetName():String;
		function SetState(statep:Number):void;
		function AttachMc(mc:MovieClip):void;
	}
}