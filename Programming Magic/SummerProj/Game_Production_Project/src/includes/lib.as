package includes 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import includes.global;
	
	/**
	 * ...
	 * @author Alexander Beauchesne
	 */
	public class lib
	{
		//input 0 output 1, input 1 output -1
		public static function boolNegate(_value:Boolean):int
		{
			return 1 - 2 * int(_value);
		}
		
		public static function get_class(obj:Object):Class
		{
			return Object(obj).constructor;
		}
		
		public static function open_url(url:String):void
		{
			navigateToURL(new URLRequest(url), "_blank");
		}
		
		public static function removeAllChildren(obj:DisplayObjectContainer):void
		{
			while (obj.numChildren > 0) obj.removeChildAt(0);
		}
		
		public static function array_remove(_array:*, _target:*):Boolean
		{
			var i:int = _array.indexOf(_target);
			
			if (i >= 0)
			{
				_array.splice(i, 1);
				return true;
			}
			return false;
		}
		
		public static function bit(_pos:int):int
		{
			return Math.pow(2, _pos);
		}
		
		public static function bit_get(_value:int, _pos:int):Boolean
		{
			return (bit(_pos) & _value) > 0;
		}
		
		public static function bit_set(_value:int, _pos:int):int
		{
			return (bit(_pos) | _value);
		}
		
		public static function bit_zero(_value:int, _pos:int):int
		{
			if (bit_get(_value, _pos)) return _value - bit(_pos);
			return _value;
		}
		
		public static function bit_total(_value:int):int
		{
			var b:int = 0;
			for (var i:int = 0; bit(i) <= _value; i += 1) b += bit_get(_value, i);
			return b;
		}
		
		public static function point_rectangle(X:Number, Y:Number, x1:Number, y1:Number, x2:Number, y2:Number):Boolean
		{
			return (X >= x1 && X <= x2 && Y >= y1 && Y <= y2);
		}

		public static function inside_stage(X:Number, Y:Number, border:Number):Boolean
		{
			return point_rectangle(X, Y, global.STAGE.x - border, global.STAGE.y - border,
									global.STAGE.x + global.STAGE.stageWidth + border,
									global.STAGE.y + global.STAGE.stageHeight + border);
		}

		public static function point_distance(X1:Number, Y1:Number, X2:Number, Y2:Number):Number
		{
			var dx:Number = X2-X1; var dy:Number = Y2-Y1;
			return Math.sqrt(dx*dx + dy*dy);
		}
		
		public static function approach(_initial:Number, _target:Number, _speed:Number):Number
		{
			if (_initial < _target) return Math.min(_initial + _speed, _target);
			if (_initial > _target) return Math.max(_initial - _speed, _target);
			return _target;
		}
		
		public static function reduce(_initial:Number, _speed:Number):Number
		{
			return approach(_initial, 0, _speed);
		}
		
		public static function bounds(_initial:Number, _min:Number, _max:Number):Number
		{
			var b1:Number = Math.min(_min, _max);
			var b2:Number = Math.max(_min, _max);
			return Math.min(Math.max(_initial, b1), b2);
		}
		
		public static function in_bounds(_value:Number, _min:Number, _max:Number):Boolean
		{
			return (_value == bounds(_value, _min, _max));
		}
		
		public static function sign(value:Number):int
		{
			if (value > 0) return 1;
			if (value < 0) return -1;
			return 0;
		}
		
		public static function loop_bounds(_value:Number, _min:Number, _max:Number):Number
		{
			var dif:Number = _max - _min;
			return _min + (((_value - _min) + dif) % dif);
		}
		
		public static function interpolate(_initial:Number, _final:Number, _fraction:Number):Number
		{
			return _initial + ((_final - _initial) * _fraction);
		}
		
		public static function get_random(_min:Number, _max:Number):Number
		{
			return interpolate(_min, _max, Math.random());
		}
		
		public static function prob(_prob:Number):Boolean
		{
			return (get_random(0, 100) <= _prob);
		}
		
		public static function divisible(_number:Number, _divisor:Number):Boolean
		{
			return ((_number % _divisor) == 0);
		}
		
		public static function rad(_angle:Number):Number
		{
			return _angle * Math.PI / 180;
		}
		
		public static function deg(_rad:Number):Number
		{
			return _rad * 180 / Math.PI;
		}
		
		public static function angle_limit(_angle:Number):Number
		{
			return (_angle + 360) % 360;
		}
		
		public static function angle_difference(_angle1:Number, _angle2:Number):Number
		{
			_angle1 = angle_limit(_angle1);
			_angle2 = angle_limit(_angle2);
			
			if (_angle2 >= (_angle1 + 180)) _angle1 += 360;
			else if (_angle2 < (_angle1 - 180)) _angle2 += 360;
			
			return (_angle2 - _angle1);
		}
		
		public static function rotate(_initial:Number, _target:Number, _speed:Number):Number
		{
			_initial = angle_limit(_initial);
			_target = angle_limit(_target);
			
			if (_target >= (_initial + 180)) _initial += 360;
			else if (_target < (_initial - 180)) _target += 360;
			
			return angle_limit(approach(_initial, _target, _speed));
		}
		
		public static function point_direction(x1:Number, y1:Number , x2:Number, y2:Number):Number
		{
			return deg(Math.atan2(y2 - y1, x2 - x1));
		}
		
		public static function get_speed(dx:Number, dy:Number):Number
		{
			return point_distance(0, 0, dx, dy);
		}
		
		public static function get_direction(dx:Number, dy:Number):Number
		{
			return point_direction(0, 0, dx, dy);
		}
		
		public static function div(value:Number, divisor:Number):Number
		{
			return Math.floor(value / divisor);
		}
		
		public static function choose(...objs:*):*
		{
			var c:* = objs
			if (objs.length == 1 && (objs[0] is Array || objs[0] is Vector.<*>)) c = objs[0];
			return c[uint(lib.get_random(0, c.length))];
		}
		
		public static function mouse_rectangle(x1:Number, y1:Number, x2:Number, y2:Number):Boolean
		{
			var xx:Number = global.STAGE.mouseX; var yy:Number = global.STAGE.mouseY;
			return (xx >= x1 && xx <= x2 && yy >= y1 && yy <= y2);
		}
		
		public static function points_equal(p1:Point, p2:Point):Boolean
		{
			return (p1.x == p2.x && p1.y == p2.y);
		}
		
		public static const zero:Point = new Point();
		public static const pi2:Number = Math.PI * 2;
		
	}

}