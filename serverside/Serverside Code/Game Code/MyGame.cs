using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using PlayerIO.GameLibrary;
using System.Drawing;

namespace MyGame {
	//Player class. each player that join the game will have these attributes.
	public class Player : BasePlayer {
        public uint row;
        public uint column;
        public String model;
        public String direction;
	}


    public class PlayerIOMessages : Object{
        public const String CHAT = "ChatMessage";
        public const String MOVE = "Move";
        public const String PLAYERS_LIST = "PlayersList";
        public const String PLAYER_LEFT = "PlayerLeft";
        public const String PLAYER_JOIN = "PlayerJoin";
    }

	[RoomType("MyGame")]
	public class GameCode : Game<Player> {
		// This method is called when an instance of your the game is created
		public override void GameStarted() {
			// anything you write to the Console will show up in the 
			// output window of the development server
			Console.WriteLine("Game is started");
		}

		// This method is called when the last player leaves the room, and it's closed down.
		public override void GameClosed() {
			Console.WriteLine("RoomId: " + RoomId);

            
		}

		// This method is called whenever a player joins the game
		public override void UserJoined(Player player) {

			Message m = Message.Create(PlayerIOMessages.PLAYERS_LIST);


            //init player with join data
            player.model = player.JoinData["model"];
            player.row=uint.Parse(player.JoinData["row"]);
            player.column = uint.Parse(player.JoinData["col"]);
            player.direction = player.JoinData["direction"];

                        //Informs other users chats that a new user just joined.
            Broadcast(PlayerIOMessages.PLAYER_JOIN, player.Id, player.ConnectUserId, player.model, player.row, player.column, player.direction);


          

			//Send info about all already connected users to the newly joined users chat
			

			foreach(Player p in Players) {
                if(p.Id != player.Id)
				m.Add(p.Id, p.ConnectUserId,p.model,p.row,p.column,p.direction);
			}

			player.Send(m);

			
		}

		// This method is called when a player leaves the game
		public override void UserLeft(Player player) {
			//Tell the chat that the player left.
			Broadcast(PlayerIOMessages.PLAYER_LEFT, player.Id);
		}

		// This method is called when a player sends a message into the server code
		public override void GotMessage(Player player, Message message) {
			switch(message.Type) {
				
				case PlayerIOMessages.MOVE: {
                    //Broadcast(PlayerIOMessages.MOVE, player.Id, message.GetInt(0), message.GetInt(1), message.GetString(2));
                    //update row/col
                    player.row = message.GetUInt(0);
                    player.column = message.GetUInt(1);
                    player.direction = message.GetString(2);

                    Broadcast(PlayerIOMessages.MOVE, player.Id,message.GetString(2));
						break;
					}
				case PlayerIOMessages.CHAT:{
                    //Broadcast("ChatMessage", id,name,message);
                    Broadcast(PlayerIOMessages.CHAT, player.Id, player.ConnectUserId, message.GetString(0));
                   
						break;
					}
			}
		}
	}
}