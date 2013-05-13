package includes 
{
	import flash.display.Stage;
	/**
	 * ...
	 * @author Alexander Beauchesne
	 */
	public dynamic class global
	{
		public static var STAGE:Stage;
		public static var ROOT:Class;
		public static var DEVELOPER:Boolean;
		
		public static var width:uint;
		public static var height:uint;
		
		public static var paused:Boolean;
		
		public static function init(_stage:Stage,_root:Class,_developer:Boolean):void
		{
			STAGE = _stage;
			ROOT = _root;
			DEVELOPER = _developer;
			
			width = STAGE.stageWidth;
			height = STAGE.stageHeight;
			
			paused = false;
		}
		
	}

}