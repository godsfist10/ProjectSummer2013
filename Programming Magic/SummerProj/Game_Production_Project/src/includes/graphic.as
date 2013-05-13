package includes 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import includes.*;
	import content.*;
	
	/**
	 * ...
	 * @author Alexander Beauchesne
	 */
	public class graphic extends Sprite
	{
		public var bitmap:Bitmap = new Bitmap(); //graphic to draw
		public var rect:Rectangle; //rectangle
		
		public var source:BitmapData; //source data
		public var source_rect:Rectangle; //size of source
		public var source_class:Class; //source class
		
		public var buffer:BitmapData; //buffer to draw
		public var buffer_rect:Rectangle; //size of buffer
		
		public var _width:uint;
		public var _height:uint;
		
		public var angle:Number;
		public var xscale:Number;
		public var yscale:Number;
		
		public var frame:Number = 0;
		private var frame_prev:Number = -1;
		public var frame_speed:Number = 0;
		
		public var frames_max:int = 1;
		public var rows:uint = 1;
		public var columns:uint = 1;
		
		public var origin:Point;
		
		private var frozen:Boolean = false;
		
		public var changed:Boolean = false;
		
		private var _id:uint;
		private static var _id_max:uint = 0;
		
		public function graphic(image:Class, ox:Number = 0, oy:Number = 0, _frame:Number = 0, _static:Boolean = false):void
		{
			_id = _id_max;
			_id_max += 1;
			
			source = dicts.get_bitmap(image);
			source_rect = source.rect;
			source_class = image;
			
			rows = embed_images.rows[image];
			columns = embed_images.columns[image];
			frames_max = rows * columns;
			
			_width = source_rect.width / columns;
			_height = source_rect.height / rows;
			
			frame = _frame;
			
			rect = new Rectangle(0, 0, _width, _height);
			
			origin = new Point(ox, oy);
			
			angle = 0;
			xscale = 1;			
			yscale = 1;
			
			frozen = _static;
			
			if (!frozen) addEventListener(Event.EXIT_FRAME, update);
			addChild(bitmap);
			
			buffer_create();
			buffer_update();
		}
		
		public function destroy():void
		{
			bitmap.bitmapData.dispose();
			buffer = null;
			if (!frozen) removeEventListener(Event.EXIT_FRAME, update);
		}
		
		public function center():void
		{
			origin.x = _width / 2;
			origin.y = _height / 2;
		}
		
		public function update(e:Event = null):void
		{
			frame = (frame + (frame_speed * uint(!global.paused)) + frames_max) % frames_max;
			if (Math.floor(frame) != Math.floor(frame_prev))
			{
				buffer_update();
				changed = true;
			}
			else changed = false;
			frame_prev = frame;
			
			var m:Matrix = new Matrix;
			bitmap.transform.matrix = m;
			
			angle = lib.angle_limit(angle);
			
			if (xscale != 1 || yscale != 1 || angle != 0)
			{
				m.translate( -(origin.x), -(origin.y));
				
				if (xscale != 1 || yscale != 1) m.scale(xscale, yscale);
				if (angle != 0) m.rotate(lib.rad(angle));
				
				m.translate( +(origin.x), +(origin.y));
				
				bitmap.transform.matrix = m;
			}
		}
		
		private function buffer_create():void
		{
			if (buffer)
			{
				buffer.dispose();
				buffer = null;
			}
			
			buffer = new BitmapData(_width, _height, true, 0);
			buffer_rect = buffer.rect;
			bitmap.bitmapData = buffer;
		}
		
		private function buffer_update():void
		{
			rect.x = rect.width * (Math.floor(frame) % columns);
			rect.y = rect.height * lib.div(Math.floor(frame),columns);
			
			buffer.fillRect(buffer_rect, 0);
			buffer.copyPixels(source, rect, lib.zero, null, lib.zero, false);
		}
		
	}

}