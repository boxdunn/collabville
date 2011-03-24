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
	
	public interface IGameEntity
	{
		function SetConnection(connectionp:Connection):void;
		function GetId():Number;
		function GetWorldX():Number;
		function GetWorldY():Number;
		function GetName():String;
		function GetMc():MovieClip;
		function OnMouseDown(charX:Number, charY:Number, user:Avatar, nameEntityClicked:String):void;
		function SetState(statep:Number):void;
		function AttachMc(mc:MovieClip):void;
		function Use(usedByMe:Boolean):void;
	}
}