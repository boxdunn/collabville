package {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.Font;
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
	
	public class ChestEntity extends MovieClip implements IGameEntity
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
		public var m_stars:Array = [];
		public var m_connection:Connection;
		
		public static const CLOSED:Number = 0;
		public static const OPENED:Number = 1;
		public static const UNAVAILABLE:Number = 2;
		
		public var m_starXTween:Tween;
		public var m_starYTween:Tween;
		public var m_starAlphaTween:Tween;
		
		public var m_tween:Tween;
		public var m_state:Number;
		
		
		public var m_finalMessage:SpeechBubble_mc;
		public var m_finalMessageTextField:TextField;
		public var m_myfont:Font;
		public var m_tformat:TextFormat;
		
		
		public var m_user:Avatar;
		public var m_finalMessageDisplaying:Boolean;
		public var m_finalMessageTweenAlpha:Tween;
		
		
		
		
		public function ChestEntity(idp:Number,namep:String,availablep:Boolean,conp:Connection)
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
			m_finalMessageDisplaying = false;
			
			
			m_myfont = new Font1();
				
			m_tformat = new TextFormat();
			m_tformat.font = m_myfont.fontName;
			m_tformat.size = 18;
				
			m_finalMessageTextField = new TextField();
			m_finalMessageTextField.x = 10;
			m_finalMessageTextField.y = -90;
			m_finalMessageTextField.width = 85;
			m_finalMessageTextField.height = 87
			m_finalMessageTextField.multiline = true;
			m_finalMessageTextField.selectable = false;
			m_finalMessageTextField.defaultTextFormat = m_tformat;
			m_finalMessageTextField.wordWrap = true;
			m_finalMessageTextField.embedFonts = true;
			m_finalMessageTextField.text = "null";
			
			var m_star0:StarChest_mc = new StarChest_mc();
			m_star0.x = 0;
			m_star0.y = -30;
			m_star0.alpha = 0;
			m_star0.visible = false;
			m_star0.name = "star0";
			
			
			var m_star1:StarChest_mc = new StarChest_mc();
			m_star1.x = 0;
			m_star1.y = -30;
			m_star1.alpha = 0;
			m_star1.visible = false;
			m_star1.name = "star1";
			
			var m_star2:StarChest_mc = new StarChest_mc();
			m_star2.x = 0;
			m_star2.y = -30;
			m_star2.alpha = 0;
			m_star2.visible = false;
			m_star2.name = "star2";
			
			m_stars.push(m_star0);
			m_stars.push(m_star1);
			m_stars.push(m_star2);
			
			m_finalMessage = new SpeechBubble_mc();
			m_finalMessage.x = 0;
			m_finalMessage.y = 0;
			
			
		}
		
		public function GetName():String
		{
			return m_name;
		}
		
		public function GetId():Number
		{
			return m_id;
		}
		
		public function GetWorldX():Number
		{
			return m_worldX;
		}
		
		public function GetWorldY():Number
		{
			return m_worldY;
		}
		
		public function SetConnection(connectionp:Connection):void
		{
			m_connection = connectionp;
		}
		
		public function AttachMc(mc:MovieClip):void
		{
			m_mc = mc;
			addChild(m_mc);
			
			m_mc.addChild(m_stars[0]);
			m_mc.addChild(m_stars[1]);
			m_mc.addChild(m_stars[2]);
			
		}
		
		public function GetMc():MovieClip
		{
			return m_mc;
		}
		
		public function OnMouseDown(charX:Number, charY:Number, user:Avatar, nameEntityClicked:String):void
		{
			if ( (Math.abs(charX - m_worldX) < 100) && Math.abs(charY - m_worldY) < 100 )
			{
				if (nameEntityClicked == "chestLid_mc" || nameEntityClicked == "chestBox_mc")
				{
					m_user = user;
					m_connection.send("useInteractiveEntity","chest");
				}
			}
			
		}
		
		public function AddStarListeners(mc:MovieClip):void
		{
			mc.addEventListener(MouseEvent.MOUSE_DOWN,OnMouseDownStar);
			mc.addEventListener(MouseEvent.MOUSE_OVER,OnMouseOverStar);
			mc.addEventListener(MouseEvent.MOUSE_OUT,OnMouseOutStar);
		}
		
		public function RemoveStarListeners(mc:MovieClip):void
		{
			mc.removeEventListener(MouseEvent.MOUSE_DOWN,OnMouseDownStar);
			mc.removeEventListener(MouseEvent.MOUSE_OVER,OnMouseOverStar);
			mc.removeEventListener(MouseEvent.MOUSE_OUT,OnMouseOutStar);
		}
		
		public function TweenTo(mc:MovieClip,xp:Number,yp:Number,alphap:Number,callback:Function):void
		{
			m_starXTween = new Tween(mc,"x",Regular.easeOut,mc.x,mc.x + xp,0.5,true);
			m_starYTween = new Tween(mc,"y",Regular.easeOut,mc.y,mc.y + yp,0.5,true);			
			m_starAlphaTween = new Tween(mc,"alpha",Regular.easeOut,mc.alpha,alphap,0.5,true);
			
			m_starAlphaTween.addEventListener(TweenEvent.MOTION_FINISH, callback);
		}
		
		public function AttachMessage(msg:String):void
		{
			
			m_finalMessageTextField.text = msg;
			
			m_finalMessage.alpha = 1.0;
			
			m_finalMessageTweenAlpha = new Tween(m_finalMessage,"alpha",Regular.easeIn,m_finalMessage.alpha,0,4.0,true);
			m_finalMessageTweenAlpha.addEventListener(TweenEvent.MOTION_FINISH, function()
			{
				m_mc.removeChild(m_finalMessage);
				
				m_finalMessageDisplaying = false;
				
				
				Use(true);
				
				
			});
			
			m_finalMessage.addChild(m_finalMessageTextField);
			m_mc.addChild(m_finalMessage);
		}
		
		public function OnMouseDownStar(event:MouseEvent):void
		{
			
			RemoveStarListeners(m_stars[0]);
			m_stars[0].gotoAndStop(0);
			RemoveStarListeners(m_stars[1]);
			m_stars[1].gotoAndStop(0);
			RemoveStarListeners(m_stars[2]);
			m_stars[2].gotoAndStop(0);
			
			var winnerIndex:Number =  Math.floor(Math.random()*3);
			var winnerName:String = "star"+winnerIndex;
			
			if (winnerName == event.target.name)
			{
				AttachMessage("Congrats ! you have won points.");
				m_connection.send("addScore",100);
			}
			else
			{
				AttachMessage("Sorry! You have lost points.");
				m_connection.send("subtractScore",100);
			}
			
			
			m_finalMessageDisplaying = true;
			m_connection.send("setInteractiveEntityAvailable","chest",false);
			
		}
		
		public function OnMouseOverStar(event:MouseEvent):void
		{
			event.currentTarget.gotoAndStop(2);
		}
		
		public function OnMouseOutStar(event:MouseEvent):void
		{
			event.currentTarget.gotoAndStop(0);
		}
		
		public function SetState(statep:Number):void
		{
			m_state = statep;
			
			switch(m_state)
			{
				case CLOSED:
				{
					
					
					break;
				}
				
				case OPENED:
				{
					
					m_mc.chestLid_mc.y = -78 - 50;
					
					
					m_stars[0].x = -55;
					m_stars[0].y = -30 - 60;
					m_stars[0].visible = true;
					m_stars[0].alpha = 1.0;
					
					m_stars[1].x = 0;
					m_stars[1].y = -30 - 60;
					m_stars[1].visible = true;
					m_stars[1].alpha = 1.0;
					
					m_stars[2].x = 55;
					m_stars[2].y = -30 - 60;
					m_stars[2].visible = true;
					m_stars[2].alpha = 1.0;
					
					break;
				}
			}
		}
		
		public function Use(usedByMe:Boolean):void
		{
			switch (m_state)
			{
				case CLOSED:
				{
					m_tween = new Tween(m_mc.chestLid_mc,"y", Regular.easeOut, m_mc.chestLid_mc.y, (m_mc.chestLid_mc.y-50),0.5,true);
					m_tween.addEventListener(TweenEvent.MOTION_FINISH, function()
					{
						
						m_stars[0].gotoAndStop(0);
						m_stars[0].visible = true;
						TweenTo(m_stars[0],-55,-60,1.0,function()
						{
							
							if (usedByMe)
							AddStarListeners(m_stars[0]);
							
						});
						
						m_stars[1].gotoAndStop(0);
						m_stars[1].visible = true;
						TweenTo(m_stars[1],0,-60,1.0,function()
						{
							
							if (usedByMe)
							AddStarListeners(m_stars[1]);
							
							
						});
						
						m_stars[2].gotoAndStop(0);
						m_stars[2].visible = true;
						TweenTo(m_stars[2],55,-60,1.0,function()
						{
							m_state = OPENED;
							
							
							if (usedByMe)
							AddStarListeners(m_stars[2]);
							
							if (usedByMe)
							m_connection.send("updateInteractiveEntity","chest",m_state);
							
							
						});
					
					})
					
					
					m_state = UNAVAILABLE;
					break;
				}
				
				case OPENED:
				{
					
					// Make sure users can't interact with object while it's closing
					RemoveStarListeners(m_stars[0]);
					m_stars[0].gotoAndStop(0);
					RemoveStarListeners(m_stars[1]);
					m_stars[1].gotoAndStop(0);
					RemoveStarListeners(m_stars[2]);
					m_stars[2].gotoAndStop(0);
					
					
					TweenTo(m_stars[0],55,60,0.0,function()
					{
						if (usedByMe)
						RemoveStarListeners(m_stars[0]);
						
						m_stars[0].visible = false;
						
					});
					
					
					TweenTo(m_stars[1],0, 60,0.0,function()
					{
						if (usedByMe)
						RemoveStarListeners(m_stars[1]);
						
						m_stars[1].visible = false;
							
					});
						
					TweenTo(m_stars[2],-55, 60,0.0,function()
					{
						if (usedByMe)
						RemoveStarListeners(m_stars[2]);
						
						m_stars[2].visible = false;
							
						
						m_tween = new Tween(m_mc.chestLid_mc,"y", Regular.easeOut, m_mc.chestLid_mc.y, (m_mc.chestLid_mc.y+50),0.5,true);
						m_tween.addEventListener(TweenEvent.MOTION_FINISH, function()
						{
							m_state = CLOSED;
						
							if (usedByMe)
							m_connection.send("updateInteractiveEntity","chest",m_state);
					
						})
							
					});
					
					m_state = UNAVAILABLE;
					break;
				}
				
				case UNAVAILABLE:
				{
					// Don't do anything since it's opening or closing
					break;
				}
			}
		}
		
		public function UpdateCollisionShape():void
		{
			m_pTopLeft = new Point(x - 10,y - 10);
			m_pBottomLeft = new Point(x - 10,y + 10);
			m_pBottomRight = new Point(x + 10,y + 10);
			m_pTopRight = new Point(x + 10,y - 10);
		}
		
		
	}
	
	
}