package  
{
	
	import flash.display.InterpolationMethod;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.ui.Mouse;
	import flash.utils.ByteArray;
	import flash.media.SoundMixer;
	import flash.geom.ColorTransform;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import content.*;
	import includes.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Character extends MovieClip 
	{
		protected var mPrevious:Point;
		protected var mCurrentPos:Point;
		protected var mVelocity:Point;
		protected var mAcceleration:Point;
		public var mCharacterArt:graphic;
		public var mBlockedVertical:Boolean, mBlockedHorizontal:Boolean;
		//private var 
		
		public function Character()
		{
		}
		
		public function Init(character:Class, xPos:int, yPos:int):void
		{
			mCharacterArt = new graphic(character);
			this.x = xPos;
			this.y = yPos;
			this.addChild(mCharacterArt);
		}
		
		
	}

}