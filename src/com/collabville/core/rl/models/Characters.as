package com.collabville.core.rl.models
{
	import com.collabville.core.assets.fxg.characters.*;

	public class Characters
	{
		public static function get levieModel ():CharacterModel {
			var model:CharacterModel = new CharacterModel();
			model.bottomLeftDisplay = new LevieBL();
			model.bottomRightDisplay = new LevieBR();
			model.topLeftDisplay = new LevieTL();
			model.topRightDisplay = new LevieTR();
			return model;
		}
		
		public static function get androidModel ():CharacterModel {
			var model:CharacterModel = new CharacterModel();
			model.bottomLeftDisplay = new AndroidBL();
			model.bottomRightDisplay = new AndroidBR();
			model.topLeftDisplay = new AndroidTL();
			model.topRightDisplay = new AndroidTR();
			return model;
		}
		
		public static function get lumberghModel ():CharacterModel {
			var model:CharacterModel = new CharacterModel();
			model.bottomLeftDisplay = new LumbBL();
			model.bottomRightDisplay = new LumbBR();
			model.topLeftDisplay = new LumbTL();
			model.topRightDisplay = new LumbTR();
			return model;
		}
		
		public static function get linkModel ():CharacterModel {
			var model:CharacterModel = new CharacterModel();
			model.bottomLeftDisplay = new LinkBL();
			model.bottomRightDisplay = new LinkBR();
			model.topLeftDisplay = new LinkTL();
			model.topRightDisplay = new LinkTR();
			return model;
		}
		
		public static function get zuckerbergModel ():CharacterModel {
			var model:CharacterModel = new CharacterModel();
			model.bottomLeftDisplay = new ZuckBL();
			model.bottomRightDisplay = new ZuckBR();
			model.topLeftDisplay = new ZuckTL();
			model.topRightDisplay = new ZuckTR();
			return model;
		}
		
		public static function get miltonModel ():CharacterModel {
			var model:CharacterModel = new CharacterModel();
			model.bottomLeftDisplay = new MiltonBL();
			model.bottomRightDisplay = new MiltonBR();
			model.topLeftDisplay = new MiltonTL();
			model.topRightDisplay = new MiltonTR();
			return model;
		}
		
		public static function get pandaModel ():CharacterModel {
			var model:CharacterModel = new CharacterModel();
			model.bottomLeftDisplay = new PandaBL();
			model.bottomRightDisplay = new PandaBR();
			model.topLeftDisplay = new PandaTL();
			model.topRightDisplay = new PandaTR();
			return model;
		}
		
		public static function get ballmerModel ():CharacterModel {
			var model:CharacterModel = new CharacterModel();
			model.bottomLeftDisplay = new BallmerBL();
			model.bottomRightDisplay = new BallmerBR();
			model.topLeftDisplay = new BallmerTL();
			model.topRightDisplay = new BallmerTR();
			return model;
		}
		
		public static function get jobsModel ():CharacterModel {
			var model:CharacterModel = new CharacterModel();
			model.bottomLeftDisplay = new JobsBL();
			model.bottomRightDisplay = new JobsBR();
			model.topLeftDisplay = new JobsTL();
			model.topRightDisplay = new JobsTR();
			return model;
		}
	}
}