﻿package {
	import flash.display.MovieClip
	import flash.display.Sprite
	import flash.display.Bitmap
	import flash.display.BitmapData
	import flash.display.Graphics
	import flash.events.Event
	import flash.events.MouseEvent
	import flash.utils.setInterval
	import flash.utils.setTimeout
	import flash.geom.Point
	import flash.text.TextField
	import flash.display.BlendMode
	import flash.display.StageScaleMode
	import flash.display.StageAlign
	import flash.text.TextFormat
	
	import playerio.*
	import sample.ui.Prompt
	import sample.ui.Chat
	
	public class DrawPad extends MovieClip{
		private var bmd:BitmapData
		private var bm:Bitmap
		private var tempCanvas:Sprite
		private var tempGrapichs:Graphics
		private var isInDraw:Boolean = false
		private var connection:Connection
		private var lines:Object = {}
		
		function DrawPad(){
			stop();
			
			new Prompt(stage, "What's your name?", "Guest-" + (Math.random()*9999<<0), function(name:String){
				PlayerIO.connect(
					stage,								//Referance to stage
					"[Enter your game id here]",		//Game id (Get your own at playerio.com. 1: Create user, 2:Goto admin pannel, 3:Create game, 4: Copy game id inside the "")
					"public",							//Connection id, default is public
					name,								//Username
					"",									//User auth. Can be left blank if authentication is disabled on connection
					handleConnect,						//Function executed on successful connect
					handleError							//Function executed if we recive an error
				);   
			})

			stage.scaleMode = StageScaleMode.NO_SCALE
			stage.align = StageAlign.TOP_LEFT
		}
		
		private function handleConnect(client:Client):void{
			trace("Sucessfully connected to player.io");
			
			//Set developmentsever (Comment out to connect to your server online)
			client.multiplayer.developmentServer = "127.0.0.1:8184";
			
			//Create pr join the room test
			client.multiplayer.createJoinRoom(
				"drawpad",							//Room id. If set to null a random roomid is used
				"DrawPad",							//The game type started on the server
				true,								//Should the room be visible in the lobby?
				{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
				{},									//User join data
				handleJoin,							//Function executed on successful joining of the room
				handleError							//Function executed if we got a join error
			);
		}
		
		
		private function handleJoin(connection:Connection):void{
			trace("Sucessfully connected to the multiplayer server");
			gotoAndStop(2);
		
			//Add chat to game
			var chat:Chat = new Chat(stage, connection);
		
			//Create bitmap object
			bmd = new BitmapData(2000,2000,false,0x111111);
			bm = new Bitmap(bmd);
			addChild(bm);
			
			//Create sprite we use as a shortcut to draw lines
			tempCanvas = new Sprite();
			tempGrapichs = tempCanvas.graphics
			addChild(tempCanvas)
			
			//Inits the fade system
			setInterval(fade, 200)
			
			//Attach events
			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown)
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp)
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove)
			
			//Store a local referance to connection
			this.connection = connection;

			connection.addMessageHandler("start", function(m:Message, userid:String, username:String, x:int, y:int){
				//Show who is drawing
				var nameLabel:TextField = new TextField()
				
				//Add a bit of formatting
				var textFormat:TextFormat = new TextFormat();
				textFormat.color = 0xffffff;
				textFormat.font = "Arial"
				
				nameLabel.defaultTextFormat = textFormat
				
				nameLabel.text = username;
				nameLabel.selectable = false
				nameLabel.x = x - nameLabel.textWidth/2
				nameLabel.y = y - nameLabel.textHeight/2
				addChild(nameLabel)
				
				//Destory the name after 500ms
				setTimeout(function(){
					removeChild(nameLabel) 
				},500)
				
				lines[userid] = new Point(x, y)																
			})
			
			connection.addMessageHandler("stop", function(m:Message, userid:String){
				delete lines[userid]
			})
			
			connection.addMessageHandler("move", function(m:Message, userid:String, x:int, y:int){
				if(lines[userid]){
					var newPoint:Point = new Point(x,y)
					drawLine(lines[userid], newPoint)
					lines[userid] = newPoint
				}
			})
			
		}
		
		private function handleMouseDown(e:Event){
			isInDraw = true
			connection.send("start", mouseX, mouseY)
		}
		
		private function handleMouseUp(e:Event){
			isInDraw = false
			connection.send("stop")
		}
		
		private function handleMouseMove(e:Event){
			if(isInDraw){
				connection.send("move", mouseX, mouseY)
			}
		}
		
		private function drawLine(p1:Point, p2:Point){
			tempGrapichs.lineStyle(0,0xffffff,1);
			tempGrapichs.moveTo(p1.x, p1.y)
			tempGrapichs.lineTo(p2.x, p2.y)
			bmd.draw(tempCanvas)
			tempGrapichs.clear()
		}
		
		private function fade(){
			tempGrapichs.lineStyle(0,0x111111,0)
			tempGrapichs.beginFill(0x111111, .1)
			tempGrapichs.drawRect(0,0,2000,2000)
			bmd.draw(tempCanvas,null,null) //Blendmode nessesary to actually make it fade!
			tempGrapichs.clear()
		}
		
		private function handleMessages(m:Message){
			trace("Recived the message", m)
		}
		
		private function handleDisconnect():void{
			trace("Disconnected from server")
		}
		
		private function handleError(error:PlayerIOError):void{
			trace("Got", error)
			gotoAndStop(3);

		}
	}	
}