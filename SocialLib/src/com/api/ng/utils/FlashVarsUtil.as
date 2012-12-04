package com.api.ng.utils
{
	
	public class FlashVarsUtil
	{
	
		public static function parseString($fvars:String):Object
		{
			var fvReturn:Object = {};
			var fv:Array = $fvars.split('&');
			for (var i:int = 0; i < fv.length; i++)
			{
				var pairs:Array = fv[i].split('=');
				var key:String = pairs[0];
				var value:String = pairs[1];
				fvReturn[key] = value;
			}
			return fvReturn;
		}
		
		public static function getLength(o:Object):uint
		{
			var len:uint = 0;
			for (var item:* in o)
				if (item != "mx_internal_uid")
					len++;
			return len;
		}
	}
}