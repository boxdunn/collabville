package com.collabville.core.utils
{
	import com.collabville.core.components.IMapEntity;
	import com.collabville.core.components.MapEntity;
	
	import flash.geom.Point;

	public class GridUtils
	{
		
		public static function getEntity ( type:Class, grid:Vector.<uint>, row:uint, column:uint, offset:Point = null ):IMapEntity {
			var entity:IMapEntity = new MapEntity(new type());
			entity.occupancyGrid = grid;
			entity.offset = offset == null ? new Point() : offset;
			entity.column = column;
			entity.row = row;
			
			return entity;
		}
		
		public static function getRelativeGridPoint ( index:uint, row:uint, column:uint ):Point {
			var point:Point = new Point(column, row);			
			var offset:Boolean = row % 2 == 1;
			
			if ( offset ) {
				switch ( index ) {
					case 0:
						point.x = Math.max(0, point.x - 1);
						break;
					case 5:
					case 7:
					case 8:
						point.x++;
						break;
					default:
						break;
				}
			} else {
				switch ( index ) {
					case 0:
					case 1:
					case 3:
						point.x = Math.max(0, point.x - 1);
						break;
					case 5:
					case 7:
						break;
					case 8:
						point.x++;
						break;
					default:
						break;
				}
				
			}
				
			switch ( index ) {
				case 2:
					point.y = Math.max(0, point.y - 2);
					break;
				case 1:
				case 5:
					point.y = Math.max(0, point.y - 1);
					break;
				case 3:
				case 7:
					point.y++;
					break;
				case 6:
					point.y += 2;
					break;
				default:
					break;
			}
			
			if ( index > 8 )
				point.x = point.y = -1;

			return point;
		}
	}
}