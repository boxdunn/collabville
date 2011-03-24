package {
	import flash.display.MovieClip
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.text.TextField
	import flash.events.Event
	import flash.events.MouseEvent
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.Font;
	import fl.controls.TextArea;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class MiniMap extends MovieClip
	{
		public var m_id:Number;
		public var m_tf:TextField;
		public var m_text:String;
		public var m_mc:MovieClip;
		public var m_dotMc:MovieClip;
		public var m_avatarsInRoom:Array = [];
		
		
		
		
		public function MiniMap()
		{
			
			var myfont:Font = new Font1();
			var tformat:TextFormat = new TextFormat();
			tformat.font = myfont.fontName;
			tformat.size = 12;
			
			
			m_mc = new MovieClip();
			m_mc.graphics.beginFill(0xFFFFFF, 0.8);
			m_mc.graphics.drawRoundRect(0,0,80,80,10,10);
			m_mc.graphics.endFill();
			
			m_dotMc = new MovieClip();
			m_dotMc.graphics.beginFill(0xFF0000, 1.0);
			m_dotMc.graphics.drawEllipse(0,0,5,5);
			m_dotMc.graphics.endFill();
			
			
			
			
			
			
			m_tf = new TextField();
			m_tf.x = 10;
			m_tf.y = 10;
			m_tf.width = 85;
			m_tf.height = 87
			m_tf.multiline = true;
			m_tf.selectable = false;
			m_tf.defaultTextFormat = tformat;
			m_tf.wordWrap = true;
			m_tf.embedFonts = true;
			
			
			addChild(m_mc);
			
		}
		
		public function Clear():void
		{
			for each(var mc:MovieClip in m_avatarsInRoom)
			{
				removeChild(mc);
			}
			
			m_avatarsInRoom.splice(0,m_avatarsInRoom.length);
		}
		
		public function RemoveId(id:Number):void
		{
			
			removeChild(m_avatarsInRoom[id]);
			delete m_avatarsInRoom[id];
		}
		
		public function Update(id:Number, xp:Number, yp:Number, human:Boolean=true, objectp:Boolean=false)
		{
			if (!(id in m_avatarsInRoom))
			{
				var mcdot:MovieClip = new MovieClip();
				
				
				if(human)
				mcdot.graphics.beginFill(0xFF0000, 1.0);
				else
				mcdot.graphics.beginFill(0x00FF00, 1.0);
				
				if(objectp)
				mcdot.graphics.beginFill(0x0000FF, 1.0);
				
				mcdot.graphics.drawEllipse(-2.5,-2.5,5,5);
				mcdot.graphics.endFill();
				
				
				m_avatarsInRoom[id] = mcdot;
				
				
				
				addChild(m_avatarsInRoom[id]);
			}
			
			m_avatarsInRoom[id].x = (xp/760)*80;
			m_avatarsInRoom[id].y = (yp/600)*80;
		}
	}
	
	
}