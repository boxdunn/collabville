package com.collabville.core.components
{
	import com.collabville.core.rl.models.CharacterModel;

	public interface ICharacterEntity extends IMapEntity
	{
		function get direction ():String;
		function set direction ( value:String ):void;
		function get model ():CharacterModel;
		function set model ( value:CharacterModel ):void;
	}
}