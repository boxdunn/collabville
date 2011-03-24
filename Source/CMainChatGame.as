package {
	import flash.display.MovieClip
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.StageScaleMode
	import flash.display.StageAlign
	import flash.events.*;
	import flash.ui.Keyboard;
	import KeyObject;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.filters.DropShadowFilter;
	import fl.controls.TextInput;
	import fl.controls.TextArea;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import fl.controls.ScrollPolicy;
	import flash.text.Font;
	import fl.events.ComponentEvent;
	import Facebook.FB;
	import playerio.*;
	import flash.geom.Point;
	import fl.controls.Button;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.external.ExternalInterface;
	import flash.display.LoaderInfo;
	import Presence;
	import CVector2d;


	
	
	public class CMainChatGame extends MovieClip{
		private var m_currentConnection:Connection;
		private var m_previousConnection:Connection;
		private var m_client:Client;
		private var m_time:Number;
		var key:KeyObject;
		private var myId:int
		private var m_avatars:Array = [];
		private var m_objects:Array = [];
		private var m_rooms:Array = [];
		private var m_speechBubbles:Array = []; 
		private var m_selectionAvatars:Array = [];
		private var m_indexCurrAvatar:Number;
		private var m_fade:FadeAnim_mc;
		//private var lcOffset:Number =0
		//private var colors:Array = [
			//0x333399,
			//0x339933,
			//0x993333,
			//0x999933,
			//0x339999,
			//0x993399
		//]
		
		var bg:ChooseCharacterBackground_mc;
		var m_roombg:MovieClip;
		//var m_roombg:Back1_mc;
		//var m_roombg2:Back2_mc;
		var m_chatWindow:ChatWindow_mc;
		var m_txtAreaChat:TextArea;
		var m_numMySpeechBubbles:Number;
		var m_numGlobalSpeechBubbles:Number;
		var avt:MovieClip;
		var m_btnarrow:ButtonArrow_mc;
		var m_btnok:ButtonOk_mc;
		var m_btnLogOff:ButtonLogOff_mc;
		var m_playerAvailable:Boolean;
		var m_avatar:Avatar;
		//var m_nextRoomNumber:Number;
		//var m_prevRoomNumber:Number;
		var m_roomNumber:Number;
		
		var m_didChooseAvatar:Boolean;
		var m_fading:Boolean;
		
		var m_chestObject:ChestEntity;
		
		
		var pTopLeft:Point;
		var pTopRight:Point;
		var pBottomLeft:Point;
		var pBottomRight:Point;
		
		var cc1:CollisionCircle_mc;
		var cc2:CollisionCircle_mc;
		var cc3:CollisionCircle_mc;
		var cc4:CollisionCircle_mc;
		
		var m_userNameField:TextInput;
		var m_enterNameLabel:TextField;
		var m_okNameButton:Button;
		
		var m_cameraDisplacementX:Number;
		var m_cameraDisplacementY:Number;
		
		var m_cameraTotalDisplacementX:Number;
		var m_cameraTotalDisplacementY:Number;
		
		var m_characterWorldX:Number;
		var m_characterWorldY:Number;
		
		var m_sortedAvatars:Array = [];
		
		var m_pointsTextField:TextField;
		
		var m_miniMap:MiniMap;
		
		var m_challenge:Challenge;
		
		
		//Type in your information here for debugging and playing the game outside Facebook
		private var gameid:String = "[Insert your game id here]"
		private var app_id:String = "[Insert your facebook application id here]"
		private var show_id:String = "" //Insert a facebook id here if you wish to emulate viewing a player
		private var parameters:Object = null;
		
		function CMainChatGame(){
			stop();
			
			Security.allowDomain("http://localhost");
			flash.external.ExternalInterface.addCallback("ConnectFromJavascript",ConnectFromJavascript);
			
			
			//Get flashvars
			parameters = LoaderInfo(this.root.loaderInfo).parameters;
			
			//Set default arguments if no parameters is parsed to the game
			gameid = parameters.sitebox_gameid || gameid
			app_id = parameters.fb_application_id || app_id
			show_id = parameters.querystring_id || show_id
			
			
			
			m_enterNameLabel = new TextField();
            m_enterNameLabel.width = 174;
            m_enterNameLabel.height = 50;
			m_enterNameLabel.x = stage.stageWidth/2 - m_enterNameLabel.width/2;//310;
			m_enterNameLabel.y = stage.stageHeight/2 + 25; //270;
			m_enterNameLabel.text = "Enter your avatar name";
			m_enterNameLabel.setTextFormat(new TextFormat("Arial",17));
			//addChild(m_enterNameLabel);
			
			var dropShadow:DropShadowFilter = new DropShadowFilter(2,45,0x000000,1,5,5,1,1,false,false,false)
			
			m_userNameField = new TextInput();
			m_userNameField.width = 250;
			m_userNameField.height = 24;
			m_userNameField.x = stage.stageWidth/2 - m_userNameField.width/2;
			m_userNameField.y = stage.stageHeight/2;
			m_userNameField.maxChars = 20;
			m_userNameField.text = "";
			//m_userNameField.setStyle(();
			m_userNameField.alwaysShowSelection	= true;
			
			//m_userNameField.filters = [dropShadow];
			//m_userNameField.wordWrap = true;
			
			//m_userNameField.verticalScrollPolicy = ScrollPolicy.OFF;
			m_userNameField.setStyle("textFormat",new TextFormat("Arial",17));
			//addChild(m_userNameField);
			
			
			m_okNameButton = new Button();
			m_okNameButton.label = "Play Game";
			m_okNameButton.width = 80;
			m_okNameButton.move(stage.stageWidth/2-m_okNameButton.width/2,stage.stageHeight/2 + 80);
			m_okNameButton.toggle = false;
			m_okNameButton.setStyle("textFormat",new TextFormat("Georgia"));
			m_okNameButton.addEventListener(MouseEvent.CLICK,OkNameButtonClick);
			addChild(m_okNameButton);
			
					
					/*
			PlayerIO.connect(
				stage,								//Referance to stage
				"chat-game-m6btfxhdp0y9d2ysgauzq",		//Game id (Get your own at playerio.com. 1: Create user, 2:Goto admin pannel, 3:Create game, 4: Copy game id inside the "")
				"public",							//Connection id, default is public
				"GuestUser2",						//Username
				"",									//User auth. Can be left blank if authentication is disabled on connection
				handleConnect,						//Function executed on successful connect
				handleError							//Function executed if we recive an error
			);**/
			
			
			
			key = new KeyObject(stage);
			m_time = getTimer();
			m_playerAvailable = false;
			
			
			m_roomNumber = 0;
		
			m_currentConnection = null;
			m_previousConnection = null;
			m_didChooseAvatar = false;
			m_fading = false;
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			//stage.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			//stage.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseUp);
			
			m_cameraDisplacementX = 0;
			m_cameraDisplacementY = 0;
			
			m_cameraTotalDisplacementX = 0;
			m_cameraTotalDisplacementY = 0;
			
			m_characterWorldX = 0;
			m_characterWorldY = 0;
			
			
			
			
			
			
			var room0:GameRoom = new GameRoom(true);
			room0.m_leftExit = true;
			room0.m_width = 1000;
			room0.m_height = 600;
			
			m_chestObject = new ChestEntity(1234,"chest",true,m_currentConnection);
			m_chestObject.AttachMc(new Chest_mc());
		    m_chestObject.m_worldX = 128;
			m_chestObject.m_worldY = 244.05;
			m_chestObject.x = m_chestObject.m_worldX;
			m_chestObject.y = m_chestObject.m_worldY;
			
			room0.m_objectEntities["chest"] = m_chestObject;
			
			
			var room1:GameRoom = new GameRoom(true);
			room1.m_rightExit = true;
			room1.m_width = 760;
			room1.m_height = 600;
			
			var npc1:MovingNPCEntity = new MovingNPCEntity(888,"npc1",true,m_currentConnection);
			npc1.m_worldX = 155.0;
			npc1.m_worldY = 450.0;
			//npc1.m_positions.push(new CVector2d(30,30));
			//npc1.m_positions.push(new CVector2d(50,-40));
			npc1.AttachMc(new Avatar1());
			room1.m_movingNPCEntities[npc1.m_id] = npc1;
			
			m_rooms[m_roomNumber] = room0;
			m_rooms[m_roomNumber+1] = room1;
			
			
			
			
			m_miniMap = new MiniMap();
			
			
			
			//removeChild(m_enterNameLabel);
			//removeChild(m_userNameField);
			//removeChild(m_okNameButton);
			
			//gotoAndStop(2);
			
			
			//If played on facebook
			if(parameters.fb_access_token){
				//Connect in the background
				PlayerIO.quickConnect.facebookOAuthConnect(stage, gameid, parameters.fb_access_token,  function(c:Client, id:String=""):void{
					handleConnect(c, parameters.fb_access_token, id)
				}, handleError);
			}else{
				
					/*
					PlayerIO.quickConnect.facebookOAuthConnect(stage, gameid, parameters.fb_access_token,  function(c:Client, id:String=""):void{
					handleConnect(c, parameters.fb_access_token, id)
				}, handleError);
				*/
					
				
				/*
				//Else we are in development, connect with a facebook popup
				PlayerIO.quickConnect.facebookOAuthConnectPopup(
					stage,
					gameid,
					"_top",
					[],
					handleConnect, 
					handleError
				);
				*/
				
			}
			
			
			

			stage.scaleMode = StageScaleMode.NO_SCALE
			stage.align = StageAlign.TOP_LEFT
		}
		
		public function OnMouseDownTest():void
		{
			/*
			//CleanupRoom();
			
			
			//event.currentTarget.gotoAndPlay(10);
			
			
			//connection.addMessageHandler("chooseAvatar", function(m:Message, myid:int){
																					  
			//})
			
			//m_didChooseAvatar = true;
			
			removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
			
			
			
			
			CleanupRoom();
			
			removeChild(m_btnLogOff);
			removeChild(m_chatWindow);
			removeChild(m_txtAreaChat);
			//removeChild(m_avatars[myId]);
			
			for each (var av:Avatar in m_avatars)
			{
					removeChild(av);
					
			}
				
			m_avatar.m_available = false;
			
			m_currentConnection.send("logOff",myId);
			
			
			//removeChild(m_roombg);
			//m_currentConnection.send("testo");
			*/
		}
		
		private function ConnectFromJavascript():void
		{
			gotoAndStop(2);
		}
		
		private function OkNameButtonClick(event:MouseEvent):void
		{
			//removeChild(m_enterNameLabel);
			//removeChild(m_userNameField);
			//removeChild(m_okNameButton);
			
			//ExternalInterface.call("ShowLightbox()");
			ExternalInterface.call("myWindow = window.open","","logWindow","height=200,width=500,scrollbars=no");
			ExternalInterface.call("myWindow.moveTo(screen.width/2-250,screen.height/2 - 100)");
			
			PlayerIO.quickConnect.facebookOAuthConnectPopup(
					stage,
					gameid,
					"logWindow",
					[],
					handleConnect, 
					handleError
				);
				
			
			/*
			gotoAndStop(2);
			PlayerIO.connect(
				stage,								//Referance to stage
				"collabville-ri5m1gdqku2oxkfomdy7ig",		//Game id (Get your own at playerio.com. 1: Create user, 2:Goto admin pannel, 3:Create game, 4: Copy game id inside the "")
				"public",							//Connection id, default is public
				m_userNameField.text,						//Username
				"",									//User auth. Can be left blank if authentication is disabled on connection
				handleConnect,						//Function executed on successful connect
				handleError							//Function executed if we recive an error
			);
			*/
		}
		
		//private function handleConnect(client:Client):void
		private function handleConnect(client:Client,access_token:String, id:String = ""):void{
			trace("Sucessfully connected to player.io");
			
			removeChild(m_okNameButton);
			gotoAndStop(2);
			
			//Set developmentsever (Comment out to connect to your server online)
			//client.multiplayer.developmentServer = "localhost:8184";
			
			
			/*
			var i:Number=0;
			for (i=0; i<3; i++)
			{
				//Create pr join the room test
				client.multiplayer.createRoom(
					"ChatGameRoom"+i,		//Room id. If set to null a random roomid is used
					"ChatGame",							//The game type started on the server
					true,								//Should the room be visible in the lobby?
					{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
					null,							//Function executed on successful joining of the room
					handleError							//Function executed if we got a join error
				);
			}
			*/
			
			//trace("Last created room is: "+i);
			/*
			//Create pr join the room test
			client.multiplayer.createRoom(
					"ChatGameRoom0",		//Room id. If set to null a random roomid is used
					"ChatGame",							//The game type started on the server
					true,								//Should the room be visible in the lobby?
					{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
					null,							//Function executed on successful joining of the room
					handleError							//Function executed if we got a join error
				);
			
				client.multiplayer.createRoom(
					"ChatGameRoom1",		//Room id. If set to null a random roomid is used
					"ChatGame",							//The game type started on the server
					true,								//Should the room be visible in the lobby?
					{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
					null,							//Function executed on successful joining of the room
					handleError							//Function executed if we got a join error
				);
				*/
				
			
			

			m_client = client;
			

			
			
			
			//Init Presence system.
			Presence.init(client, function():void{
					
				//Is [userid] online.
				Presence.getOnlineStatus(client.connectUserId, function(status:Boolean):void{
					trace("is user online?", status);
				})
				
				
				//Create pr join the room test
			client.multiplayer.createJoinRoom(
				"ChatGameRoom"+m_roomNumber,
				"ChatGame",//Room id. If set to null a random roomid is used
				true,
				{},									//User join data
				{},
				handleJoin,							//Function executed on successful joining of the room
				handleError							//Function executed if we got a join error
			);
			
			}, handleErrorPresence)
			
			
		}
		
		private function handleErrorPresence(e:PlayerIOError):void{
			trace("got", e)
		}
		
		private function handleJoin(connection:Connection):void{
			trace("Sucessfully connected to the multiplayer server");
			gotoAndStop(3);
			
			//Handle init message
			trace("checking connection");
			if (m_previousConnection)
			m_previousConnection.disconnect();
			
			m_currentConnection = connection;
			trace("end checking connection");
			
			
			
			m_rooms[m_roomNumber].SetConnection(m_currentConnection);
			
			
			
			connection.addDisconnectHandler(function(){
		      
			  trace("DISCONNECTING FROM ROOM");
			  
			})
			
			connection.addMessageHandler("getAvatarData", function(m:Message, myid:int) {
			
			  connection.send("avatarData",m_didChooseAvatar);
			  
			})
			
			connection.addMessageHandler("chooseAvatar", function(m:Message, myid:int){
			  
			  trace("ENTERING CHOOSE AVATAR");
			  
			  
			  m_avatar = new Avatar(myId,"test",false,m_currentConnection);
			  
			  bg = new ChooseCharacterBackground_mc();
			  bg.x = stage.stageWidth/2 - bg.width/2;
			  bg.y = stage.stageHeight/2 - bg.height/2 - 40;
			  addChild(bg);
			  
			  var dropShadow:DropShadowFilter = new DropShadowFilter(2,45,0x000000,0.4,5,5,1,1,false,false,false);

			  bg.filters = [dropShadow];
			  
			  m_btnok = new ButtonOk_mc();
			  m_btnok.x = stage.stageWidth/2 - m_btnok.width/2;
			  m_btnok.y = stage.stageHeight/2 + 100;
			  addChild(m_btnok);
			  
			  m_btnok.addEventListener(MouseEvent.MOUSE_OVER,OnMouseOver);
			  m_btnok.addEventListener(MouseEvent.MOUSE_OUT,OnMouseOut);
			  m_btnok.addEventListener(MouseEvent.MOUSE_DOWN,OnMouseDownOkAvatar);
			  
			  m_btnarrow = new ButtonArrow_mc();
			  m_btnarrow.x = stage.stageWidth/2 + 125;
			  m_btnarrow.y = stage.stageHeight/2 + 30;
			  addChild(m_btnarrow);
			  
			  m_btnarrow.addEventListener(MouseEvent.MOUSE_OVER,OnMouseOver);
			  m_btnarrow.addEventListener(MouseEvent.MOUSE_OUT,OnMouseOut);
			  m_btnarrow.addEventListener(MouseEvent.MOUSE_DOWN,OnMouseDownNextAvatar);
			  
			  m_indexCurrAvatar = Math.floor(Math.random()*3);
			  m_selectionAvatars[0] = new Avatar1();
			  m_selectionAvatars[1] = new Avatar2();
			  m_selectionAvatars[2] = new Avatar3();
			  m_selectionAvatars[3] = new Avatar4();
			  
			  avt = m_selectionAvatars[m_indexCurrAvatar];
			  avt.x = stage.stageWidth/2;
			  avt.y = stage.stageHeight/2 - 50;
			  addChild(avt);
			  
			})
			
			connection.addMessageHandler("joinNextRoom", function(m:Message, myid:int){
			m_client.multiplayer.createJoinRoom(
				"ChatGameRoom"+m_roomNumber,
				"ChatGame",//Room id. If set to null a random roomid is used
				true,
				{},									//User join data
				{},
				handleJoin,							//Function executed on successful joining of the room
				handleError							//Function executed if we got a join error
			); 
			})
			
			connection.addMessageHandler("fightAction",function(m:Message) {
				trace("My id: "+m.getInt(0));
				trace("Opponent id: "+m.getInt(1));
				trace("Ask for fight: "+m.getBoolean(2));
				
				m_avatars[myId].AskForFight(m.getInt(1));
			});
			
			connection.addMessageHandler("attacked",function(m:Message) {
				trace("GOT ATTACKED");
				
				m_avatars[myId].m_health = m.getInt(1);
				m_challenge.m_av1.m_health = m.getInt(1);
				m_challenge.NextTurn();
				
			});
			
			connection.addMessageHandler("initiateFight",function(m:Message) {
				trace("INITIATING FIGHT");
				
				//removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
				m_avatar.m_available = false;
				
				m_challenge = new Challenge(m_avatars[m.getInt(0)],m_avatars[m.getInt(1)],m.getBoolean(2),m_currentConnection);
				m_challenge.Init();
				addChild(m_challenge);
			});
			
			connection.addMessageHandler("finishFight",function(m:Message) {
				
				removeChild(m_challenge);
				m_challenge = null;
				
				//addEventListener(Event.ENTER_FRAME, OnEnterFrame);
				m_avatar.m_available = true;
			});
			
			connection.addMessageHandler("updateScore",function(m:Message) {
				trace("Got score"+ m.getInt(1));
				//m_avatars[myId].AddScore(m.getInt(1));
				m_avatars[myId].SetScore(m.getInt(1));
				m_pointsTextField.text = String(m_avatar.GetScore());
			});
			
			connection.addMessageHandler("npcUpdate",function(m:Message) {
				
				 var npcId:Number = m.getInt(0);
				 
				 
				 
				 if (npcId in m_rooms[m_roomNumber].m_movingNPCEntities)
				 {
					 
					 var npcNextPosX:Number = m.getInt(1);
				 	 var npcNextPosY:Number = m.getInt(2);
				
					 var npc:MovingNPCEntity = m_rooms[m_roomNumber].m_movingNPCEntities[npcId];
					 var xteen:Tween = new Tween(npc,"m_worldX", None.easeOut, npc.m_worldX, npcNextPosX, 0.1, true);
					 var yteen:Tween = new Tween(npc,"m_worldY", None.easeOut, npc.m_worldY, npcNextPosY, 0.1, true);
				 }
				 
										 
			});
			
			connection.addMessageHandler("useInteractiveEntity", function(m:Message){
			
				 var entity:String = m.getString(0);
				 if (entity in m_rooms[m_roomNumber].m_objectEntities)
				 {
					 
					  m_rooms[m_roomNumber].m_objectEntities[entity].Use(true);
					 
				 }
										 
			});
			
			connection.addMessageHandler("updateInteractiveEntity", function(m:Message){
										
							 var id:Number = m.getInt(0);
							 var entity:String = m.getString(1);
							 var eState:Number = m.getInt(2);
							 
							 if (id != myId)
							 {
					
							
							 if (entity in m_rooms[m_roomNumber].m_objectEntities)
							 {
								 
								 m_rooms[m_roomNumber].m_objectEntities[entity].Use(false);
								
							 }
							 
							 }
				
			});
			
			connection.addMessageHandler("init", function(m:Message, myid:int){
				//Set my id so we know who we are
				myId = myid
				
				
				trace("STARTING INIT");
				
				if(m_fading)
				{
					removeChild(m_fade);
					m_fading = false;
				}
				
				key = new KeyObject(stage);
				addEventListener(Event.ENTER_FRAME, OnEnterFrame);
				addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
				
				
				
				m_client.bigDB.loadOrCreate("RoomObjects", "room" + m_roomNumber, function(dobj:DatabaseObject)
				{
					
					if (!dobj.name)
					{
						trace("Database never created");
						dobj.name = "room" + m_roomNumber;
						
						
						 for each (var o:IGameEntity in m_rooms[m_roomNumber].m_objectEntities)
						 {
							 
							 switch(o.GetName())
							 {
								 case "chest":
								 {
									 
									 var chest:ChestEntity = o as ChestEntity;
									 
									 dobj.objects = {};
									 dobj.objects["chest"] = {};
									 dobj.objects.chest.state = chest.m_state;
									 dobj.objects.chest.x = chest.m_worldX;
									 dobj.objects.chest.y = chest.m_worldY;
									
									 
									 break;
								 }
							 }
							 
						 }
						 
						dobj.save(false,false,function()
						{
							m_currentConnection.send("initNewLevel",m_roomNumber);
						},null);
					}
					else
					{
						trace("Database loaded");
						
						for each (var o:IGameEntity in m_rooms[m_roomNumber].m_objectEntities)
						{
							 
							 switch(o.GetName())
							 {
								 case "chest":
								 {
									 o.SetState(dobj.objects["chest"].state);
									 break;
								 }
							 }
							 
						 }
					}
					
				}, function() { trace("ERROR") } );
				
				switch (m_roomNumber)
			  	{
				 	 case 0:
				 	 {
						 //trace("LOADING ROOM 0");
						 m_roombg = new Back1_mc();
						 m_roombg.x = 0;
					     m_roombg.y = 0;
					     addChild(m_roombg);
						 
						 for each (var o:IGameEntity in m_rooms[m_roomNumber].m_objectEntities)
						 {
							 switch(o.GetName())
							 {
								 case "chest":
								 {
									 
									 var chest:ChestEntity = o as ChestEntity;
						 			 addChild(chest);
									 
									 break;
								 }
							 }
						 }
				
						 
				
						 break;
				 	 }
					 
					  case 1:
				 	 {
						  trace("LOADING ROOM 1");
						 m_roombg = new Back2_mc();
						 m_roombg.x = 0;
					     m_roombg.y = 0;
					     addChild(m_roombg);
						 
						 //room1.m_movingNPCEntities
						 
						 for each (var npci:MovingNPCEntity in m_rooms[m_roomNumber].m_movingNPCEntities)
						 {
						 	addChild(npci);
						 }
				
						 break;
				 	 }
			 	 }
				
				if (!m_didChooseAvatar)
				{
					trace("CLEANING AVATAR SELECTION SCREEN ");
					
					removeChild(bg);
					removeChild(avt);
				
				
					m_btnok.removeEventListener(MouseEvent.MOUSE_OVER,OnMouseOver);
			  		m_btnok.removeEventListener(MouseEvent.MOUSE_OUT,OnMouseOut);
			  		m_btnok.removeEventListener(MouseEvent.MOUSE_DOWN,OnMouseDownOkAvatar);
					removeChild(m_btnok);
				
				
					m_btnarrow.removeEventListener(MouseEvent.MOUSE_OVER,OnMouseOver);
			  		m_btnarrow.removeEventListener(MouseEvent.MOUSE_OUT,OnMouseOut);
			  		m_btnarrow.removeEventListener(MouseEvent.MOUSE_DOWN,OnMouseDownNextAvatar);
					removeChild(m_btnarrow);
					
					
					m_chatWindow = new ChatWindow_mc();
					m_chatWindow.x = stage.stageWidth/2;
					m_chatWindow.y = stage.stageHeight/2 + 289;
					addChild(m_chatWindow);
					
					var myfont:Font = new Font1();
					var tformat:TextFormat = new TextFormat();
					tformat.font = myfont.fontName;
					tformat.size = 25;
					tformat.color = 0xFFFFFF;
					
					m_pointsTextField = new TextField();
					m_pointsTextField.x = 710;
					m_pointsTextField.y = 15;
					m_pointsTextField.width = 50;
					m_pointsTextField.height = 30
					//m_pointsTextField.border = true;
					m_pointsTextField.multiline = false;
					m_pointsTextField.selectable = false;
					m_pointsTextField.defaultTextFormat = tformat;
					//m_pointsTextField.autoSize = TextFieldAutoSize.CENTER;
					m_pointsTextField.wordWrap = true;
					m_pointsTextField.embedFonts = true;
					m_pointsTextField.text = String(m_avatar.GetScore());//"AAAAAAAAAAAAAA\nAAAAAAAAAAAAAA\nAAAAAAAAAAAAAA\nAAAAAAAAAAAAAA\nAAAAABBBBBBBBB\nBBBBBBB";
					addChild(m_pointsTextField);
				
					m_numMySpeechBubbles = 0;
					m_numGlobalSpeechBubbles = 0;
				
					m_txtAreaChat = new TextArea();
					m_txtAreaChat.x = stage.stageWidth/2 - 210;
					m_txtAreaChat.y = stage.stageHeight/2 + 264;
					m_txtAreaChat.width = 420;
					m_txtAreaChat.height = 30;
					m_txtAreaChat.maxChars = 68;
					m_txtAreaChat.wordWrap = true;
					m_txtAreaChat.verticalScrollPolicy = ScrollPolicy.OFF;
					m_txtAreaChat.setStyle("textFormat",new TextFormat("Arial",20));
					addChild(m_txtAreaChat);
				
					m_txtAreaChat.addEventListener(ComponentEvent.ENTER,TextAreaEnter);

				
				
					switch (m_indexCurrAvatar)
					{
						case 0:
						m_avatar.AttachMc(new Avatar1());
						break;
						case 1:
						m_avatar.AttachMc(new Avatar2());
						break;
						case 2:
						m_avatar.AttachMc(new Avatar3());
						break;
						case 3:
						m_avatar.AttachMc(new Avatar4());
						break;
					}
				
					m_avatar.m_worldX = m.getInt(1);
					m_avatar.m_worldY = m.getInt(2);
					m_avatar.x = m_avatar.m_worldX;
					m_avatar.y = m_avatar.m_worldY;
					m_avatar.m_avatarTypeIndex = m_indexCurrAvatar;
					m_avatar.m_available = true;
					connection.send("enablePlayer",true);
					connection.send("setAvatar",m_indexCurrAvatar);
				
					
					m_didChooseAvatar = true;
					connection.send("avatarData",m_didChooseAvatar);
					
					
					
				}
				else
				{
					
					addChild(m_chatWindow);
					addChild(m_pointsTextField);
					m_numMySpeechBubbles = 0;
					m_numGlobalSpeechBubbles = 0;
					addChild(m_txtAreaChat);
					
					m_avatar.m_available = true;
					connection.send("enablePlayer",true);
					connection.send("setAvatar",m_indexCurrAvatar);
				}
				
				m_miniMap.x = 5;
				m_miniMap.y = 5;
				addChild(m_miniMap);
				
				m_avatar.m_worldX = m.getInt(1);
				m_avatar.m_worldY = m.getInt(2);
				m_avatar.x = m_avatar.m_worldX;
				m_avatar.y = m_avatar.m_worldY;
				m_avatars[myId] = m_avatar;
				
				
				m_avatars[myId].UpdateCollisionShape();
				
				
				cc1 = new CollisionCircle_mc();
				cc1.x = m_avatars[myId].m_pTopLeft.x;
				cc1.y = m_avatars[myId].m_pTopLeft.y;
				//addChild(cc1);
				
				cc2 = new CollisionCircle_mc();
				cc2.x = m_avatars[myId].m_pBottomLeft.x;
				cc2.y = m_avatars[myId].m_pBottomLeft.y;
				//addChild(cc2);
				
				cc3 = new CollisionCircle_mc();
				cc3.x = m_avatars[myId].m_pBottomRight.x;
				cc3.y = m_avatars[myId].m_pBottomRight.y;
				//addChild(cc3);
				
				cc4 = new CollisionCircle_mc();
				cc4.x = m_avatars[myId].m_pTopRight.x;
				cc4.y = m_avatars[myId].m_pTopRight.y;
				//addChild(cc4);
				
			})
			
			connection.addMessageHandler("move", function(m:Message, id:int, x:int, y:int){
				//Move Avatar to new position using a tween.
				if (id != myId && (id in m_avatars))
				{
				var currAvatar:Avatar = m_avatars[id];
				var xteen:Tween = new Tween(m_avatars[id],"m_worldX", None.easeOut, currAvatar.m_worldX, x, 0.1, true);
				var yteen:Tween = new Tween(m_avatars[id],"m_worldY", None.easeOut, currAvatar.m_worldY, y, 0.1, true);
				}
		
			})
			
			connection.addMessageHandler("left", function(m:Message, id:int){
				
					m_sortedAvatars.splice(0,m_sortedAvatars.length);
					
					trace("REMOVING AVATAR THAT LEFT");
					//var newAvatar:Avatar = m_avatars[id];
					
					m_miniMap.RemoveId(id);
					
					removeChild(m_avatars[id]);
					m_avatars[id] = null;
					delete m_avatars[id];
			})
			
			connection.addMessageHandler("activate", function(m:Message, userid:int, letterid:int){
				
			})
			
			connection.addMessageHandler("speechBubble", function(m:Message, userid:int, textp:String) {
		    	
				if (userid != myId)
				{
					
					var newSpeechBubble:SpeechBubble = new SpeechBubble(userid,textp);
					newSpeechBubble.x = 30 + Math.random()*15;
					newSpeechBubble.y = -50 - Math.random()*15;
				
					m_avatars[userid].addChild(newSpeechBubble);
					m_speechBubbles.push(newSpeechBubble);
					
					m_numGlobalSpeechBubbles++;
					
					var tim:Timer = new Timer(3000,1);
					tim.addEventListener(TimerEvent.TIMER_COMPLETE,CloseSpeechBubble);
					tim.start();
				}
			})
			
			connection.addMessageHandler("switchRoom", function(m:Message, userid:int){
				if (userid != myId)
				{
					trace("removingFromMinimap with id"+userid);
					m_miniMap.RemoveId(userid);
			
				}
			})
			
			
			connection.addMessageHandler("update", function(m:Message){
				
				if(m_avatar && !m_avatar.m_available)
				return;
			
				for (var a:int=0;a<m.length;a+=5)
				{
					var id:Number = m.getInt(a);
					var isavailable:Boolean = m.getBoolean(a+3);
					var avatarType:Number = m.getInt(a+4);
					if(id != myId)
					{
						
						if(!(id in m_avatars) && isavailable)
						{
							trace("Found new guest avatar, adding it. type: "+avatarType);
							var newAvatar:Avatar = new Avatar(id,"test",true,m_currentConnection);
							
							switch (avatarType)
							{
								case 0:
								newAvatar.AttachMc(new Avatar1());
								break;
								case 1:
								newAvatar.AttachMc(new Avatar2());
								break;
								case 2:
								newAvatar.AttachMc(new Avatar3());
								break;
								case 3:
								newAvatar.AttachMc(new Avatar4());
								break;
							}
							
							trace("Setting the new guest avatar values");
							newAvatar.m_worldX = m.getInt(a+1);
							newAvatar.m_worldY = m.getInt(a+2);
							newAvatar.m_available = true;
							m_avatars[id] = newAvatar;
						
						}
						
					}
				}
				
				
					cc1.x = m_avatars[myId].m_pTopLeft.x;
					cc1.y = m_avatars[myId].m_pTopLeft.y;
					
					cc2.x = m_avatars[myId].m_pBottomLeft.x;
					cc2.y = m_avatars[myId].m_pBottomLeft.y;
					
					cc3.x = m_avatars[myId].m_pBottomRight.x;
					cc3.y = m_avatars[myId].m_pBottomRight.y;
					
					cc4.x = m_avatars[myId].m_pTopRight.x;
					cc4.y = m_avatars[myId].m_pTopRight.y;
					
				
				
				
				m_sortedAvatars.splice(0,m_sortedAvatars.length);
				
				
				for each (var oe:IGameEntity in m_rooms[m_roomNumber].m_objectEntities)
				{
					m_sortedAvatars.push(oe);
					m_miniMap.Update(oe.GetId(), oe.GetWorldX(), oe.GetWorldY(), false, true)
				}
				
				for each (var av:Avatar in m_avatars)
				{
					m_sortedAvatars.push(av);
					m_miniMap.Update(av.m_id, av.m_worldX, av.m_worldY)
				}
				
				for each (var npcs:MovingNPCEntity in m_rooms[m_roomNumber].m_movingNPCEntities)
				{
					m_sortedAvatars.push(npcs);
					m_miniMap.Update(npcs.m_id, npcs.m_worldX, npcs.m_worldY,false)
				}
				
				
				
				m_sortedAvatars.sortOn("y",Array.NUMERIC);
				
				
				
				
				// REMOVE SPEECH BUBBLES
				var counter:Number = 0;
				for each(var sb:SpeechBubble in m_speechBubbles)
				{
					if (sb.m_mc.alpha == 0)
					{
				
						if (sb.m_id == myId)
						m_numMySpeechBubbles--;
						
						m_numGlobalSpeechBubbles--;
						
						m_avatars[sb.m_id].removeChild(sb);
						m_speechBubbles.splice(counter,1);
					}
					
					counter++;
				}
				
				connection.send("move",myId, Math.round( m_avatars[myId].m_worldX ), Math.round( m_avatars[myId].m_worldY ));
			})
			
		}
		
		public function TextAreaEnter(e:Event):void
		{
			if (m_txtAreaChat.text != "" && m_numMySpeechBubbles < 3)
			{
				m_numMySpeechBubbles++;
				m_numGlobalSpeechBubbles++;
			
				
				var sb:SpeechBubble = new SpeechBubble(myId,m_txtAreaChat.text);
				sb.x = 30 + Math.random()*15;
				sb.y = -50 - Math.random()*15;
				
				
				m_avatars[myId].addChild(sb);
				m_speechBubbles.push(sb);
				
				
				m_currentConnection.send("speechBubble",String(m_txtAreaChat.text));
				
				
				
				// Clear the chat area
				m_txtAreaChat.text = "";
				
			}
		}
		
		public function CloseSpeechBubble(event:TimerEvent):void
		{
			
			var bb:SpeechBubble = m_speechBubbles[m_numGlobalSpeechBubbles-1];
			bb.gotoAndPlay(2);
			
			// Reduce the amount of global speech bubbles counter
			m_numGlobalSpeechBubbles--;
			
			// If the id of the speech bubble is myId then reduce the amount of own speech bubbles 
			if (bb.m_id == myId)
			m_numMySpeechBubbles--;
			
		}
		
		public function OnMouseOver(event:MouseEvent)
		{
			event.currentTarget.gotoAndStop(5);
		}
		
		public function OnMouseOut(event:MouseEvent)
		{
			event.currentTarget.gotoAndStop(0);
		}
		
		public function OnMouseDownNextAvatar(event:MouseEvent)
		{
			event.currentTarget.gotoAndPlay(10);
			
			if (m_indexCurrAvatar < 3)
			m_indexCurrAvatar++;
			else
			m_indexCurrAvatar = 0;
			
			removeChild(avt);
			avt = m_selectionAvatars[m_indexCurrAvatar];
			avt.x = stage.stageWidth/2;
			avt.y = stage.stageHeight/2 - 50;
			addChild(avt);
			
		}
		
		public function OnMouseDownOkAvatar(event:MouseEvent)
		{
			event.currentTarget.gotoAndPlay(10);
		
			
			m_currentConnection.send("initFirstTime",myId);
		}
		
		public function CleanupRoom():void
		{
			// Cleanup room
			switch (m_roomNumber)
			{
				case 0:
				{
					removeChild(m_roombg);
					
					trace("Removing CHest");
					removeChild(m_chestObject);
				
					m_objects.splice(0,m_objects.length);
					
					m_sortedAvatars.splice(0,m_sortedAvatars.length);
					
					m_avatars.splice(0,m_avatars.length);
					
					break;
				}
				
				case 1:
				{
					removeChild(m_roombg);
					
					m_objects.splice(0,m_objects.length);
					
					m_sortedAvatars.splice(0,m_sortedAvatars.length);
					
					m_avatars.splice(0,m_avatars.length);
					
					break;
				}
			}
		}
		
		public function SwitchRooms(fromDirection:String):void
		{
			
			removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
			key.deconstruct();
			
			m_fading = true;
			m_fade = new FadeAnim_mc();
			m_fade.x = stage.stageWidth/2;
			m_fade.y = stage.stageHeight/2;
			addChild(m_fade);
			
			m_cameraTotalDisplacementX = 0;
			m_cameraTotalDisplacementY = 0;
			
			// Save the avatar before deleting the array
			m_avatar = m_avatars[myId];
			m_avatar.m_available = false;
			
			m_currentConnection.send("enablePlayer",false);
			
			CleanupRoom();
			
			m_miniMap.Clear();
			removeChild(m_miniMap);
			removeChild(m_chatWindow);
			removeChild(m_txtAreaChat);
			removeChild(m_pointsTextField);
			//removeChild(m_avatars[myId]);
			
			
			
			if (fromDirection == "left")
			m_roomNumber++;
			else
			m_roomNumber--;
			
			
			
			m_previousConnection = m_currentConnection;
			
			
			
			m_currentConnection.send("switchRoom",m_avatar.m_worldX,m_avatar.m_worldY,fromDirection,m_roomNumber);
			
			trace(" NEXT ROOM ID IS : ChatGameRoom"+m_roomNumber);
			
			
		}
			
		public function OnEnterFrame(event:Event):void
		{
			var elapsedTime:Number = getTimer() - m_time;
			m_time = getTimer();
			
			
			if (key.isDown(key.LEFT)) 
			{
				
				//if (!tlb && !blb)
				//if (m_avatars[myId].x > 0)
				if (m_avatars[myId].m_cameraX + m_cameraTotalDisplacementX > 0)
				//if (m_characterWorldX > 0) 
				{
				
					m_avatars[myId].m_worldX -= 2.0;
					m_avatars[myId].m_mc.gotoAndStop(3);
				}
				else 
				{
					if (m_rooms[m_roomNumber].m_leftExit)
					SwitchRooms("left");
				}
				
				
				//m_objects.push(m_chestObject);
				
				
				//for (var k:Number = 0; k<m_rooms[m_roomNumber].m_objectEntities.length; k++)
				for each (var oe:IGameEntity in m_rooms[m_roomNumber].m_objectEntities)
				{
					var obj:MovieClip = oe.GetMc();
					
					m_avatars[myId].UpdateCollisionShape();
					var tlb:Boolean = obj.collisionShape_mc.hitTestPoint(m_avatars[myId].m_pTopLeft.x,m_avatars[myId].m_pTopLeft.y);
					var blb:Boolean = obj.collisionShape_mc.hitTestPoint(m_avatars[myId].m_pBottomLeft.x,m_avatars[myId].m_pBottomLeft.y);
					
					if (tlb || blb)
					{
						m_avatars[myId].m_worldX += 2;
						break;
					}
				}
				
				
			}
			
			if (key.isDown(key.RIGHT)) 
			{
		
				
				//if (m_avatars[myId].x < 800)
				if (m_avatars[myId].m_cameraX + m_cameraTotalDisplacementX < m_rooms[m_roomNumber].m_width)
				{
					m_avatars[myId].m_worldX += 2.0;
					m_avatars[myId].m_mc.gotoAndStop(2);
				}
				else 
				{
					if (m_rooms[m_roomNumber].m_rightExit)
					SwitchRooms("right");
				}
				
				
				for each (var oe:IGameEntity in m_rooms[m_roomNumber].m_objectEntities)
				{
					var obj:MovieClip = oe.GetMc();
					
					m_avatars[myId].UpdateCollisionShape();
				
					var trb:Boolean = obj.collisionShape_mc.hitTestPoint(m_avatars[myId].m_pTopRight.x,m_avatars[myId].m_pTopRight.y);
					var brb:Boolean = obj.collisionShape_mc.hitTestPoint(m_avatars[myId].m_pBottomRight.x,m_avatars[myId].m_pBottomRight.y);
				
					if (trb || brb)
					{
						m_avatars[myId].m_worldX -= 2;
						break;
					}
				}
			}
			
			if (key.isDown(key.UP)) 
			{
		
				if(m_avatars[myId].m_cameraY > 165)
				{
					m_avatars[myId].m_worldY -= 2.0;
					m_avatars[myId].m_mc.gotoAndStop(4);
				}
				else
				{
					if (m_rooms[m_roomNumber].m_topExit)
					SwitchRooms("top");
				}
				
				
				for each (var oe:IGameEntity in m_rooms[m_roomNumber].m_objectEntities)
				{
					var obj:MovieClip = oe.GetMc();
					m_avatars[myId].UpdateCollisionShape();
				
					var tlb:Boolean = obj.collisionShape_mc.hitTestPoint(m_avatars[myId].m_pTopLeft.x,m_avatars[myId].m_pTopLeft.y);
					var trb:Boolean = obj.collisionShape_mc.hitTestPoint(m_avatars[myId].m_pTopRight.x,m_avatars[myId].m_pTopRight.y);
				
					if (tlb || trb)
					{
						m_avatars[myId].m_worldY += 2;
						break;
					}
				}
			}
			
			if (key.isDown(key.DOWN)) 
			{
				if(m_avatars[myId].m_cameraY < 509)
				{
					m_avatars[myId].m_worldY += 2.0;
					m_avatars[myId].m_mc.gotoAndStop(1);
				}
				
				
				for each (var oe:IGameEntity in m_rooms[m_roomNumber].m_objectEntities)
				{
					var obj:MovieClip = oe.GetMc();
					m_avatars[myId].UpdateCollisionShape();
				
					var blb:Boolean = obj.collisionShape_mc.hitTestPoint(m_avatars[myId].m_pBottomLeft.x,m_avatars[myId].m_pBottomLeft.y);
					var brb:Boolean = obj.collisionShape_mc.hitTestPoint(m_avatars[myId].m_pBottomRight.x,m_avatars[myId].m_pBottomRight.y);
				
					if (blb || brb)
					{
						m_avatars[myId].m_worldY -= 2;
						break;
					}
				}
			}
			
			
			if(m_avatar.m_available)
			{
			for (var ai:Number = 0; ai<m_sortedAvatars.length; ai++)
			{
					
					m_sortedAvatars[ai].m_cameraX = m_sortedAvatars[ai].m_worldX; 
					m_sortedAvatars[ai].m_cameraY = m_sortedAvatars[ai].m_worldY; 
					
					m_sortedAvatars[ai].m_cameraX -= m_cameraTotalDisplacementX;
					m_sortedAvatars[ai].m_cameraY -= m_cameraTotalDisplacementY;
					
					m_sortedAvatars[ai].x = m_sortedAvatars[ai].m_cameraX;
					m_sortedAvatars[ai].y = m_sortedAvatars[ai].m_cameraY;
					
					addChild(m_sortedAvatars[ai]);
			}
			}
			
			
			m_roombg.x -= m_cameraDisplacementX;
				
			m_cameraTotalDisplacementX += m_cameraDisplacementX;
			
		}
		
		public function OnMouseDown(event:MouseEvent):void
		{
			trace(event.stageX);
			trace(event.stageY);
			trace(event.target.name);
			
			for each(var av:Avatar in m_avatars)
			{
				var thisAv:Avatar = av;
				
				if (thisAv.m_mc.hitTestPoint(event.stageX, event.stageY, true))
				{
					av.OnMouseDown(m_avatars[myId].m_worldX,m_avatars[myId].m_worldY,m_avatars[myId],event.target.name)
				}
			}
			
			for each (var oe:IGameEntity in m_rooms[m_roomNumber].m_objectEntities)
			{
				var obj:MovieClip = oe.GetMc();
				
				if (obj.hitTestPoint(event.stageX, event.stageY, true))
				{
					oe.OnMouseDown(m_avatars[myId].m_worldX,m_avatars[myId].m_worldY,m_avatars[myId],event.target.name);
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
			trace("Got", error);
			gotoAndStop(3);

		}
	}	
}