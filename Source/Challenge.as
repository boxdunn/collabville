package {
	import flash.display.MovieClip
	import flash.text.TextField
	import flash.events.Event
	import flash.events.MouseEvent
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFormat;
	import flash.geom.Point;
	import playerio.Connection;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.events.*;
	import flash.accessibility.Accessibility;
	import flash.text.TextField;
	import flash.text.Font;
	
	public class Challenge extends MovieClip
	{
		public var m_av1:Avatar;
		public var m_av2:Avatar;
		public var m_connection:Connection;
		public var m_back:BackChallenge_mc;
		
		public var m_attackButton:AttackButton_mc;
		public var m_escapeButton:EscapeButton_mc;
		
		public var m_scoreAv1TextField:TextField;
		public var m_scoreAv2TextField:TextField;
		public var m_playerTurnTextField:TextField;
		public var m_myTurn:Boolean;
		
		public function Challenge(a1:Avatar,a2:Avatar,myTurn:Boolean,connection:Connection):void
		{
			m_av1 = a1;
			m_av2 = a2;
			m_connection = connection;
			
			m_back = new BackChallenge_mc();
			m_attackButton = new AttackButton_mc();
			m_escapeButton = new EscapeButton_mc();
			
			
			var myfont:Font = new Font1();
			var tformat:TextFormat = new TextFormat();
			tformat.font = myfont.fontName;
			tformat.size = 25;
			tformat.color = 0x003366;
			
			m_scoreAv1TextField = new TextField();
			m_scoreAv1TextField.x = 50;
			m_scoreAv1TextField.y = 15;
			m_scoreAv1TextField.width = 50;
			m_scoreAv1TextField.height = 30
			//m_scoreAv1TextField.border = true;
			m_scoreAv1TextField.multiline = false;
			m_scoreAv1TextField.selectable = false;
			m_scoreAv1TextField.defaultTextFormat = tformat;
			//m_scoreAv1TextField.autoSize = TextFieldAutoSize.CENTER;
			m_scoreAv1TextField.wordWrap = true;
			m_scoreAv1TextField.embedFonts = true;
			m_scoreAv1TextField.text = String(m_av1.m_health);//"AAAAAAAAAAAAAA\nAAAAAAAAAAAAAA\nAAAAAAAAAAAAAA\nAAAAAAAAAAAAAA\nAAAAABBBBBBBBB\nBBBBBBB";
			
			
			
			m_scoreAv2TextField = new TextField();
			m_scoreAv2TextField.x = 710;
			m_scoreAv2TextField.y = 15;
			m_scoreAv2TextField.width = 150;
			m_scoreAv2TextField.height = 30
			//m_scoreAv2TextField.border = true;
			m_scoreAv2TextField.multiline = false;
			m_scoreAv2TextField.selectable = false;
			m_scoreAv2TextField.defaultTextFormat = tformat;
			//m_scoreAv2TextField.autoSize = TextFieldAutoSize.CENTER;
			m_scoreAv2TextField.wordWrap = true;
			m_scoreAv2TextField.embedFonts = true;
			m_scoreAv2TextField.text = String(m_av2.m_health);//"AAAAAAAAAAAAAA\nAAAAAAAAAAAAAA\nAAAAAAAAAAAAAA\nAAAAAAAAAAAAAA\nAAAAABBBBBBBBB\nBBBBBBB";
			
			
			
			m_playerTurnTextField = new TextField();
			m_playerTurnTextField.x = 310;
			m_playerTurnTextField.y = 500;
			m_playerTurnTextField.width = 150;
			m_playerTurnTextField.height = 30
			//m_scoreAv2TextField.border = true;
			m_playerTurnTextField.multiline = false;
			m_playerTurnTextField.selectable = false;
			m_playerTurnTextField.defaultTextFormat = tformat;
			//m_playerTurnTextField.autoSize = TextFieldAutoSize.CENTER;
			m_playerTurnTextField.wordWrap = true;
			m_playerTurnTextField.embedFonts = true;
			m_playerTurnTextField.text = "NOTHING";
			
			m_myTurn = myTurn;
			
			if (myTurn)
			m_playerTurnTextField.text = "Your Turn!";//"AAAAAAAAAAAAAA\nAAAAAAAAAAAAAA\nAAAAAAAAAAAAAA\nAAAAAAAAAAAAAA\nAAAAABBBBBBBBB\nBBBBBBB";
			else
			m_playerTurnTextField.text = "Opponent's turn";
			
			
		}
		
		public function Init():void
		{
			addChild(m_back);
			
			addChild(m_scoreAv1TextField);
			addChild(m_scoreAv2TextField);
			addChild(m_playerTurnTextField);
			
			addChild(m_av1);
			m_av1.x = 50;
			m_av1.y = 300;
			
			addChild(m_av2);
			m_av2.x = 710;
			m_av2.y = 300;
			
			addChild(m_attackButton);
			m_attackButton.x = 100;
			m_attackButton.y = 550;
			m_attackButton.name = "attackButton";
			
			addChild(m_escapeButton);
			m_escapeButton.x = 650;
			m_escapeButton.y = 550;
			m_escapeButton.name = "escapeButton";
			
			AddButtonListeners(m_attackButton);
			AddButtonListeners(m_escapeButton);
		}
		
		public function AddButtonListeners(mc:MovieClip):void
		{
			mc.addEventListener(MouseEvent.MOUSE_DOWN,OnMouseDownButton);
			mc.addEventListener(MouseEvent.MOUSE_OVER,OnMouseOverButton);
			mc.addEventListener(MouseEvent.MOUSE_OUT,OnMouseOutButton);
		}
		
		public function RemoveButtonListeners(mc:MovieClip):void
		{
			mc.removeEventListener(MouseEvent.MOUSE_DOWN,OnMouseDownButton);
			mc.removeEventListener(MouseEvent.MOUSE_OVER,OnMouseOverButton);
			mc.removeEventListener(MouseEvent.MOUSE_OUT,OnMouseOutButton);
		}
		
		public function NextTurn():void
		{
			m_myTurn = !m_myTurn;
			
			if (m_myTurn)
			m_playerTurnTextField.text = "Your Turn!";//"AAAAAAAAAAAAAA\nAAAAAAAAAAAAAA\nAAAAAAAAAAAAAA\nAAAAAAAAAAAAAA\nAAAAABBBBBBBBB\nBBBBBBB";
			else
			m_playerTurnTextField.text = "Opponent's turn";
			
			
			m_scoreAv1TextField.text = String(m_av1.m_health);
			m_scoreAv2TextField.text = String(m_av2.m_health);
		}
		
		public function OnMouseDownButton(event:MouseEvent):void
		{
			if (event.target.name == "attackButton")
			{
				if (m_myTurn)
				{
					var chance:Number = Math.ceil(Math.random()*4);
					
					if (chance == 2)
					{
						var dmg:Number = Math.floor(Math.random()*10);
						m_av2.m_health -= dmg;
					}
						
						if (m_av2.m_health > 20)
						{
							NextTurn();
							m_connection.send("sendMsgToUser","attack",m_av2.m_id,m_av2.m_health);
						}
						else
						m_connection.send("sendMsgToUser","finishFight",m_av2.m_id,m_av1.m_id);
					
				}
			}
			else if (event.target.name == "escapeButton")
			{
				m_connection.send("sendMsgToUser","finishFight",m_av2.m_id,m_av1.m_id);
			}
		}
		
		public function OnMouseOverButton(event:MouseEvent):void
		{
			event.currentTarget.gotoAndStop(2);
		}
		
		public function OnMouseOutButton(event:MouseEvent):void
		{
			event.currentTarget.gotoAndStop(0);
		}
		
	}
}