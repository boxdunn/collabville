package com.collabville.core.rl.models.maps
{
	import com.collabville.core.assets.fxg.BoardroomTable;
	import com.collabville.core.assets.fxg.Chair;
	import com.collabville.core.assets.fxg.Cooler;
	import com.collabville.core.assets.fxg.LeftDesk;
	import com.collabville.core.assets.fxg.LeftWall;
	import com.collabville.core.assets.fxg.LeftWallShelf;
	import com.collabville.core.assets.fxg.RightDesk;
	import com.collabville.core.assets.fxg.RightWall;
	import com.collabville.core.components.ICharacterEntity;
	import com.collabville.core.components.IMapEntity;
	import com.collabville.core.utils.GridUtils;
	
	import flash.geom.Point;

	public class WorkvilleData implements IMapData
	{
		public function get inaccessiblePoints ():Vector.<Point> {
			return new Vector.<Point>();
		}
		
		public function get npcCharacters ():Vector.<ICharacterEntity> {
			return new Vector.<ICharacterEntity>();
		}
		
		public function get staticObjects ():Vector.<IMapEntity> {
			var objects:Vector.<IMapEntity> = new Vector.<IMapEntity>();
			
			objects = objects.concat(upperLeftSection);
			objects = objects.concat(upperRightSection);
			objects = objects.concat(topSection);
			objects = objects.concat(lowerRightWall);
			objects = objects.concat(midLeftSection);
			objects = objects.concat(bottomSection);
			
			return objects;
		}
		
		public function get tileHeight ():Number {
			return TileSize.HEIGHT;
		}
		
		public function get tileWidth ():Number {
			return TileSize.WIDTH;
		}
		
		private function get bottomSection ():Vector.<IMapEntity> {
			var lowerRightOffset:Point = new Point(10, 4);
			var lowerDeskOffset:Point = new Point(0, 30);
			
			var sequence:Vector.<IMapEntity> = new Vector.<IMapEntity>();
			
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 18, 4));
			
			sequence.push(GridUtils.getEntity(RightDesk, OccupancyGridTypes.TOP_ROW, 22, 3));
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 22, 2));
			sequence.push(GridUtils.getEntity(RightDesk, OccupancyGridTypes.TOP_ROW, 24, 1, lowerDeskOffset));
			
			sequence.push(GridUtils.getEntity(RightWall, OccupancyGridTypes.RIGHT_MID_ROW, 20, 4, lowerRightOffset));
			sequence.push(GridUtils.getEntity(RightWall, OccupancyGridTypes.RIGHT_MID_ROW, 22, 3, lowerRightOffset));
			sequence.push(GridUtils.getEntity(RightWall, OccupancyGridTypes.RIGHT_MID_ROW, 24, 2, lowerRightOffset));
			
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 20, 5));
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 22, 6));
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 24, 7));
			
			sequence.push(GridUtils.getEntity(LeftDesk, OccupancyGridTypes.TOP_ROW, 24, 4));
			
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 24, 3));
			
			return sequence;
		}
		
		private function get lowerRightWall ():Vector.<IMapEntity> {
			var sequence:Vector.<IMapEntity> = new Vector.<IMapEntity>();
			
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 15, 6));
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 17, 7));
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 19, 8));
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 21, 9));
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 23, 10));
			
			return sequence;
		}
		
		private function get midLeftSection ():Vector.<IMapEntity> {
			var lowerRightOffset:Point = new Point(10, 4);
			var lowerDeskOffset:Point = new Point(0, 30);
			
			var sequence:Vector.<IMapEntity> = new Vector.<IMapEntity>();
			
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 10, 0));
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 12, 1));
			
			sequence.push(GridUtils.getEntity(RightWall, OccupancyGridTypes.RIGHT_MID_ROW, 14, 1, lowerRightOffset));
			sequence.push(GridUtils.getEntity(RightWall, OccupancyGridTypes.RIGHT_MID_ROW, 16, 0, lowerRightOffset));
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 14, 2));
			sequence.push(GridUtils.getEntity(LeftDesk, OccupancyGridTypes.TOP_ROW, 18, 1));
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 18, 0));
			
			sequence.push(GridUtils.getEntity(Chair, OccupancyGridTypes.CENTER, 16, 1));
			
			return sequence;
		}
		
		private function get topSection ():Vector.<IMapEntity> {
			var lowerRightOffset:Point = new Point(10, 4);
			var lowerDeskOffset:Point = new Point(0, 30);
			
			var sequence:Vector.<IMapEntity> = new Vector.<IMapEntity>();
			
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 0, 7));
			sequence.push(GridUtils.getEntity(RightDesk, OccupancyGridTypes.TOP_ROW, 2, 6, lowerDeskOffset));
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 4, 5));
			sequence.push(GridUtils.getEntity(RightDesk, OccupancyGridTypes.TOP_ROW, 6, 4, lowerDeskOffset));
			
			sequence.push(GridUtils.getEntity(RightWall, OccupancyGridTypes.RIGHT_MID_ROW, 0, 8, lowerRightOffset));
			sequence.push(GridUtils.getEntity(RightWall, OccupancyGridTypes.RIGHT_MID_ROW, 2, 7, lowerRightOffset));
			sequence.push(GridUtils.getEntity(RightWall, OccupancyGridTypes.RIGHT_MID_ROW, 4, 6, lowerRightOffset));
			sequence.push(GridUtils.getEntity(RightWall, OccupancyGridTypes.RIGHT_MID_ROW, 6, 5, lowerRightOffset));
			sequence.push(GridUtils.getEntity(RightWall, OccupancyGridTypes.RIGHT_MID_ROW, 8, 4, lowerRightOffset));
			
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 8, 3));
			
			return sequence;
		}
		
		private function get upperLeftSection ():Vector.<IMapEntity> {
			var lowerRightOffset:Point = new Point(10, 4);
			
			var sequence:Vector.<IMapEntity> = new Vector.<IMapEntity>();
			
			sequence.push(GridUtils.getEntity(RightWall, OccupancyGridTypes.RIGHT_MID_ROW, 0, 2, lowerRightOffset));
			sequence.push(GridUtils.getEntity(RightWall, OccupancyGridTypes.RIGHT_MID_ROW, 2, 1, lowerRightOffset));
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 0, 3));
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 2, 0));
			sequence.push(GridUtils.getEntity(LeftDesk, OccupancyGridTypes.TOP_ROW, 4, 2));
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 4, 1));
			
			sequence.push(GridUtils.getEntity(Chair, OccupancyGridTypes.CENTER, 2, 2));
			
			return sequence;
		}
		
		private function get upperRightSection ():Vector.<IMapEntity> {
			var upperRightOffset:Point = new Point(11, 11);
			var shelfOffset:Point = new Point(8, 4);
			var tableOffset:Point = new Point(0, 30);
				
			var sequence:Vector.<IMapEntity> = new Vector.<IMapEntity>();
			sequence.push(GridUtils.getEntity(RightWall, OccupancyGridTypes.RIGHT_MID_ROW, 3, 10, upperRightOffset));
			sequence.push(GridUtils.getEntity(RightWall, OccupancyGridTypes.RIGHT_MID_ROW, 5, 9, upperRightOffset));
			
			sequence.push(GridUtils.getEntity(LeftDesk, OccupancyGridTypes.TOP_ROW, 5, 10, upperRightOffset));
			
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 7, 9));
			sequence.push(GridUtils.getEntity(LeftWall, OccupancyGridTypes.UPPER_MID_COLUMN, 9, 10));
			
			sequence.push(GridUtils.getEntity(Cooler, OccupancyGridTypes.CENTER, 6, 9));
			
			sequence.push(GridUtils.getEntity(LeftWallShelf, OccupancyGridTypes.UPPER_MID_COLUMN, 9, 9, shelfOffset));
			sequence.push(GridUtils.getEntity(LeftWallShelf, OccupancyGridTypes.UPPER_MID_COLUMN, 11, 10));
			
			sequence.push(GridUtils.getEntity(BoardroomTable, OccupancyGridTypes.FULL, 12, 9, tableOffset));
			sequence.push(GridUtils.getEntity(Chair, OccupancyGridTypes.CENTER, 14, 10));
			
			return sequence;
		}
	}
}