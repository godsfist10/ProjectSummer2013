package content 
{
	/**
	 * ...
	 * @author Alexander Beauchesne for template
	 */
	public class embed_images
	{
		public static var rows:Array = new Array;
		public static var columns:Array = new Array;
		public static var frames:Array = new Array;
		
		//[Embed(source = "../../lib/gm_b_UIBox.png")]
		//public static var myvariable:Class;
		
		[Embed(source = "../../lib/colliderBack.png")]
		public static var collider:Class;
		[Embed(source = "../../lib/redbrick.png")]
		public static var brick:Class;
		
		public static function init():void
		{
			//add(myvariable);
			add(collider);
			add(brick);
		}
		
		public static function add(image:Class, _columns:uint = 1, _rows:uint = 1):void
		{
			columns[image] = _columns;
			rows[image] = _rows;
			frames[image] = _columns * _rows;
		}
	}

}