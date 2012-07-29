package com.ng.networks
{
	import com.adobe.images.PNGEncoder;
	import com.api.vk.APIConnection;
	import com.api.vk.WallImgOnServer;
	import com.api.vk.apivk.VKMethod;
	import com.ng.data.FriendVO;
	import com.ng.data.SocialApiData;
	import com.ng.data.UserVO;
	import com.ng.data.WallVO;
	import com.ng.interfaces.ISocialAPI;
	import com.ng.logging.LogType;
	import com.ng.logging.Logger;
	import com.ng.networks.enums.Token;

	import com.ng.utils.MultipartURLLoader;

	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;

	
	
	public class VKNetwork extends AbstractNetwork implements ISocialAPI
	{				
		private var api:APIConnection;		
		
		public function VKNetwork($fv:Object)
		{			
			this.flashVars = $fv;
			api = new APIConnection(flashVars);
			createModelInstance();
		}
		
		public override function start():void
		{		
			network = 'VK API';	
			getUserProfile();	
		}
		
		public function getUserProfile():void
		{
			token = Token.GET_USER_PROFILE;
			api.api(VKMethod.GET_PROFILES, {uids:flashVars.viewer_id, fields:'first_name, last_name, sex, birthdate, city, country, photo, photo_medium, photo_big'},
				onComplete, onError);		
		}
		
		public function getFriendsUids():void
		{
			token = Token.GET_FRIENDS_UIDS;
			api.api(VKMethod.GET_FRIENDS,{uids:flashVars.viewer_id}, onComplete, onError);
		}
		
		public function getFriendsProfiles():void
		{
			token = Token.GET_FRIENDS_PROFILES;
			api.api(VKMethod.GET_PROFILES, {uids:model.user.friends_uids, fields:'first_name, last_name, photo, photo_medium, photo_big'},
				onComplete, onError);
		}
		
		public function getFriendsUidsInApp():void
		{
			token = Token.GET_FRIENDS_UIDS_IN_APP;
			
			api.api(VKMethod.GET_FRIENDS_APP, {uids:flashVars.viewer_id}, onComplete, onError);
		}
		
		public function getFriendsProfilesInApp():void
		{
			token = Token.GET_FRIENDS_PROFILES_IN_APP;
			
			api.api(VKMethod.GET_PROFILES, {uids:model.user.friendsInApp_uids, fields:'first_name, last_name, photo, photo_medium, photo_big'},
				onComplete, onError);
		}
		
//********* WALL *******************		
		private function wall_savePost():void
		{
			token = Token.VK_WALL_POST;			
			api.api(VKMethod.WALL_SAVEPOST, {wall_id:model.wall.wall_uid, post_id:model.wall.post_id, message:model.wall.message, server:model.wall.server, photo:model.wall.photo, hash:model.wall.hash}, onComplete, onError);
		}
		
		private function wall_savePostConstImage():void
		{
			token = Token.VK_WALL_POST;
			api.api(VKMethod.WALL_SAVEPOST, {wall_id:model.wall.wall_uid, post_id:model.wall.post_id, message:model.wall.message, photo_id:model.wall.photo_id}, onComplete, onError); // 62124510_150026341
		}
		
//*******************************************		
		/**
		 * 
		 * @param $wallUid - uid пользователя на котором будет пост
		 * 
		 */
		public function wall_postMessage($wallUid:String, $mc:MovieClip, $message:String, $post_id:String = 'wallpost13', $photo_id:String=null):void
		{
			model.wall.wall_uid = $wallUid;
			model.wall.mc		= $mc;
			model.wall.message  = $message;
			model.wall.post_id  = $post_id;
			model.wall.photo_id = $photo_id;
			
			if ($photo_id != null)
			{
				wall_savePostConstImage();
				return;
			}
			
			if (model.wall.vk_upload_url == null)
				wall_getPhotoUploadServer();
			else
				loadImage();
		}
		
		/**
		 * STEP 1 - get URL UPLOAD SERVER
		 * 
		 */
		private function wall_getPhotoUploadServer():void
		{
			token = Token.VK_GET_URL_PHOTOUPLOADSERVER;
			api.api(VKMethod.WALL_GET_PHOTOUPLOADSERVER, {}, onComplete, onError);		
		}
	
		/**
		 * STEP 2 - upload image on server in VK
		 * 
		 */
		private function loadImage():void
		{			
			WallImgOnServer.loadImage(model.wall.mc, model.wall.vk_upload_url, loadImageComplete);			
		}
		
		/**
		 * 
		 * STEP 3 - POST MESSAGE AND IMAGE
		 * @param data
		 * 
		 */
		private function loadImageComplete(data:Object):void
		{		
			model.wall.server = data.server;
			model.wall.photo  = data.photo;
			model.wall.hash   = data.hash;			
			wall_savePost();
		}
	
//***************************************************************************		
		private function onComplete(data:Object):void
		{
			var i:int;
			var key:String;
			var friend:FriendVO;
			
			switch(token)
			{
				case Token.GET_USER_PROFILE:
				{				
					model.user.uid = flashVars.viewer_id;
					model.user.first_name = data[0].first_name;
					
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
						friend 			  = new FriendVO();
						friend.age 		  = data[key].age;
						friend.first_name = data[key].first_name;
						friend.gender 	  = data[key].gender;
						friend.last_name  = data[key].last_name;
						friend.name 	  = data[key].name;
						friend.uid 		  = data[key].uid;
						friend.avatar 	  = data[key].photo_medium;
						
						model.friendsAll.push(friend);
					}
					getFriendsUidsInApp();
					break;
				}
					
				case Token.GET_FRIENDS_UIDS_IN_APP:
				{
					if (data.length != 0)
					{
						model.user.friendsInApp_uids = new Vector.<String>;
						for (i=0; i < data.length; i++)
						{
							model.user.friendsInApp_uids.push(String(data[i]));
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
				
				case Token.VK_GET_URL_PHOTOUPLOADSERVER:
				{
					model.wall.vk_upload_url = data.upload_url;
					loadImage();
					break;
				}
				
				case Token.VK_WALL_POST:
				{			
					api.callMethod('saveWallPost', data.post_hash);
					break;
					
				}
			}
			
		}
		
		private function onError(data:Object):void
		{
			trace('Error');
		}
	}
}