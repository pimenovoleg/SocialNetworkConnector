package com.api.nextgame.utils 
{
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author NextGame
	 */
	public class NGError extends EventDispatcher 
	{		
		public var error:Error;		
		public var reason:String;
		public var type:uint;
		
		public function NGError() {}
		
	}

}