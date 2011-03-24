package com.collabville.core.rl.models.maps
{
	import com.collabville.core.components.ICharacterEntity;
	import com.collabville.core.components.IMapEntity;
	
	import flash.geom.Point;
	
	public class TheCloudData implements IMapData
	{
		
		public function get inaccessiblePoints ():Vector.<Point> {
			var points:Vector.<Point> = new Vector.<Point>();
			
			points.push(new Point(10,0));
			points.push(new Point(9,1));
			points.push(new Point(10,1));
			points.push(new Point(10,2));
			
			points.push(new Point(1,3));
			points.push(new Point(1,4));
			points.push(new Point(0,5));
			points.push(new Point(0,6));
			points.push(new Point(1,6));
			points.push(new Point(0,7));
			points.push(new Point(1,7));
			points.push(new Point(1,8));
			points.push(new Point(0,9));
			points.push(new Point(1,9));
			points.push(new Point(1,10));
			points.push(new Point(0,11));
			points.push(new Point(1,11));
			
			points.push(new Point(6,5));
			points.push(new Point(7,6));
			points.push(new Point(6,7));
			points.push(new Point(6,8));
			points.push(new Point(5,9));
			points.push(new Point(6,9));
			points.push(new Point(6,10));
			points.push(new Point(5,11));
			points.push(new Point(5,12));
			points.push(new Point(6,12));
			points.push(new Point(5,13));
			points.push(new Point(6,13));
			points.push(new Point(5,14));
			points.push(new Point(6,14));
			points.push(new Point(5,15));
			
			points.push(new Point(8,17));
			points.push(new Point(8,18));
			points.push(new Point(8,19));
			points.push(new Point(9,19));
			points.push(new Point(9,20));
			points.push(new Point(10,20));
			points.push(new Point(9,21));
			points.push(new Point(9,22));
			points.push(new Point(10,22));
			points.push(new Point(9,23));
			
			return points;
		}
		
		public function get npcCharacters():Vector.<ICharacterEntity>
		{
			return null;
		}
		
		public function get staticObjects():Vector.<IMapEntity>
		{
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