package com.nextgame.utils
{
	import com.nextgame.networks.enums.NetworkAlias;

	public class FlashVarsUtil
	{
		public static function selectSocial($fvars:Object):String
		{			
			for (var key:String in $fvars)
			{
				if (StringUtils.countOf($fvars[key],NetworkAlias.MIRTESEN_PART)>0)
					return NetworkAlias.MIRTESEN;
				else if (StringUtils.countOf($fvars[key],NetworkAlias.VK_PART)>0)
					return NetworkAlias.VK;
				else if (StringUtils.countOf($fvars[key],NetworkAlias.VK_COM)>0)
					return NetworkAlias.VK;
				else if (StringUtils.countOf($fvars[key],NetworkAlias.OD_PART)>0)
					return NetworkAlias.OD;
				else if (StringUtils.countOf($fvars[key],NetworkAlias.NG)>0)
					return NetworkAlias.NG;
				else if (StringUtils.countOf($fvars[key],NetworkAlias.MAIL)>0)
					return NetworkAlias.MAIL;
				else if (StringUtils.countOf($fvars[key],NetworkAlias.MAIL_PART)>0)
					return NetworkAlias.MAIL;
				else if ( key == NetworkAlias.MAIL )
					return NetworkAlias.MAIL;
			}
			return null;
		}
		
		public static function getAppID($fvars:Object,$net:String):String
		{			
			switch ($net)
			{
				case NetworkAlias.VK:
					return $fvars.api_id;
				case NetworkAlias.MAIL:
					return $fvars.app_id;
				case NetworkAlias.OD:
					return $fvars.application_key;
				case NetworkAlias.NG:
					return $fvars.app_id;
			}
			
			
			for (var key:String in $fvars)
			{
				if (StringUtils.countOf($fvars[key],NetworkAlias.MIRTESEN_PART)>0)
					return NetworkAlias.MIRTESEN;
				else if (StringUtils.countOf($fvars[key],NetworkAlias.VK_PART)>0)
					return NetworkAlias.VK;
				else if (StringUtils.countOf($fvars[key],NetworkAlias.VK_COM)>0)
					return NetworkAlias.VK;
				else if (StringUtils.countOf($fvars[key],NetworkAlias.OD_PART)>0)
					return NetworkAlias.OD;
				else if (StringUtils.countOf($fvars[key],NetworkAlias.NG)>0)
					return NetworkAlias.NG;
				else if (StringUtils.countOf($fvars[key],NetworkAlias.MAIL)>0)
					return NetworkAlias.MAIL;
				else if (StringUtils.countOf($fvars[key],NetworkAlias.MAIL_PART)>0)
					return NetworkAlias.MAIL;
				else if ( key == NetworkAlias.MAIL )
					return NetworkAlias.MAIL;
			}
			return null;
		}
		
		public static function parseString($fvars:String):Object
		{
			var fvReturn:Object = {};
			var fvTemp : Array = $fvars.split('?');
			if (fvTemp.length >1)
			{
				fvReturn['api_url'] = fvTemp[0];
				$fvars = fvTemp[1];
			}
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