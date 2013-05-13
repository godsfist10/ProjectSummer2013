package includes
{
	import flash.media.Sound;
	import flash.utils.Dictionary;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Alexander Beauchesne
	 */
	public class dicts 
	{
		
		public static var bitmaps:Dictionary = new Dictionary();
		
		public static function get_bitmap(source:Class):BitmapData
		{
			if (bitmaps[source]) return bitmaps[source];
			return (bitmaps[source] = (new source).bitmapData);
		}
		
		public static var sounds:Dictionary = new Dictionary();
		
		public static function get_sound(source:Class):Sound
		{
			if (sounds[source]) return sounds[source];
			return (sounds[source] = (new source));
		}
		
	}

}