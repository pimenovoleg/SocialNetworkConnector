package com.api.nextgame.apis
{
	
	import com.api.nextgame.interfaces.INextGameApi;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class JSApi extends EventDispatcher implements INextGameApi
	{
		public function JSApi()
		{
			
		}
		
		public function get uid():String
		{
			return null;
		}
		
		public function get app_id():String
		{
			return null;
		}
		
		public function get private_key():String
		{
			return null;
		}
		
		public function get session_key():String
		{
			return null;
		}
		
		public function get rest_url():String
		{
			return null;
		}
		
		public function request(method:String, ...args):void
		{
		}
	}
}