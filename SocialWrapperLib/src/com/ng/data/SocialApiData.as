package com.ng.data
{
	import com.ng.data.UserVO;
	import com.ng.interfaces.ISocialAPI;

	public class SocialApiData
	{
		private static var instance:SocialApiData;
		public static function getInstance():SocialApiData {
			if (instance == null) {
				instance = new SocialApiData(new SingletonBlocker());
			}
			return instance;
		}
		
		public function SocialApiData(p_key:SingletonBlocker):void {			
			if (p_key == null) {
				throw new Error("Error: Instantiation failed: Use SocialData.getInstance() instead of new.");
			}
		}
		
		public var socialApi:ISocialAPI;
		public var user:UserVO;
		public var friendsAll:Vector.<FriendVO>;
		public var friendsInApp:Vector.<FriendVO>;
		
		public var wall:WallVO;
	}
}

internal class SingletonBlocker {}