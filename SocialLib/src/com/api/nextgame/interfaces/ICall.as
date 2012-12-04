package com.api.nextgame.interfaces 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author NextGame
	 */
	public interface ICall extends IEventDispatcher
	{
		function getUserInfo(callback:Function):void;
		
		function getFriendsInfo(callback:Function):void;
		
		function getFriendsUids(callback:Function):void;
		
		function getBalance(callback:Function):void;
		
		function openDialog(service_id:String, coins:uint, name:String, description:String, extra:String):void
			
		function openInviteDialog():void;
	}
	
}