package com.ng.logging
{
	public class LogType
	{
		public static const DEBUG:uint = 1;
		public static const INFO:uint  = 2;
		public static const WARN:uint  = 3;
		public static const ERROR:uint = 4;
		
		
		public static function toStr($type:int) : String
		{
			var type:String = "Unknown";
			if ($type == DEBUG)		
				type = "DEBUG";			
			else if ($type == INFO)			
				type = "INFO";			
			else if ($type == WARN)			
				type = "WARN";			
			else if ($type == ERROR)
				type = "ERROR";			
			return type;
		}
	}
}