﻿package {
	import flash.display.MovieClip
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.StageScaleMode
	import flash.display.StageAlign
	import flash.events.Event
	import playerio.*
	public class FridgeMagnets extends MovieClip{
		private var connection:Connection;
		private var texts:Array = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!?\/()-:.<>".split("")
		private var cursors:Object = []
		private var letters:Array = [];
		private var myId:int
		private var offsetWidth:Number = 0;
		private var offsetHeight:Number = 0;
		private var lcOffset:Number =0
		private var colors:Array = [
			0x333399,
			0x339933,
			0x993333,
			0x999933,
			0x339999,
			0x993399
		]
		
		function FridgeMagnets(){
			stop();
			PlayerIO.connect(
				stage,								//Referance to stage
				"[Enter your game id here]",		//Game id (Get your own at playerio.com. 1: Create user, 2:Goto admin pannel, 3:Create game, 4: Copy game id inside the "")
				"public",							//Connection id, default is public
				"GuestUser",						//Username
				"",									//User auth. Can be left blank if authentication is disabled on connection
				handleConnect,						//Function executed on successful connect
				handleError							//Function executed if we recive an error
			);   

			stage.scaleMode = StageScaleMode.NO_SCALE
			stage.align = StageAlign.TOP_LEFT
		}
		
		private function handleConnect(client:Client):void{
			trace("Sucessfully connected to player.io");
			
			//Set developmentsever (Comment out to connect to your server online)
			client.multiplayer.developmentServer = "127.0.0.1:8184";
			
			//Create pr join the room test
			client.multiplayer.createJoinRoom(
				"fridgemagnets",					//Room id. If set to null a random roomid is used
				"FridgeMagnets",					//The game type started on the server
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
			
			//Handle init message
			connection.addMessageHandler("init", function(m:Message, myid:int){
				//Set my id so we know who we are
				myId = myid
				
				//Create letters
				for( var a:int=1;a<m.length;a+=2){
					
					var ox:Number = letters.length%texts.length
					
					//Create letter
					var letter:Letter = new Letter(
						letters.length,
						texts[ox],
						colors[lcOffset%colors.length]
					);
					
					//Move leter to init position recived from server
					letter.x = m.getInt(a)
					letter.y = m.getInt(a+1)
					
					//If letter have never been moved. Move letter to initial position
					if(letter.x == -1){
						letter.x = offsetWidth
						letter.y = offsetHeight
					}
					
					offsetWidth += letter.width-.4

					if(ox==texts.length-1){
						offsetHeight += 25
						offsetWidth = 0
						lcOffset++
					}
					
					//Add listener dispatched when a letter is moved
					letter.addEventListener(Event.CHANGE, function(e:Event){
						var target:Letter = e.target as Letter;
						
						//Inform server that the letter where moved
						connection.send("move",target.Id, Math.round( target.x ), Math.round( target.y ))
					})
					
					//Add listener dispatched when a letter enters startdrag
					letter.addEventListener(Event.SELECT, function(e:Event){
						var target:Letter = e.target as Letter;
						
						//Inform the server that we are now dragging the letter
						connection.send("activate",target.Id)
					})
					
					//Add letter to letter array
					letters.push(letter)
					
					//Add letter to stage
					addChild(letter)
				}														   
			})
			
			connection.addMessageHandler("move", function(m:Message, id:int, x:int, y:int){
				//Move letter to new position using a tween.
				var l:Letter = letters[id];
				var lx:Tween = new Tween(l, "x", None.easeOut, l.x, x, 0.1, true);
				var ly:Tween = new Tween(l, "y", None.easeOut, l.y, y, 0.1, true);
				
				//Detatch letter from cursor
				for each( var c:Arrow in cursors){
					if(c.Attached == l){
						c.Attached = null;
					}
				}														   
			})
			
			connection.addMessageHandler("left", function(m:Message, id:int){
				//Remove cursor of player that just left the game
				if(cursors[id]){
					removeChild(cursors[id])
					delete cursors[id]
				}																	
			})
			
			connection.addMessageHandler("activate", function(m:Message, userid:int, letterid:int){
				var who:Arrow = cursors[userid];
				if(who){
					who.Attached =  letters[letterid];
				}																		
			})
			
			connection.addMessageHandler("update", function(m:Message){
				//Update letters and cursors
				for(var a:int=0;a<m.length;a+=3){
					var id:Number = m.getInt(a)
					if(id != myId){
						if(!cursors[id]){
							var arr:Arrow = new Arrow(colors[id%colors.length])
							cursors[id] = arr
							addChild(arr)
						}
						
						var elm:Arrow = cursors[id]
						var xtween:Tween = new Tween(elm, "x", None.easeOut, elm.x, m.getInt(a+1), 0.09, true);
						var ytween:Tween = new Tween(elm, "y", None.easeOut, elm.y, m.getInt(a+2), 0.09, true);
						
						if(elm.Attached != null && myId != id){
							var lxtween:Tween = new Tween(elm.Attached, "x", None.easeOut, elm.Attached.x, m.getInt(a+1)-elm.Attached.width/2, 0.09, true);
							var lytween:Tween = new Tween(elm.Attached, "y", None.easeOut, elm.Attached.y, m.getInt(a+2)-elm.Attached.height/2, 0.09, true);
						}
					}
				}
				
				var nx:Number = Math.round( mouseX ) 
				var ny:Number = Math.round( mouseY )
				connection.send("mouse", Math.min( Math.max( nx,0),650)||0, Math.min( Math.max( ny,0),650)||0)
			})
			
		}
		
		private function handleMessages(m:Message){
			trace("Recived the message", m)
		}
		
		private function handleDisconnect():void{
			trace("Disconnected from server")
		}
		
		private function handleError(error:PlayerIOError):void{
			trace("Got", error);
			gotoAndStop(3);

		}
	}	
}
