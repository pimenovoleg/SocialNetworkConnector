package com.nextgame.parsers
{
	import com.api.nextgame.data.UserData;
	import com.nextgame.data.FriendVO;
	import com.nextgame.data.SocialApiData;
	import com.nextgame.utils.CalculateAge;

	public class ParserDataNG
	{
		private static var model:SocialApiData = SocialApiData.getInstance();
		
		public static function getUserProfile($data:*):void
		{
			var data:Object = $data[model.socialApi.flashvars.uid]; 
			
			model.user.uid 		  = data.id;
			model.user.first_name = data.first_name;
			model.user.last_name  = data.last_name;
			model.user.avatar_url = data.avatar_url;			
			model.user.city		  = data.city;
			model.user.country	  = data.country;
			
			if (data.sex == 'M')
				model.user.sex = 1;
			else if (data.sex == 'F')
				model.user.sex = 2;
			
			var dateBirthday:Date = CalculateAge.dateStringToObject(data.birthday);
			model.user.age		  = CalculateAge.calculateAge(dateBirthday);
		}
		
		public static function getFriendsUids(data:Array):void
		{
			if (data.length > 0)
			{
				model.user.friends_uids = new Vector.<String>;
				for (var i:int=0; i < data.length; i++)
				{
					model.user.friends_uids.push(String(data[i]));
				}
			}
		}
		
		public static function getFriendsProfiles(data:*):void
		{			
			model.friendsAllProfile = new Vector.<FriendVO>;
			for (var key:String in data) 
			{
				var friend:FriendVO = new FriendVO();				
				friend.age 		  = data[key].birthday;
				friend.first_name = data[key].first_name;
				friend.gender 	  = data[key].sex;
				friend.last_name  = data[key].last_name;
				friend.name 	  = data[key].nick_name;
				friend.uid 		  = data[key].id;
				friend.avatar 	  = data[key].avatar_url;
				friend.city		  = data[key].city;
				friend.country	  = data[key].country;
				
				model.friendsAllProfile.push(friend);
			}
		}
		
		public static function getFriendsUidsInApp(data:*):void
		{
			if (data.length > 0)
			{			
				model.user.friendsInApp_uids = new Vector.<String>;
				for (var i:int=0; i < data.length; i++)
				{
					model.user.friendsInApp_uids.push(String(data[i]));
				}
			}
		}
		
		public static function getFriendsProfilesInApp(data:*):void
		{
			var friend:FriendVO;
			model.friendsInAppProfile = new Vector.<FriendVO>;
			for (var key:String in data) 
			{
				friend 			  = new FriendVO();
				friend.age 		  = data[key].birthday;
				friend.first_name = data[key].first_name;
				friend.gender 	  = data[key].sex;
				friend.last_name  = data[key].last_name;
				friend.name 	  = data[key].nick_name;
				friend.uid 		  = data[key].id;
				friend.avatar 	  = data[key].avatar_url;
				friend.city		  = data[key].city;
				friend.country	  = data[key].country;
				
				model.friendsInAppProfile.push(friend);
			}
		}
	}
}