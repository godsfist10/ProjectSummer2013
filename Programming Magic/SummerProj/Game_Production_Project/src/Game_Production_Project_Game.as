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
		private const gravity:Number = 1;
		private var SceneOne:Scene;
				
		public function init():void
		{		
			//myLocalVariableName = new graphic(embed_images.myGraphicVariableName);
			
			SceneOne = new Scene();
			SceneOne.init(embed_images.collider, embed_images.brick, 100, 100, stage);
			addChild(SceneOne);
			
			//Mouse.hide();
			stage.addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(MouseEvent.CLICK, handleClick);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
				
			//stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
		
		
		public function update(e:Event):void
		{		
			SceneOne.update(gravity);
			
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

















