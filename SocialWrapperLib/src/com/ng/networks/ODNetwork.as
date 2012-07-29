package com.ng.networks
{
	import com.api.od.ODApi;
	import com.api.od.ODMethod;
	import com.ng.data.FriendVO;
	import com.ng.data.SocialApiData;
	import com.ng.data.UserVO;
	import com.ng.interfaces.ISocialAPI;
	import com.ng.networks.enums.Token;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class ODNetwork extends AbstractNetwork implements ISocialAPI
	{
		protected var api:ODApi;	
		
		public function ODNetwork($fv:Object)
		{
			this.flashVars = $fv;
			this.api = new ODApi($fv);
			createModelInstance();
		}
		
		public override function start():void
		{			
			getUserProfile();
		}
		
		public function getUserProfile():void
		{
			token = Token.GET_USER_PROFILE;
			var allFields:String = "uid,first_name,last_name,name,gender,age,location,pic_1,pic_2";
			/*if ($fields !=null){
				allFields = $fields;
			}*/
			var params:Object = {method: ODMethod.USERS_GET_INFO, uids: flashVars.logged_user_id, fields: allFields};
			api.sendRequest(params, onComplete);
		}
		
		public function getFriendsUids():void
		{
			token = Token.GET_FRIENDS_UIDS;
			var params:Object = {method: ODMethod.FRIENDS_GET};
			api.sendRequest(params, onComplete);
		}
		
		public function getFriendsProfiles():void
		{
			token = Token.GET_FRIENDS_PROFILES;
			var allFields:String = "uid,first_name,last_name,name,gender,age,location,pic_1,pic_2";
			var params:Object = {method: ODMethod.USERS_GET_INFO, uids: model.user.friends_uids, fields: allFields};
			api.sendRequest(params, onComplete);
			
		}
		
		public function getFriendsUidsInApp():void
		{
			token = Token.GET_FRIENDS_UIDS_IN_APP;
			var params:Object = {method: ODMethod.FRIENDS_GET_APP_USERS};
			api.sendRequest(params, onComplete);
			
		}
		
		public function getFriendsProfilesInApp():void
		{
			token = Token.GET_FRIENDS_PROFILES_IN_APP;
			var allFields:String = "uid,first_name,last_name,name,gender,age,location,pic_1";
			/*if (fields !=null){
				AllFields = fields;
			}*/
			var params:Object = {method: ODMethod.USERS_GET_INFO, uids: model.user.friendsInApp_uids.join(), fields: allFields};
			api.sendRequest(params, onComplete);
			
		}
		
		public function wall_postMessage($wallUid:String, $mc:MovieClip, $message:String, $post_id:String = 'wallpost13', $photo_id:String=null):void
		{
			
		}
		
		private function onComplete(data:*):void
		{
			var i:int;
			var key:String;
			var friend:FriendVO;
			
			switch(token)
			{
				case Token.GET_USER_PROFILE:
				{				
					model.user.first_name = data[0].first_name;
					model.user.last_name  = data[0].last_name;
					getFriendsUids();
					break;
				}
					
				case Token.GET_FRIENDS_UIDS:
				{
					model.user.friends_uids = new Vector.<String>;
					for (i=0; i < data.length; i++)
					{
						model.user.friends_uids.push(String(data[i]));
					}
					
					getFriendsProfiles();
					break;
				}
				case Token.GET_FRIENDS_PROFILES:
				{
					for (key in data) 
					{
						friend = new FriendVO();
						friend.age = data[key].age;
						friend.first_name = data[key].first_name;
						friend.gender = data[key].gender;
						friend.last_name = data[key].last_name;
						friend.name = data[key].name;
						friend.uid = data[key].uid;
						friend.avatar = data[key].photo_medium;
						
						model.friendsAll.push(friend);
					}
					getFriendsUidsInApp();
					break;
				}
					
				case Token.GET_FRIENDS_UIDS_IN_APP:
				{					
					if (data.uids.length != 0)
					{
						model.user.friendsInApp_uids = new Vector.<String>;
						for (i=0; i < data.uids.length; i++)
						{
							model.user.friendsInApp_uids.push(String(data.uids[i]));
						}
						getFriendsProfilesInApp();
					}
					else
						dispatchEvent(new Event(Event.COMPLETE));
					break;
				}
					
				case Token.GET_FRIENDS_PROFILES_IN_APP:
				{
					model.friendsInApp = new Vector.<FriendVO>;
					for (key in data) 
					{
						friend 			  = new FriendVO();
						friend.age 		  = data[key].age;
						friend.first_name = data[key].first_name;
						friend.gender 	  = data[key].gender;
						friend.last_name  = data[key].last_name;
						friend.name 	  = data[key].name;
						friend.uid 		  = data[key].uid;
						friend.avatar 	  = data[key].photo_medium;
						
						model.friendsInApp.push(friend);
					}
					
					dispatchEvent(new Event(Event.COMPLETE));
					break;
				}
			}
		}
	}
}