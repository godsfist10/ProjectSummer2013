package  
{
	import flash.events.EventDispatcher;
	import flash.display.Stage;
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
	import ws.tink.display.HitTest;
	import content.*;
	import includes.*;
	/**
	 * ...
	 * @author ...
	 */
	public class Scene extends MovieClip
	{
		private var mPlayerCharacter:Player
		private var mBackground:graphic;
		private var mCameraPos:Number;
		
		public function Scene() 
		{
			
		}
		
		public function init( background:Class, character:Class, startingXPos:int, startingYPos:int,  stageThing:Stage):void
		{
			mBackground = new graphic(background);
			mBackground.x = 0;
			mBackground.y = 0;
			this.addChild(mBackground);
			
			mCameraPos = stageThing.stageWidth * .5;
			
			mPlayerCharacter = new Player();
			mPlayerCharacter.Init(character, startingXPos, startingYPos, stageThing);
			this.addChild(mPlayerCharacter);

		}
		
		public function update( gravity:Number) : void
		{
			mPlayerCharacter.Update(gravity);
			collideWithBackground(mPlayerCharacter, mBackground);
			adjustScreenPos(mPlayerCharacter, mBackground);
			
			//update sub characters
			
			//collideCharacters(mainCharacter, subCharacter);
			
		}
		
		public function collideWithBackground(brickCharacter:Character , background:graphic):void
		{
			if ( HitTest.complexHitTestObject( brickCharacter.mCharacterArt, background))   //complete hit testing
			{
				//reset before testing
				brickCharacter.SetPrevious_Advanced_Test(true, true);
					
				//test for horizontal collision
				brickCharacter.setCurrent_Test(true, false);
				if (  HitTest.complexHitTestObject( brickCharacter.mCharacterArt, background))
				{
					brickCharacter.SetPrevious_Advanced_Test(true, false);
					var tempXVelocity:Number = brickCharacter.getVelocity().x;
					
					for ( var i:Number = 0; i < Math.abs(tempXVelocity); i++)
					{
						if (tempXVelocity < 0)
							brickCharacter.x--;
						else
							brickCharacter.x++;
							
						if ( HitTest.complexHitTestObject( brickCharacter.mCharacterArt, background))
						{
							if( tempXVelocity < 0)
								brickCharacter.x++;
							else
								brickCharacter.x--;
							i = 900;
							
						}
						
					}
				}
				
				//test vertical collision
				brickCharacter.setCurrent_Test(false, true);
				if (  HitTest.complexHitTestObject( brickCharacter.mCharacterArt, background))
				{
					brickCharacter.SetPrevious_Advanced_Test(false, true);
					var tempYVelocity:Number = brickCharacter.getVelocity().y;
					
					for ( var j:Number = 0; j < Math.abs(tempYVelocity); j++)
					{
						if (tempYVelocity < 0)
							brickCharacter.y--;
						else
							brickCharacter.y++;
							
						if ( HitTest.complexHitTestObject( brickCharacter.mCharacterArt, background))
						{
							if( tempYVelocity < 0)
								brickCharacter.y++;
							else
								brickCharacter.y--;
							
							if ( j == 0 && tempYVelocity > 0)
							{
								brickCharacter.setYVelocity(0);
								brickCharacter.onGround = true;
								if (brickCharacter.SpaceKeyDown && !brickCharacter.jumped)
								{
									brickCharacter.jumped = true;
									brickCharacter.setYVelocity( -30);
								}
							}
								
							j = 900;
						}
						
					}
				}
				brickCharacter.setFinalPos();
			}
		}
		
		public function collideCharacters(brickCharacter:Character, solidCharacter:Character):void
		{
			if ( HitTest.complexHitTestObject( brickCharacter.mCharacterArt, solidCharacter.mCharacterArt))   //complete hit testing
			{
				//reset before testing
				brickCharacter.SetPrevious_Advanced_Test(true, true);
					
				//test for horizontal collision
				brickCharacter.setCurrent_Test(true, false);
				if (  HitTest.complexHitTestObject( brickCharacter.mCharacterArt, solidCharacter.mCharacterArt))
				{
					brickCharacter.SetPrevious_Advanced_Test(true, false);
					var tempXVelocity:Number = brickCharacter.getVelocity().x;
					
					for ( var i:Number = 0; i < Math.abs(tempXVelocity); i++)
					{
						if (tempXVelocity < 0)
							brickCharacter.x--;
						else
							brickCharacter.x++;
							
						if ( HitTest.complexHitTestObject( brickCharacter.mCharacterArt, solidCharacter.mCharacterArt))
						{
							if( tempXVelocity < 0)
								brickCharacter.x++;
							else
								brickCharacter.x--;
							i = 900;
							
						}
						
					}
				}
				
				//test vertical collision
				brickCharacter.setCurrent_Test(false, true);
				if (  HitTest.complexHitTestObject( brickCharacter.mCharacterArt, solidCharacter.mCharacterArt))
				{
					brickCharacter.SetPrevious_Advanced_Test(false, true);
					var tempYVelocity:Number = brickCharacter.getVelocity().y;
					
					for ( var j:Number = 0; j < Math.abs(tempYVelocity); j++)
					{
						if (tempYVelocity < 0)
							brickCharacter.y--;
						else
							brickCharacter.y++;
							
						if ( HitTest.complexHitTestObject( brickCharacter.mCharacterArt, solidCharacter.mCharacterArt))
						{
							if( tempYVelocity < 0)
								brickCharacter.y++;
							else
								brickCharacter.y--;
							
							if ( j == 0 && tempYVelocity > 0)
							{
								brickCharacter.setYVelocity(0);
								brickCharacter.onGround = true;
								if (brickCharacter.SpaceKeyDown && !brickCharacter.jumped)
								{
									brickCharacter.jumped = true;
									brickCharacter.setYVelocity( -30);
								}
							}
								
							j = 900;
						}
						
					}
				}
				//brickCharacter.setFinalPos();
			}
		}
		
		public function adjustScreenPos(mainChar:Player, background:graphic):void
		{
			if ( mainChar.x < 0)
				mainChar.x = 0;
			
			if ( mainChar.x > mCameraPos)
			{
				var offset:Number = mCameraPos - mainChar.x;
				if ( background.x > (background.width - stage.stageWidth) * -1)
				{
					background.x += offset;
					mainChar.x = mCameraPos;
				}
				
				//subCharacter.x += offset;
				
			}
			
		}
	}

}