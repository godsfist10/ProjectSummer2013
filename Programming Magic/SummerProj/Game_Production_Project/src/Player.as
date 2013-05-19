package  
{
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
	public class Player extends Character
	{			
		public var KeyWDown:Boolean;
		public var KeySDown:Boolean;
		public var KeyADown:Boolean;
		public var KeyDDown:Boolean;
		
		
		public function Player()
		{
			
		}
		
		override public function Init(character:Class, xPos:int, yPos:int) :void
		{
			mCharacterArt = new graphic(character);
			this.x = xPos;
			this.y = yPos;
			mPrevious = new Point(0,0);
			mVelocity = new Point (0, 0);
			mAcceleration = new Point (0, 0);
			mCurrentPos = new Point(xPos, yPos);
			this.addChild(mCharacterArt);
			onGround = false;
			KeyWDown = false;
			KeyADown = false;
			KeySDown = false;
			KeyDDown = false;
			
		
		}
		
		public function Update(gravity:Number):void
		{
			mPrevious.x = this.x;
			mPrevious.y = this.y;
			onGround = false;
			if ( KeyADown)
				mAcceleration.x -= 2;
			if (KeyDDown)
				mAcceleration.x += 2;
			mAcceleration.y += gravity;
			
			if ( !KeyADown && !KeyDDown)
			{
				mVelocity.x = 0;
				if ( mAcceleration.x < 0)
				mAcceleration.x++;
			else if (mAcceleration.x > 0)
				mAcceleration.x--;	
			}
				
			
			if ( mAcceleration.x > MAX_ACCELERATION.x)
				mAcceleration.x = MAX_ACCELERATION.x;
			if ( mAcceleration.x < MAX_ACCELERATION.x * -1)
				mAcceleration.x = MAX_ACCELERATION.x * -1;
			if ( mAcceleration.y > MAX_ACCELERATION.y)
				mAcceleration.y = MAX_ACCELERATION.y;
			if ( mAcceleration.y < MAX_ACCELERATION.y * -1)
				mAcceleration.y = MAX_ACCELERATION.y * -1;
			
			mVelocity.x += mAcceleration.x;
			mVelocity.y += mAcceleration.y;
				
			if ( mVelocity.x > MAX_SPEED.x)
				mVelocity.x = MAX_SPEED.x;
			if ( mVelocity.x < MAX_SPEED.x * -1)
				mVelocity.x = MAX_SPEED.x * -1;
			if ( mVelocity.y > MAX_SPEED.y)
				mVelocity.y = MAX_SPEED.y;
			if ( mVelocity.y < MAX_SPEED.y * -1)
				mVelocity.y = MAX_SPEED.y * -1;
			
			this.x += mVelocity.x;
			this.y += mVelocity.y;
			mCurrentPos.x = this.x;
			mCurrentPos.y = this.y;
			
		}
		
		
		
		public function KeyDown(e:KeyboardEvent):void
		{
			var key:int = e.keyCode;
			
			switch(key) 
			{
				case 87:  //W
					KeyWDown = true;
					break;
				case 83: //S
					KeySDown = true;
					break;
				case 65: //A
					KeyADown = true;
					break;
				case 68: //D
					KeyDDown = true;
					break;
				case 32: //Jump;
					SpaceKeyDown = true;
					break;
			}
		}
		
		public function KeyUp(e:KeyboardEvent):void
		{
			var key:int = e.keyCode;
			
			switch(key) 
			{
				case 87:  //W
					KeyWDown = false;
					break;
				case 83: //S
					KeySDown = false;
					break;
				case 65: //A
					KeyADown = false;
					break;
				case 68: //D
					KeyDDown = false;
					break;
				case 32: //Jump;
					SpaceKeyDown = false;
					jumped = false;
					break;
			}
		}
		
		
	}

}