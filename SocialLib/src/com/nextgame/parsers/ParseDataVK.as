package com.nextgame.parsers
{
	import com.nextgame.data.FriendVO;
	import com.nextgame.data.SocialApiData;
	import com.nextgame.utils.CalculateAge;
	
	public class ParseDataVK
	{
		private static var model:SocialApiData = SocialApiData.getInstance();
		
		public static function getUserProfile(data:*):void
		{
			model.user.uid 		  = data.userInfo[0].uid;
			model.user.first_name = data.userInfo[0].first_name;
			model.user.last_name  = data.userInfo[0].last_name;
			model.user.avatar_url = data.userInfo[0].photo;
			model.user.city	 	  = data.city;
			model.user.country	  = data.country;
			
			if (data.userInfo[0].sex == 2)
				model.user.sex = 1;
			else if (data.userInfo[0].sex == 1)
				model.user.sex = 2;			
			
			if (data.userInfo[0].bdate) 
				model.user.age = CalculateAge.calculateAge(CalculateAge.dateStringToObject(data.userInfo[0].bdate));			
		}
		
		public static function getUserCity(data:*):void
		{
			model.user.city = data.city;
		}
		
		public static function getFriendsUids(data:*):void
		{
			model.user.friends_uids = new Vector.<String>;
			for (var i:int=0; i < data.length; i++)
			{
				model.user.friends_uids.push(String(data[i]));
			}
		}
		
		public static function getFriendsProfiles(data:*):void
		{
			var friend:FriendVO;
			model.friendsAllProfile = new Vector.<FriendVO>;
			for (var key:String in data) 
			{
				friend 			  = new FriendVO();
				friend.age 		  = data[key].age;
				friend.first_name = data[key].first_name;
				friend.gender 	  = data[key].gender;
				friend.last_name  = data[key].last_name;
				friend.name 	  = data[key].name;
				friend.uid 		  = data[key].uid;
				friend.avatar 	  = data[key].photo_medium;
				
				model.friendsAllProfile.push(friend);
			}
		}
		
		public static function getFriendsUidsInApp(data:*):void
		{
			model.user.friendsInApp_uids = new Vector.<String>;
			for (var i:int=0; i < data.length; i++)
			{
				model.user.friendsInApp_uids.push(String(data[i]));
			}
		}
		
		public static function getFriendsProfilesInApp(data:*):void
		{
			var friend:FriendVO;
			model.friendsInAppProfile = new Vector.<FriendVO>;
			for (var key:String in data) 
			{
				friend 			  = new FriendVO();
				friend.age 		  = data[key].age;
				friend.first_name = data[key].first_name;
				friend.gender 	  = data[key].gender;
				friend.last_name  = data[key].last_name;
				friend.name 	  = data[key].name;
				friend.uid 		  = data[key].uid;
				friend.avatar 	  = data[key].photo_medium;
				
				model.friendsInAppProfile.push(friend);
			}
			
		}
		
		public static function wall_postMessage(data:*):void
		{
		}
	}
}