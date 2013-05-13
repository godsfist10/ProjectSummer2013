package  
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import flash.media.SoundMixer;
	import flash.geom.ColorTransform;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import content.*;
	import includes.*;
	
	public class Game_Production_Project extends MovieClip 
	{
		public static var sample:Game_Production_Project_Game;
		
		public function Game_Production_Project() 
		{
			global.init(stage,Game_Production_Project,true);
			embed_images.init();
			sample = new Game_Production_Project_Game();
			addChild(sample);
			sample.init();
		}
		
	}

}