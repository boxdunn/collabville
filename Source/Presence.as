package 
{
	import playerio.Client;
	import playerio.Connection;
	import playerio.DatabaseObject;
	import playerio.Message;

	public class Presence
	{
		private static var client:Client;
		private static var connection:Connection
		private static var errorHandler:Function
		private static var messageHandlers:Array = [];
		
		public static function init(c:Client, callback:Function, eh:Function):void{
			client = c;
			errorHandler = eh;
			connect(callback)
		}
		
		
		public static function getOnlineStatus(id:String, callback:Function):void{
			getStatus(id, function(o:DatabaseObject):void{
				//If user has online record, return true
				callback(o != null ? o.onlineStatus ? o.onlineStatus.state == 1 : false : false)
			})
		}
		
		
		public static function sendMessage(id:String, message:Message):void{
			getStatus(id, function(o:DatabaseObject):void{
				//If user is online
				if(o != null && o.onlineStatus != null && o.onlineStatus.state == 1){
					//Connect to that server
					client.multiplayer.joinRoom(o.onlineStatus.server,{}, function(con:Connection):void{
						//Hacky hacky, we add the target id as the last attribute of the message
						message.add(id);
						//Send him message
						con.sendMessage(message);
						//Disconnect as fast as possible so we don't take up room
						con.disconnect()
					}, errorHandler); 
				}
			})
		}
		
		public static function addMessageHandler(type:String, handler:Function):void{
			//Store to local cache
			messageHandlers.push(new MessageHandler(type, handler));
			
			//If connected add listener to connection
			if(connection != null){
				connection.addMessageHandler(type, handler)
			}
		}
		
		//Send message to user
		public static function send(id:String, type:String, ...args:Array):void{
			connect(function():void{
				sendMessage(id, connection.createMessage.apply(this, [type].concat(args)))
			})
		}
		
		private static function getStatus(id:String, callback:Function):void{
			//Ensure that we are connected before we try to do anything
			connect(function():void{
				//Load status from BigDB
				client.bigDB.load("PlayerObjects", id, callback, errorHandler)
			})
		}
		
		
		
		private static function connect(callback:Function):void{
			//If we did not init, throw error
			if(client == null) throw new Error("You must initalize the presence system before you can connect")
			
			//Reconncet if we are never connected or somehow got disconnected
			if(connection == null || !connection.connected){
				  //client.multiplayer.developmentServer = "localhost:8184";
				//client.multiplayer.developmentServer = "n.c:8184"
				
				trace("About to createjoin the presence room");
				
			 	//Using $service-room$ as the room we connect to makes Player.IO automatically distribute users optimally over room instances
				client.multiplayer.createJoinRoom("$service-room$", "presence", false, {}, {}, function(con:Connection):void{
					connection = con;
					connection.addMessageHandler("inited", function(m:Message):void{
						trace("Connected to presence server")
						callback();
					});
					
					//Connect event handlers
					for each(var m:MessageHandler in messageHandlers){
						connection.addMessageHandler(m.type, m.handler);
					}
					
					//Something wend horriable wrong and we got disconnected.
					connection.addDisconnectHandler(function():void{
						trace("Connection to presence server lost")
						//Lets reconnect
						Presence.connect(function():void{
							trace("Connection reestablished")
						});
					});
					
					//Tell the Presence server to init us
					connection.send("init");
					
				}, errorHandler);
				
			}else{
				callback();
			}	
		}
	}
}

//Wrapper class for event handlers
class MessageHandler{
	public var type:String = "";
	public var handler:Function;
	function MessageHandler(type:String, handler:Function){
		this.type = type;
		this.handler = handler;
	}
}