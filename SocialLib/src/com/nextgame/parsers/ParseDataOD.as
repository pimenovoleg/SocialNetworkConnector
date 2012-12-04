package com.nextgame.parsers
{
	import com.nextgame.data.FriendVO;
	import com.nextgame.data.SocialApiData;
	
	public class ParseDataOD
	{
		private static var model:SocialApiData = SocialApiData.getInstance();
		
		public static function getUserProfile(data:*):void
		{
			model.user.uid 		  = data.uid;
			model.user.first_name = data.first_name;
			model.user.last_name  = data.last_name;
			model.user.avatar_url = data.pic_1;
			model.user.age		  = data.age;
			
			if (data.location != undefined)
			{
				if (data.location.city)		 model.user.city  	= data.location.city;
				if (data.location.country) 	 model.user.country = data.location.country;				
			}
			
			if (data.gender == 'male')
				model.user.sex = 1;
			else if (data.gender == 'female')
				model.user.sex = 2;
					
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
			model.friendsAllProfile = new Vector.<FriendVO>;
			
			for (var i:int = 0; i < data.length; i++) 
			{
				var friend:FriendVO	= new FriendVO();
				friend.age 			= data[i].age;
				friend.first_name 	= data[i].first_name;
				friend.last_name 	= data[i].last_name;
				friend.gender 		= data[i].gender;				
				friend.name 		= data[i].name;
				friend.uid 			= data[i].uid;
				friend.avatar 		= data[i].photo_medium;

				
				model.friendsAllProfile.push(friend);
			}		
		}
		
		public static function getFriendsUidsInApp(data:*):void
		{
			model.user.friendsInApp_uids = new Vector.<String>;
			for (var i:int=0; i < data.uids.length; i++)
			{				
				model.user.friendsInApp_uids.push(String(data.uids[i]));
			}
		}
		
		public static function getFriendsProfilesInApp(data:*):void
		{		
			model.friendsInAppProfile = new Vector.<FriendVO>;

			
			for (var i:int = 0; i < data.length; i++) 
			{				
				var friend:FriendVO = new FriendVO();
				friend.age 		  = data[i].age;
				friend.first_name = data[i].first_name;
				friend.gender 	  = data[i].gender;
				friend.last_name  = data[i].last_name;
				friend.name 	  = data[i].name;
				friend.uid 		  = data[i].uid;
				friend.avatar 	  = data[i].photo_medium;
				
				model.friendsInAppProfile.push(friend);

			}
			
		}
		
		public static function wall_postMessage(data:*):void
		{
		}

	}
}