package com.collabville.core.rl.models.maps
{
	public class OccupancyGridTypes
	{
		public static function get BOTTOM_ROW ():Vector.<uint> {
			return Vector.<uint>([0, 0, 0, 0, 0, 0, 1, 1, 1]);
		}
		
		public static function get CENTER ():Vector.<uint> {
			return Vector.<uint>([0, 0, 0, 0, 1, 0, 0, 0, 0]);
		}
		
		public static function get FULL ():Vector.<uint> {
			return Vector.<uint>([1, 1, 1, 1, 1, 1, 1, 1, 1]);
		}
		
		public static function get LEFT_COLUMN ():Vector.<uint> {
			return Vector.<uint>([1, 0, 0, 1, 0, 0, 1, 0, 0]);
		}
		
		public static function get MID_COLUMN ():Vector.<uint> {
			return Vector.<uint>([0, 1, 0, 0, 1, 0, 0, 1, 0]);
		}
		
		public static function get MID_ROW ():Vector.<uint> {
			return Vector.<uint>([0, 0, 0, 1, 1, 1, 0, 0, 0]);
		}
		
		public static function get RIGHT_COLUMN ():Vector.<uint> {
			return Vector.<uint>([0, 0, 1, 0, 0, 1, 0, 0, 1]);
		}
		
		public static function get RIGHT_MID_ROW ():Vector.<uint> {
			return Vector.<uint>([0, 0, 0, 0, 1, 1, 0, 0, 0]);
		}
		
		public static function get RIGHT_TOP_ROW ():Vector.<uint> {
			return Vector.<uint>([0, 1, 1, 0, 0, 0, 0, 0, 0]);
		}
		
		public static function get TOP_ROW ():Vector.<uint> {
			return Vector.<uint>([1, 1, 1, 0, 0, 0, 0, 0, 0]);
		}
		
		public static function get UPPER_MID_COLUMN ():Vector.<uint> {
			return Vector.<uint>([0, 1, 0, 0, 1, 0, 0, 0, 0]);
		}
	}
}