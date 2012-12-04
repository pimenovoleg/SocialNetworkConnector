package com.nextgame.networks
{
	import com.adobe.images.PNGEncoder;
	import com.adobe.serialization.json.JSON;
	import com.api.vk.APIConnection;
	import com.api.vk.WallImgOnServer;
	import com.api.vk.apivk.VKMethod;
	import com.api.vk.events.CustomEvent;
	import com.demonsters.debugger.MonsterDebugger;
	import com.nextgame.data.FriendVO;
	import com.nextgame.data.SocialApiData;
	import com.nextgame.data.UserVO;
	import com.nextgame.data.WallVO;
	import com.nextgame.events.SARequestEvent;
	import com.nextgame.logging.LogType;
	import com.nextgame.logging.Logger;
	import com.nextgame.networks.enums.NetworkName;
	import com.nextgame.networks.enums.Token;
	import com.nextgame.parsers.ParseDataVK;
	import com.nextgame.parsers.ParseNetAnswer;
	import com.nextgame.utils.MultipartURLLoader;
	import com.nextgame.utils.StringUtils;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	public class VKNetwork extends AbstractNetwork
	{				
		private var api:APIConnection;
		
		public function VKNetwork($fv:Object, $onComplete:Function)
		{				
			super($fv, this, $onComplete);
			_uid = flashvars.viewer_id;
			
			api = new APIConnection(flashvars);		
			api.addEventListener(CustomEvent.WALL_SAVE, onWallAnser);
			api.addEventListener(CustomEvent.WALL_CANCEL, onWallAnser);
			standartPool();
			_network = NetworkName.VK;
			_networkID = NetworkName.VK_ID;
		}
		
		override public function showInviteBox($text:String=null, $params:String=null):void
		{		
			api.forceDirectApiAccess(true);
			api.callMethod('showInviteBox');
		}
		
		override public function showPaymentBox($pay:uint,$type:String ='',$mes:String = 'nextGame'):void
		{
			api.forceDirectApiAccess(true);
			api.callMethod('showPaymentBox', $pay);
		}
		
		override public function getUserProfile():void
		{
			super.getUserProfile();

			api.forceDirectApiAccess(true);
			api.api(VKMethod.EXECUTE, {code:'var a=API.getProfiles({\"uids\":\"'+ _uid +'\",\"fields\":\"city,first_name,last_name,sex,birthdate,education,photo, photo_medium, photo_big\"}); return {"userInfo":a,city:API.getCities({"cids":a@.city})@.name,"country":API.getCountries({cids:1})@.name}; '},
				onComplete, onError);
		}
		
		override public function getFriendsUids():void
		{
			super.getFriendsUids();
			api.forceDirectApiAccess(true);
			api.api(VKMethod.GET_FRIENDS,{uids:_uid}, onComplete, onError);
		}
		
		override public function getFriendsProfiles():void
		{
			super.getFriendsProfiles();
			api.forceDirectApiAccess(true);
			api.api(VKMethod.GET_PROFILES, {uids:model.user.friends_uids, fields:'first_name, last_name, photo, photo_medium, photo_big'},
				onComplete, onError);
		}
		
		override public function getFriendsUidsInApp():void
		{
			super.getFriendsUidsInApp();
			api.forceDirectApiAccess(true);
			api.api(VKMethod.GET_FRIENDS_APP, {uids:_uid}, onComplete, onError);
		}
		
		override public function getFriendsProfilesInApp():void
		{			
			super.getFriendsProfilesInApp();
			api.forceDirectApiAccess(true);
			api.api(VKMethod.GET_PROFILES, {uids:model.user.friendsInApp_uids, fields:'first_name, last_name, photo, photo_medium, photo_big'},
				onComplete, onError);
		}
		
		/**
		 * 
		 * @param $wallUid - uid пользователя на котором будет пост
		 * 
		 */
		override public function wall_postMessage($params:Object,$cbFunc:Function):void
		{
			model.wall.wall_uid = $params.wallUid;
			model.wall.mc		= $params.mc;
			model.wall.message  = $params.message;
			model.wall.post_id  = $params.post_id;
			model.wall.photo_id = $params.photo_id;
			model.wall.photo = $params.photo;
			model.wall.server = $params.server;
			model.wall.hash = $params.hash;
			model.wall.cbFunc = $cbFunc;
			model.wall.photo_url = $params.url;

			if ($params.photo_id != null)
			{
				wall_savePostConstImage();
				return;
			}
			
			if ($params.photo != null)
			{
				wall_savePost();
				return;
			}
			
			if (model.wall.vk_upload_url == null)
				wall_getPhotoUploadServer();
			else
				loadImage();
		}
		//********* WALL *******************		
		
		private function wall_savePost():void
		{
			api.forceDirectApiAccess(true);
			token = Token.VK_WALL_SAVE_POST;
			api.api(VKMethod.WALL_SAVE_PHOTO_POST,{wall_id:model.wall.wall_uid, post_id:model.wall.post_id, message:model.wall.message, server:model.wall.server, photo:model.wall.photo, hash:model.wall.hash} , onComplete, onError);
		}
		
		override public function getWallpostServer($cbFunc:Function):void
		{
			api.api(VKMethod.WALL_GET_UPLOADSERVER, {}, function (data:Object):void{model.wall.server = data.upload_url;$cbFunc(data.upload_url);}, onError);
		}
		
		private function wall_post():void
		{
			api.forceDirectApiAccess(false);
			var obj: Object = {owner_id:model.wall.wall_uid, message:model.wall.message, attachment : model.wall.photo_id};
			MonsterDebugger.trace(this,obj,token);
			token = Token.VK_WALL_POST;		
			api.api(VKMethod.WALL_POST, obj, onComplete, onError);
		}
		
		private function wall_savePostConstImage($havePhoto_id:Boolean = true):void
		{
			var obj: Object;
			if ($havePhoto_id)
				obj = {wall_id:model.wall.wall_uid, post_id:model.wall.post_id, message:model.wall.message, photo_id:model.wall.photo_id};
			else
				obj = {wall_id:model.wall.wall_uid, post_id:model.wall.post_id, message:model.wall.message, server : model.wall.server, photo:model.wall.photo,hash:model.wall.hash};
			MonsterDebugger.trace(this,obj,token);
			api.forceDirectApiAccess(true);
			token = Token.VK_WALL_POST;
			api.api(VKMethod.WALL_SAVEPOST,obj , onComplete, onError); // 62124510_150026341
		}
		
		//*******************************************				
		/**
		 * STEP 1 - get URL UPLOAD SERVER
		 */
		private function wall_getPhotoUploadServer():void
		{
			api.forceDirectApiAccess(true);
			token = Token.VK_GET_URL_PHOTOUPLOADSERVER;
			//api.api(VKMethod.WALL_GET_PHOTOUPLOADSERVER, {}, onComplete, onError);
			api.api(VKMethod.WALL_GET_UPLOADSERVER, {}, onComplete, onError);
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
			//wall_savePostConstImage(false);
		}
		
		//***************************************************************************		
		private function onComplete(data:Object):void
		{
			Logger.log('You recive: ' + token, LogType.INFO);
			MonsterDebugger.trace(this,data,'onComplete',token);
			switch(token)
			{
				case Token.GET_USER_PROFILE:
				{
					ParseDataVK.getUserProfile(data);														
					break;
				}
				case Token.GET_FRIENDS_UIDS:
				{
					ParseDataVK.getFriendsUids(data);					
					break;
				}
				case Token.GET_FRIENDS_PROFILES:
				{		
					ParseDataVK.getFriendsProfiles(data);
					break;
				}
					
				case Token.GET_FRIENDS_UIDS_IN_APP:
				{					
					ParseDataVK.getFriendsUidsInApp(data);					
					break;
				}
					
				case Token.GET_FRIENDS_PROFILES_IN_APP:
				{
					ParseDataVK.getFriendsProfilesInApp(data);							
					break;
				}
					
				case Token.VK_GET_URL_PHOTOUPLOADSERVER:
				{
					model.wall.vk_upload_url = data.upload_url;
					loadImage();
					break;
				}
					
					
				case Token.VK_WALL_SAVE_POST:
				{
					model.wall.photo_id = data[0].id;
					wall_post();
					//wall_savePostConstImage();
					break;
				}
					
				case Token.VK_WALL_POST:
				{
					if (data.post_hash)
						model.wall.hash = data.post_hash;
					api.forceDirectApiAccess(false);
					api.callMethod('saveWallPost', model.wall.hash);					
					break;
				}
			}
			dispatchEvent(new SARequestEvent(SARequestEvent.COMPLETE,data));
		}
		
		private function onWallAnser($e:CustomEvent):void
		{
			if (model && model.wall && model.wall.cbFunc!=null)
				model.wall.cbFunc(ParseNetAnswer.wallAnswer($e as Object));
		}
		
		private function onError(data:Object):void
		{
			MonsterDebugger.trace(this,data,'onError',token);
			Logger.log('Error in recive data: ' + token, LogType.ERROR);
			dispatchEvent(new SARequestEvent(SARequestEvent.COMPLETE,data));
		}
		
	}
}