package com.nextgame.utils
{
	import flash.events.Event;
	
	public class MultipartURLLoaderEvent extends Event
	{
		public var bytesWritten:uint = 0;
		public var bytesTotal:uint = 0;
		public static const DATA_PREPARE_PROGRESS:String = "dataPrepareProgress";
		public static const DATA_PREPARE_COMPLETE:String = "dataPrepareComplete";
		
		public function MultipartURLLoaderEvent(param1:String, param2:uint = 0, param3:uint = 0)
		{
			super(param1);
			this.bytesTotal = param3;
			this.bytesWritten = param2;
			return;
		}
	}
}