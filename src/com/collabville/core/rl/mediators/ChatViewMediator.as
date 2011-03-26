package com.collabville.core.rl.mediators
{
	import com.collabville.core.rl.actors.PlayerIOServiceActor;
	import com.collabville.core.rl.events.ChatViewEvent;
	import com.collabville.core.rl.events.PlayerIOEvent;
	import com.collabville.core.rl.views.ChatView;
	import com.collabville.core.utils.PlayerIOMessages;
	
	import mx.binding.utils.BindingUtils;
	
	import org.robotlegs.mvcs.Mediator;
	
	import playerio.Message;
	
	
	
	public class ChatViewMediator extends Mediator
	{
		[Inject] public var view:ChatView;
		[Inject] public var playerIOService:PlayerIOServiceActor;
		
		public var players:Array;
		
		
		public function ChatViewMediator()
		{
			super();
			
			players=new Array();
		}
		
		override public function onRegister():void
		{
			addViewListener(ChatViewEvent.SEND,onChatSend);
			addContextListener(PlayerIOEvent.CHAT_MESSAGE,onChatMessage);
			addContextListener(PlayerIOEvent.ROOM_JOIN,onRoomJoin);
			addContextListener(PlayerIOEvent.ROOM_LEFT,onRoomLeft);
			addContextListener(PlayerIOEvent.PLAYERS_LIST,onPlayersList);
			
			
			
		}
		
		
		private function onPlayersList(e:PlayerIOEvent):void
		{
			var id:uint;
			var name:String;
			var numPlayers:int=e.message.getInt(0);
			
			
			//create new usernames in the list 
			for(var i:int=0;i<e.message.length;i+=6)
			{
				id=e.message.getUInt(i);
				name=e.message.getString(i+1);
				players[id]={label:name,value:id,inx:view.userList.dataProvider.length};
				view.userList.dataProvider.addItem(players[id]);
			}
		}
		
		
		
		private function onRoomJoin(e:PlayerIOEvent):void
		{
			if(players[e.id]==undefined)
			{
		    players[e.id]={label:e.name,value:e.id,inx:view.userList.dataProvider.length};
			view.userList.dataProvider.addItem(players[e.id]);
			}
		}
		
		private function onRoomLeft(e:PlayerIOEvent):void
		{
		   var item:Object=players[e.id];
			view.userList.dataProvider.removeItemAt(item.inx);
		}
		
		private function onChatMessage(e:PlayerIOEvent):void
		{
			
			view.chatTextArea.appendText("\n<"+e.name+">"+e.message.getString(2));
		}
		
		private function onChatSend(e:ChatViewEvent):void
		{
			var m:Message;
			
			
			m=playerIOService.connection.createMessage(PlayerIOMessages.CHAT,e.message);
			
			playerIOService.sendMessage(m);
		}
	   
	}
}