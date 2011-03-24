package com.collabville.core.rl.models.maps
{
	import com.collabville.core.components.ICharacterEntity;
	import com.collabville.core.components.IMapEntity;
	
	import flash.geom.Point;
	
	public class AppleStoreData implements IMapData
	{
		
		public function get inaccessiblePoints ():Vector.<Point> {
			return null;
		}
		
		public function get npcCharacters ():Vector.<ICharacterEntity> {
			return null;
		}
		
		public function get staticObjects ():Vector.<IMapEntity> {
			return null;
		}
		
		public function get tileHeight ():Number {
			return TileSize.HEIGHT;
		}
		
		public function get tileWidth ():Number {
			return TileSize.WIDTH;
		}
	}
}