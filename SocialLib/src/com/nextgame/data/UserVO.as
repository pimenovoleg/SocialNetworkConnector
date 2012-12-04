package com.nextgame.data
{
	public class UserVO
	{		
		public var uid:String;
		/** part link to the users page **/
		public var link :String;
		public var first_name:String;
		public var last_name:String;
		public var nick_name:String;
		public var avatar_url:String;
		
		/**
		 * M == 1
		 * F == 2 
		 */
		public var sex:int;
		public var age:int;
		public var city:String;
		public var country:String;
		public var friends_uids:Vector.<String>;
		public var friendsInApp_uids:Vector.<String>;
		public var specialInfo:Object; 
		
		public function UserVO()
		{
			
		}
	}
}