package com.api.nextgame.utils 
{
	import com.adobe.crypto.MD5;
	import com.api.nextgame.enum.Request;
	
	import flash.net.URLVariables;

	/**
	 * ...
	 * @author NextGame
	 */
	public class RequestFormat 
	{
		
		
		public static function format(urlVars:URLVariables, private_key:String):void 
		{
			switch(urlVars.method)
			{
				case Request.GET_INFO:
				{				
					break;
				}
				
				case Request.GET_FRIENDS_PROFILES:
				{					
					urlVars.ext = 1;
					break;
				}
				
				case Request.GET_FRIENDS_UIDS:
				{
					urlVars.method = Request.GET_FRIENDS_PROFILES;
					urlVars.ext = 0;
					break;
				}
			}
			
			urlVars.sig = createSig(urlVars, private_key);
		}
		
		
		private static function createSig(urlVars:URLVariables, private_key:String):String
		{
			var vars:Array = [];
			
			var s:String = "";
			
			s += urlVars.uid;
			
			for (var key:String in urlVars) 
			{	
				var arg:* = urlVars[key];
				vars.push(key + '=' + arg.toString());
			}
			
			vars.sort();
			
			s += vars.join('');
			s += private_key;
			
			return MD5.hash(s);
		}
		
	}

}