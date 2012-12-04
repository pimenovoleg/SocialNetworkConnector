package com.api.nextgame.controller 
{

	import com.api.nextgame.enum.Request;
	import com.api.nextgame.events.NextGameEvent;
	import com.api.nextgame.interfaces.ICall;
	import com.api.nextgame.interfaces.INextGameApi;
	
	import flash.events.EventDispatcher;

	/**
	 * ...
	 * @author NextGame
	 */
	public class NGCaller extends EventDispatcher implements ICall
	{		
		private var currentApi:INextGameApi;
		
		public function NGCaller(api:INextGameApi) 
		{
			this.currentApi = api;
		}
		
		public function getUserInfo(callback:Function):void
		{	
			currentApi.addEventListener(NextGameEvent.COMPLETE, callback);
			currentApi.request(Request.GET_INFO);
		}
		
		public function getFriendsInfo(callback:Function):void
		{
			currentApi.addEventListener(NextGameEvent.COMPLETE, callback);
			currentApi.request(Request.GET_FRIENDS_PROFILES);
		}
		
		public function getFriendsUids(callback:Function):void
		{
			currentApi.addEventListener(NextGameEvent.COMPLETE, callback);
			currentApi.request(Request.GET_FRIENDS_UIDS);
		}
		
		public function getBalance(callback:Function):void
		{
			currentApi.addEventListener(NextGameEvent.COMPLETE, callback);
			currentApi.request(Request.GET_BALANCE);
		}
		
		public function openDialog(service_id:String, coins:uint, name:String, description:String, extra:String):void
		{
			currentApi.request(Request.OPEN_DIALOG, service_id, coins, name, description, extra);
		}
		
		public function openInviteDialog():void
		{
			currentApi.request(Request.OPEN_INVITE_DIALOG);
		}
		
	}

}