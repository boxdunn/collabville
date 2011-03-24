package com.collabville.core.components.supportClasses
{
	import com.collabville.core.components.IMapEntity;
	import com.collabville.core.components.IMapMarker;
	import com.collabville.core.components.MapEntity;
	import com.collabville.core.components.PositionMarker;
	import com.collabville.core.rl.models.maps.IMapData;
	import com.collabville.core.utils.GridUtils;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.controls.Image;
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	
	public class GridMapBase extends Group implements IGridMap
	{
		[Bindable] public var base:Image;
		
		private var _mapData:IMapData;
		
		private var entities:Array = [];
		private var markers:Array = [];
		
		private var offset:Point = new Point();
		
		public function GridMapBase () {
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, creationComplete, false, 0, true);
		}
		
		public function dispose ():void {
			removeAllEntities();
			removeAllMarkers();
		}

		public function addEntity ( entity:IMapEntity, row:uint, column:uint ):Boolean {
			if ( !isOccupancyGridAccessible(entity.occupancyGrid, row, column) ) return false;
			
			addElement(entity);
			positionEntity(entity, row, column);
			setEntityOccupancy(entity, row, column);
			entities.push(entity);
			return true;
		}
		
		public function getMarkerAt ( row:uint, column:uint ):IMapMarker {
			if ( row >= markers.length ) return null;
			
			var markerRow:Array = markers[row];
			
			if ( column >= markerRow.length ) return null;
			
			return markerRow[column];
		}
		
		public function isOccupancyGridAccessible ( grid:Vector.<uint>, row:uint, column:uint, strict:Boolean = false ):Boolean {
			var n:uint = grid.length;
			for ( var i:uint = 0; i < n; i++ ) {
				if ( grid[i] == 0 ) continue;
				var point:Point = GridUtils.getRelativeGridPoint(i, row, column);
				
				var marker:IMapMarker = getMarkerAt(point.y, point.x);
				if ( !marker ) {
					if ( strict ) return false;
					continue;
				}
				
				if ( strict && marker.occupied ) return false;
			}
			
			return true;
		}
		
		public function isPointAccessible ( row:uint, column:uint ):Boolean {			
			var marker:IMapMarker = getMarkerAt(row, column);
			return marker == null ? false : marker.accessible;
		}
		
		public function isPointOccupied ( row:uint, column:uint ):Boolean {
			if ( !isPointAccessible(row, column) ) return false;
			
			var marker:IMapMarker = getMarkerAt(row, column);
			return marker == null ? false : marker.occupied;
		}
		
		public function get mapData ():IMapData {
			return _mapData;
		}
		
		public function set mapData ( value:IMapData ):void {
			_mapData = value;
			offset.x = -(mapData.tileWidth / 2);
		}
		
		public function positionEntity ( entity:IMapEntity, row:uint, column:uint, animate:Boolean = false ):void {
			var marker:IMapMarker = getMarkerAt(row, column);
			if ( !marker ) return;
			
			var center:Point = marker.center;
			center.y += (mapData.tileHeight / 2); 
			
			center.offset(entity.offset.x, entity.offset.y);
			
			setPointAccessibility(entity.row, entity.column, true);
			setPointOccupancy(entity.row, entity.column, null);
			
			entity.row = row;
			entity.column = column;
			
			setPointAccessibility(entity.row, entity.column, false);
			setPointOccupancy(entity.row, entity.column, entity);
			
			entity.moveToPosition(center.x, center.y, animate);
		}
		
		public function removeEntity ( entity:IMapEntity ):void {
			var idx:int = entities.indexOf(entity);
			if ( idx != -1 )
				entities.splice(idx, 1);
			
			if ( this.contains(DisplayObject(entity)) )
				removeElement(entity);
		}
		
		public function setEntityDepth ( entity:IMapEntity ):void {
			var points:Array = [0, 1, 2, 5];
			var n:uint = points.length;
			
			var depth:int = getElementIndex(entity);
			
			for ( var i:uint = 0; i < n; i++ ) {
				var point:Point = GridUtils.getRelativeGridPoint(points[i], entity.row, entity.column);
				var marker:IMapMarker = getMarkerAt(point.y, point.x);
				
				if ( !marker || !marker.occupied ) continue;
				
				if ( marker.occupant == entity ) continue;
				
				depth = Math.max(depth, getElementIndex(marker.occupant));				
			}
			
			setElementIndex(entity, depth);
			
			points = [3, 6, 7];
			n = points.length;
			
			for ( i = 0; i < n; i++ ) {
				point = GridUtils.getRelativeGridPoint(points[i], entity.row, entity.column);
				marker = getMarkerAt(point.y, point.x);
				
				if ( !marker || !marker.occupied ) continue;
				
				if ( marker.occupant == entity ) continue;
				
				depth = Math.min(depth, getElementIndex(marker.occupant));
			}
			
			setElementIndex(entity, depth);
		}
		
		public function setPointAccessibility ( row:uint, column:uint, accessible:Boolean ):void {
			var marker:IMapMarker = getMarkerAt(row, column);
			if ( marker )
				marker.accessible = accessible;
		}
		
		public function setPointOccupancy ( row:uint, column:uint, occupant:IVisualElement = null ):void {
			var marker:IMapMarker = getMarkerAt(row, column);
			if ( marker )
				marker.occupant = occupant;
		}
		
		private function createMarker ( position:Point, row:uint, column:uint ):PositionMarker {
			var marker:PositionMarker = new PositionMarker();
			marker.row = row;
			marker.column = column;
			marker.width = mapData.tileWidth;
			marker.height = mapData.tileHeight;
			marker.x = position.x;
			marker.y = position.y;
			marker.draw();
			return marker;
		}
		
		private function creationComplete ( event:FlexEvent ):void {
			this.removeEventListener(FlexEvent.CREATION_COMPLETE, creationComplete);
			mapGrid();
			setGridAccessibility();
		}
		
		private function isPointInBounds ( row:uint, column:uint ):Boolean {
			var marker:IMapMarker = getMarkerAt(row, column);
			if ( !marker ) return false;
			
			var parentBounds:Rectangle = base.getBounds(this);
			var bounds:Rectangle = marker.getBounds(this);
			
			return parentBounds.containsRect(bounds);
		}
		
		private function mapGrid ():void {
			var start:Point = offset.clone();
			markers = [];
			
			var fill:uint;
			var row:uint = 0;
			
			while ( start.y < this.height ) {
				var markerRow:Array = [];
				markers[row] = markerRow;
				var column:uint = 0;
				while ( start.x < this.width ) {
					var marker:PositionMarker = createMarker(start, row, column);
					markerRow[column] = marker;
					addElement(marker);
					start.x += mapData.tileWidth;
					column++;
				}
				
				start.x = row % 2 == 0 ? 0 : offset.x;
				start.y += mapData.tileHeight / 2;
				row++;
			}
		}
		
		private function removeAllEntities ():void {
			while ( entities.length > 0 ) {
				var entity:IMapEntity = entities.shift();
				if ( !entity ) continue;
				
				if ( this.contains(DisplayObject(entity)) )
					removeElement(entity);
				
				entity.dispose();
				entity = null;
			}
		}
		
		private function removeAllMarkers ():void {
			while ( markers.length > 0 ) {
				var marker:IMapMarker = markers.shift();
				if ( !marker ) continue;
				
				if ( this.contains(DisplayObject(marker)) )
					removeElement(marker);
				
				marker.dispose();
				marker = null;
			}				
		}
		
		private function setEntityOccupancy ( entity:IMapEntity, row:uint, column:uint ):void {
			var grid:Vector.<uint> = entity.occupancyGrid;
			var n:uint = grid.length;
			
			for ( var i:uint = 0; i < n; i++ ) {
				
				if ( grid[i] == 0 ) continue;
				var point:Point = GridUtils.getRelativeGridPoint(i, row, column);
				
				var marker:IMapMarker = getMarkerAt(point.y, point.x);
				if ( !marker ) continue;
				
				marker.occupant = entity;
			}
		}
		
		private function setGridAccessibility ():void {
			var n:uint = markers.length;
			for ( var i:uint = 0; i < n; i++ ) {
				var row:Array = markers[i];
				var m:uint = row.length;
				for ( var j:uint = 0; j < m; j++ ) {
					setPointAccessibility(i, j, isPointInBounds(i, j));
				}
			}
		}
	}
}