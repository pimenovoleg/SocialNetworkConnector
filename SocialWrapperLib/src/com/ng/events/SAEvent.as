package com.ng.events
{
	import flash.events.Event;
	
	public class SAEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		public static const ERROR:String ="error";
		
		public var success:Boolean;
		
		public function SAEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, success:Boolean=false )
		{
			this.success = success;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new SAEvent(type, bubbles, cancelable, success);
		}
	}
}