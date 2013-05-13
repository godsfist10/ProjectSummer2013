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
	import ws.tink.display.HitTest;
	import content.*;
	import includes.*;
	
	
	
	
	public class Game_Production_Project_Game extends MovieClip 
	{
		//private var myLocalVariableName:graphic,
		const gravity:Number = 1;
		private var background:graphic;
		private var brick:graphic;
		private var brickCharacter:Player;
		
		
		
		public function init():void
		{		
			//myLocalVariableName = new graphic(embed_images.myGraphicVariableName);
			background = new graphic(embed_images.collider);
			background.x = 0;
			background.y = 0;
			this.addChild(background);
			brickCharacter = new Player();
			brickCharacter.Init(embed_images.brick, 100, 100);
			addChild(brickCharacter);
			
			//Mouse.hide();
			stage.addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(MouseEvent.CLICK, handleClick);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, brickCharacter.KeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, brickCharacter.KeyUp);
			//stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
		
		
		public function update(e:Event):void
		{		
			
			brickCharacter.Update(gravity);
			
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
		
		public function handleClick(e:MouseEvent):void
		{
			
		}	
		
		public function keyDown(e:KeyboardEvent):void
		{
			/*var key:int = e.keyCode;
			
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
					KeySpaceDown = true;
					break;
			}*/
		}	
		
		public function KeyUp(e:KeyboardEvent):void
		{
			/*var key:int = e.keyCode;
			
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
					KeySpaceDown = false;
					break;
			}*/
		}
	}	
}

















