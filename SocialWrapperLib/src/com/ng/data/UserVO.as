package com.ng.data
{
	public class UserVO
	{
		public static const SEX_UNDEFINED:int = 2;
		public static const SEX_FEMALE:int = 1;
		public static const SEX_MALE:int = 0;
		
		public var uid:String;
		public var first_name:String;
		public var last_name:String;
		public var nick_name:String;
		public var avatar_url:String;
		public var sex:int;
		public var friends_uids:Vector.<String>;
		public var friendsInApp_uids:Vector.<String>;
		
		public function UserVO()
		{
			this.friends_uids = new Vector.<String>;
		}
	}
}