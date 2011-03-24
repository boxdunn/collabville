package {
	import flash.display.MovieClip
	import flash.text.TextField
	import flash.events.Event
	import flash.events.MouseEvent
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormat;
	import flash.geom.Point;
	import playerio.*;
	
	public class GameRoom extends MovieClip
	{
		
		
		public var m_available:Boolean;
		
		public var m_leftExit:Boolean;
		public var m_rightExit:Boolean;
		public var m_topExit:Boolean;
		public var m_bottomExit:Boolean;
		public var m_width:Number;
		public var m_height:Number;
		public var m_connection:Connection;
		public var m_objectEntities:Array = [];
		public var m_movingNPCEntities:Array = [];
		
		
		public function GameRoom(availablep:Boolean)
		{
			m_available = availablep;
			
			m_leftExit = false;
			m_rightExit = false;
			m_topExit = false;
			m_bottomExit = false;
			m_width = 0;
			m_height = 0;
		}
		
		public function AttachMc(mc:MovieClip)
		{
			//m_mc = mc;
			//addChild(m_mc);
		}
		
		public function SetConnection(connectionp:Connection):void
		{
			m_connection = connectionp;
			
			for each (var o:IGameEntity in m_objectEntities)
			{
				o.SetConnection(m_connection);
			}
		}
		
	}
	
}