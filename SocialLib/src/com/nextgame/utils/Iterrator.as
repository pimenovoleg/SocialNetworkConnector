package com.nextgame.utils
{
	public class Iterrator
	{
		public var keys:Array;
		public var values:Array;

		
		public function Iterrator()
		{
			this.keys 	= [];
			this.values = [];
		}
			
		public function get(key:Object):Object
		{
			return (values[this.findKey(key)]);
		}

		public function put(key:Object, value:Object):void
		{
			var oldKey:*;
			var theKey:Object = this.findKey(key);
			if (theKey < 0)
			{
				this.keys.push(key);
				this.values.push(value);
			}
			else
			{
				oldKey = values[theKey];
				this.values[theKey] = value;
			}			
		}
		
		private function findKey(key:Object):Object
		{
			var index:int = this.keys.length;
			while(this.keys[--index] !== key && index > -1)
			{
			}
			return index;
		}
		
		public function size():int
		{
			return (this.keys.length);
		}

	}
}