package com.nextgame.events
{
	import flash.events.Event;
	
	public class SARequestEvent extends Event
	{
		public static const COMPLETE:String = "socialRequestComplete";
		public static const ERROR:String = "socialRequestError";
		
		public var _data:Object;
		
		public function SARequestEvent(type:String, data:Object = null ,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data = data;
			super(type, bubbles, cancelable);
		}
	}
}