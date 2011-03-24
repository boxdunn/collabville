package com.collabville.core.rl.context
{
	import com.collabville.core.rl.commands.StartupCommand;
	import com.collabville.core.services.facebook.FacebookService;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	
	public class ApplicationContext extends Context
	{		
		override public function startup ():void {
			commandMap.mapEvent(ContextEvent.STARTUP, StartupCommand, ContextEvent, true);
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
		}
	}
}