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
	
	public class Avatar extends MovieClip
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
		public var m_avatarTypeIndex:Number;
		public var m_score:Number;
		public var m_connection:Connection;
		public var m_buttons:Array = [];
		public var m_health;
		
		public var m_buttonXTween:Tween;
		public var m_buttonYTween:Tween;
		public var m_buttonAlphaTween:Tween;
		
		public static const BUTTON_SHOWING:Number = 0;
		public static const BUTTON_NOTSHOWING:Number = 1;
		public static const BUTTON_UNAVAILABLE:Number = 2;
		
		public var m_buttonsState:Number;
		public var m_buttonsTimer;
		
		public var m_anotherUserId:Number; // User interacting with this avatar
		
		public var m_challengeSpeechBubble:ChallengeSpeechBubble_mc;
		public var m_acceptButton:AcceptButton_mc;
		public var m_declineButton:DeclineButton_mc;
		
		public function Avatar(idp:Number,namep:String,availablep:Boolean,conp:Connection)
		{
			m_id = idp;
			m_name = namep;
			m_available = availablep;
			m_worldX = 0;
			m_worldY = 0;
			m_cameraX = 0;
			m_cameraY = 0;
			m_avatarTypeIndex = 0;
			m_score = 0;
			m_health = 100;
			
			m_connection = conp;
			
			
			var m_fightButton:FightButton_mc = new FightButton_mc();
			
			m_fightButton.x = 0;
			m_fightButton.y = -30;
			m_fightButton.alpha = 0;
			m_fightButton.visible = false;
			m_fightButton.name = "fightButton";
			
			m_buttons.push(m_fightButton);
			
			m_buttonsState = BUTTON_NOTSHOWING;
			
			
			m_challengeSpeechBubble = new ChallengeSpeechBubble_mc();
			m_challengeSpeechBubble.alpha = 0;
			m_challengeSpeechBubble.visible = false;
			
			m_acceptButton = new AcceptButton_mc();
			m_acceptButton.alpha = 0;
			m_acceptButton.visible = false;
			m_acceptButton.name = "acceptButton";
			
			m_declineButton = new DeclineButton_mc();
			m_declineButton.alpha = 0;
			m_declineButton.visible = false;
			m_declineButton.name = "declineButton";
		}
		
		public function AttachMc(mc:MovieClip)
		{
			m_mc = mc;
			addChild(m_mc);
			
			m_mc.addChild(m_buttons[0]);
			
			m_mc.addChild(m_challengeSpeechBubble); // = new ChallengeSpeechBubble_mc();
			m_mc.addChild(m_acceptButton); // = new AcceptButton_mc();
			m_mc.addChild(m_declineButton); // = new DeclineButton_mc();
		}
		
		public function TweenTo(mc:MovieClip,xp:Number,yp:Number,alphap:Number,callback:Function):void
		{
			m_buttonXTween = new Tween(mc,"x",Regular.easeOut,mc.x,mc.x + xp,0.5,true);
			m_buttonYTween = new Tween(mc,"y",Regular.easeOut,mc.y,mc.y + yp,0.5,true);			
			m_buttonAlphaTween = new Tween(mc,"alpha",Regular.easeOut,mc.alpha,alphap,0.5,true);
			
			m_buttonAlphaTween.addEventListener(TweenEvent.MOTION_FINISH, callback);
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
		
		
		
		public function OnMouseDownButton(event:MouseEvent):void
		{
			
			if (event.target.name == "fightButton")
			{
				m_connection.send("sendMsgToUser","fightAction",m_id,m_anotherUserId);
				CloseButtons(new TimerEvent("0"));
			}
			
			else if (event.target.name == "declineButton")
			{
				CloseQuestion();
			}
			
			else if (event.target.name == "acceptButton")
			{
				CloseQuestion();
				m_connection.send("sendMsgToUser","initiateFight",m_anotherUserId,m_id);
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
		
		
		
		public function SetScore(score:Number):void
		{
			m_score = score;
		}
		
		public function GetScore():Number
		{
			return m_score;
		}
		
		public function AddScore(score:Number):void
		{
			m_score += score;
		}
		
		public function UpdateCollisionShape():void
		{
			m_pTopLeft = new Point(m_worldX - 10,m_worldY - 10);
			m_pBottomLeft = new Point(m_worldX - 10,m_worldY + 10);
			m_pBottomRight = new Point(m_worldX + 10,m_worldY + 10);
			m_pTopRight = new Point(m_worldX + 10,m_worldY - 10);
		}
		
		public function OnMouseDown(charX:Number, charY:Number, user:Avatar, nameEntityClicked:String):void
		{
			if (user.m_id == m_id)
			return;
			
			
			m_anotherUserId = user.m_id;
			
			
			
			if ( (Math.abs(charX - m_worldX) < 100) && Math.abs(charY - m_worldY) < 100 )
			{
				if (m_buttonsState == BUTTON_NOTSHOWING)
				ShowButtons(true);
			}
		}
		
		public function ShowButtons(usedByMe:Boolean):void
		{
			if (m_buttonsState == BUTTON_UNAVAILABLE)
			return;
			
			m_buttonsState = BUTTON_UNAVAILABLE;
			
			m_buttons[0].gotoAndStop(0);
			m_buttons[0].visible = true;
			TweenTo(m_buttons[0],-55,-60,1.0,function()
			{
				m_buttonsTimer = new Timer(5000,1);
				m_buttonsTimer.addEventListener(TimerEvent.TIMER_COMPLETE,CloseButtons);
				m_buttonsTimer.start();
				
				m_buttonsState = BUTTON_SHOWING;
							
							
				if (usedByMe)
				AddButtonListeners(m_buttons[0]);
							
			});
		}
		
		public function CloseButtons(event:TimerEvent):void
		{
			if (m_buttonsState == BUTTON_UNAVAILABLE)
			return;
			
			m_buttonsState = BUTTON_UNAVAILABLE;
			
			RemoveButtonListeners(m_buttons[0]);
			m_buttons[0].gotoAndStop(0);
			
			m_buttonsTimer.stop();
			m_buttonsTimer = null;
			
			TweenTo(m_buttons[0],55,60,0.0,function()
			{
				m_buttons[0].visible = false;
				m_buttonsState = BUTTON_NOTSHOWING;
						
			});
		}
		
		public function AskForFight(opponentId:Number):void
		{
			
			m_anotherUserId = opponentId;
			
			
			
			m_challengeSpeechBubble.gotoAndStop(0);
			m_challengeSpeechBubble.visible = true;
			TweenTo(m_challengeSpeechBubble,0,-150,1.0,function()
			{
							
			});
			
			
			m_acceptButton.gotoAndStop(0);
			m_acceptButton.visible = true;
			TweenTo(m_acceptButton,-40,-100,1.0,function()
			{
				AddButtonListeners(m_acceptButton);
							
			});
			
			
			m_declineButton.gotoAndStop(0);
			m_declineButton.visible = true;
			TweenTo(m_declineButton,40,-100,1.0,function()
			{
				AddButtonListeners(m_declineButton);
			});
		}
		
		public function CloseQuestion():void
		{
			
			TweenTo(m_challengeSpeechBubble,0,150,0.0,function()
			{
			
			});
			
			RemoveButtonListeners(m_acceptButton);
			TweenTo(m_acceptButton,40,100,0.0,function()
			{
			
			});
			
			RemoveButtonListeners(m_declineButton);
			TweenTo(m_declineButton,-40,100,0.0,function()
			{
			
				AddButtonListeners(m_declineButton);
			});
		}
		
	}
	
}