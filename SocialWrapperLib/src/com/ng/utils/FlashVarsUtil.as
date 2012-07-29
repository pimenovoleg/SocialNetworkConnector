package com.ng.utils
{
	import com.ng.networks.enums.NetworkName;

	public class FlashVarsUtil
	{
		public static function selectSocial($fvars:Object):String
		{			
			for (var key:String in $fvars)
			{
				if (($fvars[key] == NetworkName.VK))
				{
					return NetworkName.VK;					
				}
				else if (($fvars[key] == NetworkName.OD))
					return NetworkName.OD;
			}
			return null;
		}
		
		public static function isLocalRun($fvars:Object):Boolean
		{
			
			return true;
		}
		
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