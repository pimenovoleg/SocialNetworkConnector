package com.nextgame.networks
{
	import com.api.od.ApiCallbackEvent;
	import com.api.od.ForticomAPI;
	import com.api.od.ODAnswers;
	import com.api.od.ODApi;
	import com.api.od.ODMethod;
	import com.api.od.SignUtil;
	import com.demonsters.debugger.MonsterDebugger;
	import com.nextgame.data.FriendVO;
	import com.nextgame.data.SocialApiData;
	import com.nextgame.data.UserVO;
	import com.nextgame.events.SARequestEvent;
	import com.nextgame.logging.LogType;
	import com.nextgame.logging.Logger;
	import com.nextgame.networks.enums.NetworkName;
	import com.nextgame.networks.enums.Token;
	import com.nextgame.parsers.ParseDataOD;
	import com.nextgame.parsers.ParseNetAnswer;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.AntiAliasType;
	
	public class ODNetwork extends AbstractNetwork
	{
		private var api:ODApi;	
		private var _request:Object;
		
		public function ODNetwork($fv:Object, $onComplete:Function)
		{
			super($fv, this, $onComplete);
			this.api = new ODApi($fv);
			ForticomAPI.connection = $fv.apiconnection;
			standartPool();
			_network = NetworkName.OD;
			_networkID = NetworkName.OD_ID;
		}
		
		override public function showInviteBox($text:String=null, $params:String=null):void
		{
			ForticomAPI.showInvite($text, $params);
		}
		
		override public function showPaymentBox($pay:uint,$type:String ='',$mes:String = 'nextGame'):void
		{
			ForticomAPI.showPayment($type,$mes,'NextGame',$pay);
		}
		
		public override function getUserProfile():void
		{			
			super.getUserProfile();
			var allFields:String = "uid,first_name,last_name,name,gender,age,location,pic_1,pic_2";

			var params:Object = {method: ODMethod.USERS_GET_INFO, uids: flashvars.logged_user_id, fields: allFields};
			api.sendRequest(params, onComplete, onError);
		}
		
		public override function getFriendsUids():void
		{
			super.getFriendsUids();			
			var params:Object = {method: ODMethod.FRIENDS_GET};
			api.sendRequest(params, onComplete, onError);
		}
		
		public override function getFriendsProfiles():void
		{
			super.getFriendsProfiles();			
			var allFields:String = "uid,first_name,last_name,name,gender,age,location,pic_1,pic_2";
			
			/*while  (model.user.friends_uids.length<110)
				model.user.friends_uids.push(model.user.friends_uids[0]+model.user.friends_uids.length);*/
			if (model.user.friends_uids && model.user.friends_uids.length>0)
				var params:Object = {method: ODMethod.USERS_GET_INFO, uids: model.user.friends_uids.slice(0,Math.min(98,model.user.friends_uids.length)), fields: allFields};
			else
			{
				onComplete([]);
				return;
			}
			api.sendRequest(params, onComplete, onError);
			trace('friends_uids.length ' + model.user.friends_uids.length);			
		}
		
		public override function getFriendsUidsInApp():void
		{
			super.getFriendsUidsInApp();			
			var params:Object = {method: ODMethod.FRIENDS_GET_APP_USERS};
			api.sendRequest(params, onComplete, onError);
			
		}
		
		public override function getFriendsProfilesInApp():void
		{
			super.getFriendsProfilesInApp();
			
			var allFields:String = "uid,first_name,last_name,name,gender,age,location,pic_1";
			
			if (model.user.friendsInApp_uids && model.user.friendsInApp_uids.length>0)
				var params:Object = {method: ODMethod.USERS_GET_INFO, uids: model.user.friendsInApp_uids.slice(0,Math.min(98,model.user.friendsInApp_uids.length)).join(), fields: allFields};
			else
			{
				onComplete([]);
				return;
			}
			
			api.sendRequest(params, onComplete, onError);
			
			trace('friendsInApp_uids.length ' + model.user.friendsInApp_uids.length);
		}
		
		override public function wall_postMessage($params:Object,$cbFunc:Function):void
		{
			super.wall_postMessage($params,$cbFunc);
			
			ForticomAPI.addEventListener(ApiCallbackEvent.CALL_BACK, handleApiCallback);
			_request = $params;
			_request.method = ODMethod.PUBLISH_STREAM;
			
			//_request = SignUtil.signRequest(_request, true);
			api.createConstatsArg(_request);
			
			MonsterDebugger.trace(this,_request,'wall_postMessage','request');
			ForticomAPI.showConfirmation(ODMethod.PUBLISH_STREAM, $params.message, _request["sig"]);
			
			model.wall.cbFunc = $cbFunc;
			
			/*token = 'wall_postMessage';
			var params:Object = {
				method : ODMethod.PUBLISH_STREAM,
				message : $message,
				attachment:{
					caption :$post_id,
					media: [{href:$mc.href,src:$photo_id,type:'image'}]
					},
				action_links : $mc
				}
				
			api.sendRequest(params, onComplete, onError);*/
		}
		
		private function handleApiCallback(event : ApiCallbackEvent):void
		{
			ForticomAPI.removeEventListener(ApiCallbackEvent.CALL_BACK, handleApiCallback);
			
			if (event.result== ODAnswers.STREAM_PUBLISHED)
			{
				// user accepted action
				model.wall.resig = event.data;
				
				// finally you can send request to server
				
				_request.resig = model.wall.resig;
				
				//params = SignUtil.signRequest(params, true);
				
				//MonsterDebugger.trace(this,_request.sig,'handleApiCallback','request to server post');
				api.sendRequest(_request, onComplete, onError);
			}
			else
			{
				if (model.wall.cbFunc != null)
					model.wall.cbFunc(ParseNetAnswer.WALL_NON_POSTED);
				// user declined action
			}
			
			ForticomAPI.removeEventListener(ApiCallbackEvent.CALL_BACK, handleApiCallback);
		}
		
		private function onComplete(data:*):void
		{
			MonsterDebugger.trace(this, data as Object,'onComplete',token);
			Logger.log('You recive: ' + token, LogType.INFO);
			if(!(data is String) && data['error_code']){
				trace(token + ' - ERROR');
				return;
			}
			switch(token)
			{
				case Token.GET_USER_PROFILE:
				{	
					ParseDataOD.getUserProfile(data[0]);					
					break;
				}
					
				case Token.GET_FRIENDS_UIDS:
				{
					ParseDataOD.getFriendsUids(data);					
					break;
				}
				case Token.GET_FRIENDS_PROFILES:
				{
					ParseDataOD.getFriendsProfiles(data);				
					break;
				}
					
				case Token.GET_FRIENDS_UIDS_IN_APP:
				{		
					ParseDataOD.getFriendsUidsInApp(data);					
					break;
				}
					
				case Token.GET_FRIENDS_PROFILES_IN_APP:
				{
					ParseDataOD.getFriendsProfilesInApp(data);
					break;
				}
				case Token.POST_TO_STREAM:
				{
					if (model.wall.cbFunc != null)
						model.wall.cbFunc(ParseNetAnswer.WALL_POSTED);
					break;
				}
			}
			dispatchEvent(new SARequestEvent(SARequestEvent.COMPLETE));
		}
		
		private function onError(data:Object):void
		{
			Logger.log('Error in recive data: ' + token, LogType.ERROR);
			dispatchEvent(new SARequestEvent(SARequestEvent.COMPLETE));
		}
	}
}