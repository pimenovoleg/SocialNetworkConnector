package com.nextgame.data
{
	import com.nextgame.data.UserVO;
	import com.nextgame.networks.AbstractNetwork;

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
		
		public var socialApi:AbstractNetwork;
		public var user:UserVO;
		public var friendsAllProfile:Vector.<FriendVO>;
		public var friendsInAppProfile:Vector.<FriendVO>;
		
		public var wall:WallVO;
		
		public function get networkName():String
		{
			return (socialApi as AbstractNetwork).network;			 
		}
		
		public function get networkID():int
		{
			return (socialApi as AbstractNetwork).networkID;			 
		}
	}
}

internal class SingletonBlocker {}