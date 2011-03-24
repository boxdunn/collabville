package com.collabville.core.rl.models.maps
{
	import com.collabville.core.components.ICharacterEntity;
	import com.collabville.core.components.IMapEntity;
	
	import flash.geom.Point;

	public interface IMapData
	{
		function get inaccessiblePoints ():Vector.<Point>;
		function get npcCharacters ():Vector.<ICharacterEntity>;
		function get staticObjects ():Vector.<IMapEntity>;
		function get tileHeight ():Number;
		function get tileWidth ():Number;		
	}
}