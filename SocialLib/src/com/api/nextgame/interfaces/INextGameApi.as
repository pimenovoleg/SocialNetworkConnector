package com.api.nextgame.interfaces 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author NextGame
	 */
	public interface INextGameApi extends IEventDispatcher	
	{
		function get uid():String;
		
		function get app_id():String; 
		
		function get private_key():String;
		
		function get session_key():String;
		
		function get rest_url():String;
		
		function request(method:String, ...args):void;
	}
	
}