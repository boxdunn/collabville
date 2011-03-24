package com.collabville.core.rl.models.maps
{
	import com.collabville.core.assets.fxg.Android;
	import com.collabville.core.assets.fxg.BlueTable;
	import com.collabville.core.assets.fxg.Gingerbread;
	import com.collabville.core.assets.fxg.Honeycomb;
	import com.collabville.core.assets.fxg.LeftGoat;
	import com.collabville.core.assets.fxg.Net;
	import com.collabville.core.assets.fxg.RedTable;
	import com.collabville.core.assets.fxg.RightGoat;
	import com.collabville.core.assets.fxg.Segway;
	import com.collabville.core.assets.fxg.YellowTable;
	import com.collabville.core.components.ICharacterEntity;
	import com.collabville.core.components.IMapEntity;
	import com.collabville.core.utils.GridUtils;
	
	import flash.geom.Point;

	public class GoogleplexData implements IMapData
	{		
		public function get inaccessiblePoints ():Vector.<Point> {
			var points:Vector.<Point> = new Vector.<Point>();
			
			points.push(new Point(7,0));
			points.push(new Point(8,0));
			points.push(new Point(9,0));
			points.push(new Point(10,0));
			points.push(new Point(7,1));
			points.push(new Point(8,1));
			points.push(new Point(9,1));
			points.push(new Point(10,1));
			points.push(new Point(8,2));
			points.push(new Point(9,2));
			points.push(new Point(10,2));
			points.push(new Point(8,3));
			points.push(new Point(9,3));
			points.push(new Point(10,3));
			points.push(new Point(9,4));
			points.push(new Point(10,4));
			points.push(new Point(9,5));
			points.push(new Point(10,5));
			points.push(new Point(10,6));
			points.push(new Point(10,7));
			
			return points;
		}
		
		public function get npcCharacters ():Vector.<ICharacterEntity> {
			return null;
		}
		
		public function get staticObjects ():Vector.<IMapEntity> {
			var objects:Vector.<IMapEntity> = new Vector.<IMapEntity>();
			objects.push(GridUtils.getEntity(Android, OccupancyGridTypes.CENTER, 6, 2));
			objects.push(GridUtils.getEntity(LeftGoat, OccupancyGridTypes.CENTER, 7, 1));
			objects.push(GridUtils.getEntity(RightGoat, OccupancyGridTypes.CENTER, 8, 4));
			objects.push(GridUtils.getEntity(Segway, OccupancyGridTypes.CENTER, 15, 0));
			objects.push(GridUtils.getEntity(Honeycomb, OccupancyGridTypes.MID_ROW, 12, 8));
			objects.push(GridUtils.getEntity(Segway, OccupancyGridTypes.CENTER, 8, 9));
			objects.push(GridUtils.getEntity(RedTable, OccupancyGridTypes.CENTER, 21, 3));
			objects.push(GridUtils.getEntity(Net, OccupancyGridTypes.MID_ROW, 19, 0));
			objects.push(GridUtils.getEntity(BlueTable, OccupancyGridTypes.CENTER, 21, 5));
			objects.push(GridUtils.getEntity(Gingerbread, OccupancyGridTypes.MID_COLUMN, 20, 10));
			objects.push(GridUtils.getEntity(RedTable, OccupancyGridTypes.CENTER, 24, 6));
			objects.push(GridUtils.getEntity(YellowTable, OccupancyGridTypes.CENTER, 24, 8));
			return objects;
		}
		
		public function get tileHeight ():Number {
			return TileSize.HEIGHT;
		}
		
		public function get tileWidth ():Number {
			return TileSize.WIDTH;
		}
	}
}