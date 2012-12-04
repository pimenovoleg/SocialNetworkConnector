package com.nextgame.parsers
{
	import com.nextgame.data.FriendVO;
	import com.nextgame.data.SocialApiData;
	import com.nextgame.utils.CalculateAge;

	public class ParseDataMAILRU
	{
		private static var model:SocialApiData = SocialApiData.getInstance();
		
		public static function getUserProfile(data:*):void
		{
			if (data.error_msg)
			{
				trace(data.error_msg + ' Error code '+ data.error_code);
				return;
			}
			model.user.uid 		  = data.uid;
			model.user.first_name = data.first_name;
			model.user.last_name  = data.last_name;
			model.user.avatar_url = data.pic;
			//model.user.link		  = String(dala.link).slice(18);
			
			if (data.sex == 0)
				model.user.sex = 1;
			else if (data.sex == 1)
				model.user.sex = 2;
			
			
			if (data.location)
			{
				if (data.location.city)		 model.user.city  = data.location.city.name;
				if (data.location.country) 	 model.user.country = data.location.country.name;
			}
			
			var dateBirthday:Date = CalculateAge.dateStringToObject(data.birthday);
			model.user.age		  = CalculateAge.calculateAge(dateBirthday);
		}
		
		public static function getHashInfo(data:Object):void
		{
			model.user.specialInfo = data;
		}
		
		public static function getFriendsUids(data:*):void
		{
			model.user.friends_uids = new Vector.<String>;
			for (var i:int=0; i < data.length; i++)
			{
				model.user.friends_uids.push(String(data[i]));
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
		
		public static function getFriendsProfiles(data:*):void
		{
			var friend:FriendVO;
			model.friendsAllProfile = new Vector.<FriendVO>;
			model.user.friends_uids = new Vector.<String>;
			if (data && data.length)
				for (var key:int = 0 ; key<data.length;key++) 
				{
					friend 			  = new FriendVO();
					
					friend.first_name = data[key].first_name;				
					friend.last_name  = data[key].last_name;				
					friend.uid 		  = data[key].uid;
					
					friend.avatar 	  = data[key].pic;
					
					if (data[key].sex == 0)
						model.user.sex = 1;
					else
						model.user.sex = 2;
					
					if (data[key].birthday != '')
					{
						var dateBirthday:Date = CalculateAge.dateStringToObject(data[key].birthday);
						friend.age = CalculateAge.calculateAge(dateBirthday);
					}
					
					model.user.friends_uids.push(String(data[key].uid));
					model.friendsAllProfile.push(friend);
				}
		}
		
		public static function getFriendsProfilesInApp(data:*):void
		{
			var friend:FriendVO;
			model.friendsInAppProfile = new Vector.<FriendVO>;
			model.user.friendsInApp_uids = new Vector.<String>;
			for (var key:String in data) 
			{
				friend 			  = new FriendVO();
				
				friend.first_name = data[key].first_name;				
				friend.last_name  = data[key].last_name;				
				friend.uid 		  = data[key].uid;
				
				friend.avatar 	  = data[key].pic;
				
				if (data[key].sex == 0)
					model.user.sex = 1;
				else
					model.user.sex = 2;
				if (data[key].birthday != '')
				{
					var dateBirthday:Date = CalculateAge.dateStringToObject(data[key].birthday);
					friend.age = CalculateAge.calculateAge(dateBirthday);
				}
				
				model.user.friendsInApp_uids.push(String(data[key].uid));
				model.friendsInAppProfile.push(friend);
			}
		}
	}
}