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
	import sample.ui.Lobby
	
	public class TicTacToe extends MovieClip{
		private var connection:Connection
		private var tiles:Array = [];
		private var hasTurn:Boolean = false
		private var isInited:Boolean = false
		private var infoBox:InfoBox
		private var imPlayer:Number;
		private var isSpectator:Boolean = false
		private var lobby:Lobby
		
		
		function TicTacToe(){
			stop();
			
			new Prompt(stage, "What's your name?", "Guest-" + (Math.random()*9999<<0), function(name:String){
				PlayerIO.connect(
					stage,								//Referance to stage
					"[Insert your id here]",			//Game id (Get your own at playerio.com. 1: Create user, 2:Goto admin pannel, 3:Create game, 4: Copy game id inside the "")
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
			
			//Create lobby
			lobby = new Lobby(client, "TicTacToe", handleJoin, handleError)
			
			//Show lobby (parsing true hides the cancel button)
			lobby.show(true);
			
			gotoAndStop(2);
		
			
		}
		
		
		private function handleJoin(connection:Connection):void{
			trace("Sucessfully connected to the multiplayer server");
			
			showTurn.stop();
			
			infoBox = new InfoBox(resetGame,joinGame);
			addChild(infoBox)
			
			for( var a:int=0;a<3;a++){
				tiles[a] = [];
				for( var b:int=0;b<3;b++){
					var tile:Tile = new Tile(b,a);
					tile.addEventListener(MouseEvent.CLICK,handleClick)
					brickContainer.addChild(tile)
					tiles[a][b] = tile
				}
			}
			
			setTurn(false)
			spectating.visible = false
			infoBox.Show("waiting");						
			
			
			this.connection = connection;

			//Add chat to game
			var chat:Chat = new Chat(stage, connection);			
			
			connection.addMessageHandler("init", function(m:Message, iAm:int, name:String){
				isSpectator = false
				spectating.visible = false
				imPlayer = iAm;
				(imPlayer == 0 ? player1 : player2).text  = name;  
			})
			
			
			connection.addMessageHandler("join", function(m:Message, p1name:String, p2name:String){
				player1.text = p1name;
				player2.text = p2name;
			})
			
			connection.addMessageHandler("full", function(m:Message){
				infoBox.Show("full");
			})

			connection.addMessageHandler("reset", function(m:Message, turn:int){
				infoBox.Hide();
				setTurn(turn == imPlayer, true);
			})
			
			connection.addMessageHandler("left", function(m:Message, p1name:String, p2name:String){
				infoBox.Show("waiting",isSpectator ? "ok" : "");
				player1.text = p1name;
				player2.text = p2name;
				setTurn(false)
			})
			
			connection.addMessageHandler("place", function(m:Message, y:int, x:int, state:String, turn:int){
				tiles[x][y].SetState(state)
				setTurn(turn == imPlayer)
			})

			connection.addMessageHandler("win", function(m:Message, winner:int, winnerName:String){
				if(isSpectator){
					infoBox.Show("showWinner",winnerName); 
				}else{
					infoBox.Show(winner == imPlayer ? "won" : "lost");
				}
				setTurn(false)
			})
				
			connection.addMessageHandler("tie", function(m:Message){
				infoBox.Show("tie", isSpectator ? "" : "go");
				setTurn(false)
			})

			
			connection.addMessageHandler("spectator", function(m:Message, p1name:String, p2name:String){
				isSpectator = true
				player1.text = p1name;
				player2.text = p2name;
				
				var xo:int = 0;
				for( var a:int=2;a<m.length;a++){
					var yo:int = (a-2)%3;
					tiles[xo][yo].SetState(m.getString(a));
					if(yo == 2)xo++ 
				}
				
				spectating.visible = true;
				infoBox.Hide();
			})
			
		}
	
		private function resetGame():void{
			connection.send("reset");
			infoBox.Show("waiting");
		}
		
		private function joinGame():void{
			trace("send join")
			connection.send("join");
			infoBox.Show("waiting");
		}		
		
		
		private function handleClick(e:MouseEvent):void{
			var tile:Tile = e.target as Tile
			if(hasTurn){
				connection.send("click", tile.XPosition, tile.YPosition)
			}
		}

		private function setTurn(turn:Boolean, clear:Boolean = false):void{
			hasTurn = turn
			
			showTurn.gotoAndStop( imPlayer == 0 ? turn ? 1 : 2 : turn ? 2 : 1 );
			
			for( var a:int=0;a<3;a++){
				for( var b:int=0;b<3;b++){
					tiles[a][b].enabled = hasTurn
					if(clear)tiles[a][b].SetState("blank")
				}
			}
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