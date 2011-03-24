package {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormat;
	import flash.geom.Point;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import playerio.PlayerIO;
	import playerio.Connection;
	
	public class MovingNPCEntity extends MovieClip implements IMovingGameEntity
	{
		
		private var m_name:String;
		public var m_id:Number;
		public var m_available:Boolean;
		public var m_mc:MovieClip;
		public var m_pTopLeft:Point;
		public var m_pTopRight:Point;
		public var m_pBottomLeft:Point;
		public var m_pBottomRight:Point;
		public var m_worldX:Number;
		public var m_worldY:Number;
		public var m_cameraX:Number;
		public var m_cameraY:Number;
		public var m_opened:Boolean;
		public var m_star0:StarChest_mc;
		public var m_connection:Connection;
		
		public static const CLOSED:Number = 0;
		public static const OPENED:Number = 1;
		public static const UNAVAILABLE:Number = 2;
		
		public var m_state:Number;
		
		public var m_positions:Array = [];
		
		public var m_nextPos:CVector2d;
		
		
		public function MovingNPCEntity (idp:Number,namep:String,availablep:Boolean,conp:Connection)
		{
			m_id = idp;
			m_name = namep;
			m_available = availablep;
			m_worldX = 0;
			m_worldY = 0;
			m_cameraX = 0;
			m_cameraY = 0;
			m_state = CLOSED;
			m_connection = conp;
			
			m_nextPos = new CVector2d(0,0);
		}
		
		public function GetName():String
		{
			return m_name;
		}
		
		public function SetConnection(connectionp:Connection):void
		{
			m_connection = connectionp;
		}
		
		public function AttachMc(mc:MovieClip):void
		{
			m_mc = mc;
			
			addChild(m_mc);
			
		}
		
		public function SetState(statep:Number):void
		{
			m_state = statep;
		}
		
	}
}