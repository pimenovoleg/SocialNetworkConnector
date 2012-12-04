package com.api.nextgame.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author NextGame
	 */
	public class NextGameEvent extends Event 
	{
		public static const COMPLETE:String = "complete";		
		public static const ERROR:String ="eventError";
		
		public var success:Boolean;
		public var result:*;
		public var error:*;
		
		public function NextGameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, success:Boolean=false, result:*=null, error:*=null) 
		{
			this.success = success;
			this.result = result;
			this.error = error;
			
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event 
		{
			return new NextGameEvent(type, bubbles, cancelable, success, result, error);
		}		
		
	}

}