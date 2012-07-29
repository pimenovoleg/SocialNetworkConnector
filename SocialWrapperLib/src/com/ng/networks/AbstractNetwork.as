package com.ng.networks
{
	import com.ng.data.FriendVO;
	import com.ng.data.SocialApiData;
	import com.ng.data.UserVO;
	import com.ng.data.WallVO;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class AbstractNetwork extends EventDispatcher
	{
		protected var network:String;
		protected var token:uint;
		protected var flashVars:Object;
		protected var model:SocialApiData = SocialApiData.getInstance();
		protected var lock:Boolean;
		
		public function AbstractNetwork()
		{
			lock = false;	
		}
		
		protected function createModelInstance():void
		{			
			model.wall = new WallVO();
			model.user = new UserVO();
			model.friendsAll = new Vector.<FriendVO>;		
		}
		
		public function start():void
		{
			
		}
	}
}