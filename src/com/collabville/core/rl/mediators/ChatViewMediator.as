package com.collabville.core.rl.mediators
{
	import com.collabville.core.rl.actors.PlayerIOServiceActor;
	import com.collabville.core.rl.events.ChatViewEvent;
	import com.collabville.core.rl.events.PlayerIOEvent;
	import com.collabville.core.rl.views.ChatView;
	
	import org.robotlegs.mvcs.Mediator;
	
	
	
	public class ChatViewMediator extends Mediator
	{
		[Inject] public var view:ChatView;
		[Inject] public var playerIOService:PlayerIOServiceActor;
		
		public function ChatViewMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			addViewListener(ChatViewEvent.SEND,onChatSend);
			addContextListener(PlayerIOEvent.CHAT_MESSAGE,onChatMessage);
			addContextListener(PlayerIOEvent.ROOM_JOIN,onRoomJoin);
			addContextListener(PlayerIOEvent.ROOM_LEFT,onRoomLeft);
		}
		
		private function onRoomJoin(e:PlayerIOEvent):void
		{
			view.userList.dataProvider.addItem({label:e.name,value:e.id});
		}
		
		private function onRoomLeft(e:PlayerIOEvent):void
		{
			//TODO remove item with id
		}
		
		private function onChatMessage(e:PlayerIOEvent):void
		{
			
			view.chatTextArea.appendText("\n<"+e.name+">"+e.message.getString(2));
		}
		
		private function onChatSend(e:ChatViewEvent):void
		{
			playerIOService.sendMessage(e.message);
		}
	   
	}
}