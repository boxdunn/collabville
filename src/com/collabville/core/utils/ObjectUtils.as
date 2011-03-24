package com.collabville.core.utils
{
	import flash.utils.describeType;

	public class ObjectUtils
	{
		public static function mapObject ( object:Object, asClass:Class ):* {
			var baseClass:* = new asClass();
			var type:XML = describeType(baseClass);
			
			for each ( var accessor:XML in type.accessor ) {
				var name:String = accessor.@name;
				if ( accessor.@access == "readwrite" && accessor.@type != "Class" ) {
					if ( object.hasOwnProperty(name) ) {
						baseClass[name] = object[name];
					}
				}
			}
			
			return baseClass;
		}
		
		public static function mapObjects ( objects:Array, asClass:Class ):Array {
			var classes:Array = [];
			var n:uint = objects.length;
			
			for ( var i:uint = 0; i < n; i++ )
				classes.push(mapObject(objects[i], asClass));
			
			return classes;
		}
	}
}