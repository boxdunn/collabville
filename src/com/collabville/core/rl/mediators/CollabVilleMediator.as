package com.collabville.core.rl.mediators
{
	import com.collabville.core.components.PlayerCharacter;
	import com.collabville.core.components.TheCloudMap;
	import com.collabville.core.components.WorkvilleMap;
	import com.collabville.core.components.supportClasses.IGridMap;
	import com.collabville.core.rl.actors.PlayerIOServiceActor;
	import com.collabville.core.rl.events.DataEvent;
	import com.collabville.core.rl.events.MapEvent;
	import com.collabville.core.rl.events.PlayerIOEvent;
	import com.collabville.core.rl.models.Characters;
	import com.collabville.core.rl.views.ChatView;
	
	import flash.display.InteractiveObject;
	
	import mx.core.UIComponent;
	import mx.managers.FocusManager;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class CollabVilleMediator extends Mediator
	{		
		[Inject] public var player:PlayerCharacter;
		[Inject] public var service:PlayerIOServiceActor;
		[Inject] public var view:CollabVille;
		
		private var accessToken:String;
		private var appID:String;
		private var gameID:String = "collabville-ri5m1gdqku2oxkfomdy7ig";
		private var showID:String;
		
		override public function onRegister ():void {			
			if ( view.parameters.hasOwnProperty("fb_access_token") )
				accessToken = view.parameters.fb_access_token;
			
			if ( view.parameters.hasOwnProperty("fb_application_id") )
				appID = view.parameters.fb_application_id;
			
			if ( view.parameters.hasOwnProperty("sitebox_gameid") )
				gameID = view.parameters.sitebox_gameid;
			
			if ( view.parameters.hasOwnProperty("querystring_id") )
				showID = view.parameters.querystring_id;
			
			//service.facebookOAuthPopup(view.stage, gameID);
			
			addContextListener(MapEvent.CHANGE, changeMap, DataEvent);
			addContextListener(PlayerIOEvent.INIT_CHAT,onInitChatView);
			initializePlayer();
			setMap(new TheCloudMap());
			
			service.playerIOconnect("mygame-qth4pauezekh9t62drhhsq","testuser"+Math.random());
			
		}
		
		private function onInitChatView(e:PlayerIOEvent):void
		{
			view.mapContainer.addElement(new ChatView());
		}
		
		private function changeMap ( event:DataEvent ):void {
			if ( event.data && event.data is Class ) {
				var mapClass:Class = Class(event.data);
				var map:IGridMap = new mapClass() as IGridMap;
				
				if ( map )
					setMap(map);
			}
		}
		
		private function initializePlayer ():void {
			player.model = Characters.lumberghModel;
			player.row = 5;
			player.column = 5;
		}
		
		private function setMap ( map:IGridMap ):void {
			view.mapContainer.removeAllElements();
			view.mapContainer.addElement(map);
		}
	}
}