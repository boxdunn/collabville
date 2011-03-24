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
	
	public class SpeechBubble extends MovieClip
	{
		public var m_id:Number;
		public var m_tf:TextField;
		public var m_text:String;
		public var m_mc:MovieClip;
		public var m_corners:Array = [];
		public var m_mcTween:Tween;
		
		
		public function SpeechBubble(idp:Number,textp:String)
		{
			m_id = idp;
			m_text = textp;
			
			var myfont:Font = new Font1();
			var tformat:TextFormat = new TextFormat();
			tformat.font = myfont.fontName;
			tformat.size = 12;
			
			var textSizePixelsX:Number = (textp.length * 7 > 85) ? 85 : textp.length * 7 + 5;
			var textSizePixelsY:Number = ((textp.length * 7)/85)*20 + 20;
			var numberHorizontalPieces:Number = Math.floor((textSizePixelsX / 21));
			var heightOfText:Number = ((textp.length * 7)/85)*20 + 30;
			/*
			m_corners[0] = new SpeechBubbleCornerLeft_mc();
			m_corners[0].x = 0;
			m_corners[0].y = -110;
			
			m_corners[1] = new SpeechBubbleCornerRight_mc();
			//m_corners[1].scaleX = -1.0;
			m_corners[1].x = 21 + numberHorizontalPieces*21; 
			m_corners[1].y = -110;
			//m_corners[2] = new SpeechBubbleCorner_mc();
			
			m_mc = new MovieClip();
			m_mc.addChild(m_corners[0]);
			for (var h:Number = 1; h<=numberHorizontalPieces; h++)
			{
				var horizontalPiece:SpeechBubbleHorizontal_mc = new SpeechBubbleHorizontal_mc();
				horizontalPiece.x = 21*h;
				horizontalPiece.y = -110;
				m_mc.addChild(horizontalPiece);
			}
			
			m_mc.addChild(m_corners[1]);
			*/
			
			m_mc = new MovieClip();
			m_mc.graphics.beginFill(0xFFFFFF, 0.8);
			m_mc.graphics.drawRoundRect(7,-heightOfText,textSizePixelsX,textSizePixelsY,10,10);
			m_mc.graphics.endFill();
			
			//addChild(m_corners[2]);
			
			
			
			m_tf = new TextField();
			m_tf.x = 10;
			m_tf.y = -heightOfText;
			m_tf.width = 85;
			m_tf.height = 87
			m_tf.multiline = true;
			m_tf.selectable = false;
			m_tf.defaultTextFormat = tformat;
			m_tf.wordWrap = true;
			m_tf.embedFonts = true;
			m_tf.text = textp;
			m_mc.addChild(m_tf);
			
			
			// Add the whole speech bubble composed of individual movieclips
			addChild(m_mc);
			
			m_mcTween = new Tween(m_mc,"alpha", Strong.easeIn, 1, 0, 3, true);
			
		}
	}
	
	
}