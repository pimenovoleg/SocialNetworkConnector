package com.nextgame.logging
{
	public class Logger
	{
		public static function log($message:String, $type:uint):void
		{
			var type:String = LogType.toStr($type);
			trace('[SocialAPI: ' + type + '] - ' + $message);
		}
	}
}