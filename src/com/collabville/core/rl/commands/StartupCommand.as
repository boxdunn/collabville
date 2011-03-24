package com.collabville.core.rl.commands
{
	import com.collabville.core.components.GoogleplexMap;
	import com.collabville.core.components.PlayerCharacter;
	import com.collabville.core.components.TheCloudMap;
	import com.collabville.core.components.WorkvilleMap;
	import com.collabville.core.components.supportClasses.IGridMap;
	import com.collabville.core.rl.actors.PlayerIOServiceActor;
	import com.collabville.core.rl.mediators.ChatViewMediator;
	import com.collabville.core.rl.mediators.CollabVilleMediator;
	import com.collabville.core.rl.mediators.MapMediator;
	import com.collabville.core.rl.mediators.PlayerCharacterMediator;
	import com.collabville.core.rl.views.ChatView;
	import com.collabville.core.utils.KeyIndex;
	
	import org.robotlegs.mvcs.Command;
	
	import playerio.PlayerIO;
	
	public class StartupCommand extends Command
	{
		override public function execute ():void {
			injector.mapSingleton(KeyIndex);
			injector.mapSingleton(PlayerCharacter);
			injector.mapSingletonOf(PlayerIOServiceActor, PlayerIOServiceActor);
			
			mediatorMap.mapView(ChatView,ChatViewMediator);
			mediatorMap.mapView(CollabVille, CollabVilleMediator);
			mediatorMap.mapView(PlayerCharacter, PlayerCharacterMediator);
			
			
			mediatorMap.mapView(GoogleplexMap, MapMediator, IGridMap);
			mediatorMap.mapView(TheCloudMap, MapMediator, IGridMap);
			mediatorMap.mapView(WorkvilleMap, MapMediator, IGridMap);
		}
	}
}