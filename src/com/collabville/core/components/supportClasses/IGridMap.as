package com.collabville.core.components.supportClasses
{
	import com.collabville.core.components.IMapEntity;
	import com.collabville.core.components.IMapMarker;
	import com.collabville.core.rl.models.maps.IMapData;
	
	import mx.core.IVisualElement;
	
	public interface IGridMap extends IVisualElement, IDisposable
	{
		function addEntity ( entity:IMapEntity, row:uint, column:uint ):Boolean;
		function getMarkerAt ( row:uint, column:uint ):IMapMarker;
		function isPointAccessible ( row:uint, column:uint ):Boolean;
		function isPointOccupied ( row:uint, column:uint ):Boolean;
		function get mapData ():IMapData;
		function positionEntity ( entity:IMapEntity, row:uint, column:uint, animate:Boolean = false ):void;
		function removeEntity ( entity:IMapEntity ):void;
		function setEntityDepth ( entity:IMapEntity ):void;
		function setPointAccessibility ( row:uint, column:uint, accessible:Boolean ):void;
	}
}