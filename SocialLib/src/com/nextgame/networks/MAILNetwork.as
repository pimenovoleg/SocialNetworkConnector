package com.nextgame.networks
{
	import com.api.mailru.js.MailruCall;
	import com.api.mailru.js.MailruCallEvent;
	import com.api.mailru.rest.MyApiNode;
	import com.api.nextgame.events.NextGameEvent;
	import com.demonsters.debugger.MonsterDebugger;
	import com.demonsters.debugger.MonsterDebuggerData;
	import com.nextgame.events.SARequestEvent;
	import com.nextgame.logging.LogType;
	import com.nextgame.logging.Logger;
	import com.nextgame.networks.enums.NetworkName;
	import com.nextgame.networks.enums.Token;
	import com.nextgame.parsers.ParseDataMAILRU;
	import com.nextgame.parsers.ParseNetAnswer;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	public class MAILNetwork extends AbstractNetwork
	{
		private var restApi:MyApiNode;
		private var _callBack:Function;
		
		public function MAILNetwork($fl:Object, $onComplete:Function, $key:String)
		{
			_callBack = $onComplete;
			super($fl, this, $onComplete);		
			this.restApi = new MyApiNode($fl.vid, $fl.app_id, $key, $fl.session_key, this.onComplete);
			MailruCall.init("flash-app", $key);
			MailruCall.addEventListener(Event.COMPLETE, mailruReadyHandler);
			MonsterDebugger.trace(this,$key,'initMail.ru');
			_network = NetworkName.MAIL;
			_networkID = NetworkName.MAIL_ID;
			
			MailruCall.addEventListener ( MailruCallEvent.STREAM_PUBLISH, streamPublishHandler );
			
		}
		
		private function mailruReadyHandler(event:Event):void
		{
			MonsterDebugger.trace(this,event.target,'initMail.ru','Finish INIT');
			standartMailPool();
			/*MailruCall.addEventListener(MailruCallEvent.INCOMING_PAYMENT , paymentStatusCallback);
			MailruCall.addEventListener(MailruCallEvent.PAYMENT_DIALOG_STATUS , paymentStatus);*/
		}

		
		override public function getUserProfile():void
		{
			super.getUserProfile();
			MailruCall.exec( 'mailru.common.users.getInfo', onComplete );
			//restApi.usersGetInfo([flashvars.vid]);
			MonsterDebugger.trace(this,flashvars.vid, 'getUserProfile');
		}
		
		override public function getAppHash():void
		{
			MonsterDebugger.trace(this,null,token);
			super.getAppHash();
			MailruCall.addEventListener(MailruCallEvent.READ_HASH,onComplete);
			MailruCall.exec('mailru.app.utils.hash.read');
		}
		
		override public function getFriendsUids():void
		{
			super.getFriendsUids();
			restApi.friendsGet();
		}
		
		override public function getFriendsProfiles():void
		{
			super.getFriendsProfiles();
			//restApi.friendsGet(1);
			MailruCall.exec ( 'mailru.common.friends.getExtended', onComplete, [flashvars.vid] );
		}
		
		override public function getFriendsUidsInApp():void
		{
			super.getFriendsUidsInApp();
			restApi.friendsGetAppUsers();
		}
		
		override public function getFriendsProfilesInApp():void
		{
			super.getFriendsProfilesInApp();
			MailruCall.exec ( 'mailru.common.friends.getAppUsers', onComplete, [flashvars.vid] );
			//restApi.friendsGetAppUsers(1);
		}
		
		override public function wall_postMessage($params:Object,$cbFunc:Function):void
		{
			
			model.wall.cbFunc = $cbFunc;
			
			MailruCall.exec ( 'mailru.common.stream.post', null, {
				'title': $params.title,
				'text': $params.text,
				'img_url': $params.img_url,
				'action_links' : $params.action_links
			} );
		}
		
		private function streamPublishHandler ( event : MailruCallEvent ) : void 
		{
			MonsterDebugger.trace(this,event,'streamPublishHandler');
			var ans:String = ParseNetAnswer.wallAnswer(event as Object);
			if (ans != ParseNetAnswer.WALL_WAIT)
				if (model && model.wall && model.wall.cbFunc!=null)
					model.wall.cbFunc(ans);
			//if (event.data.status == "publishSuccess") _callBack({'type' : 'onWallPostSave'});
		}
		
		override public function showInviteBox($text:String=null, $params:String=null):void
		{
			MailruCall.exec ( 'mailru.app.friends.invite');
		}
		
		override public function showPaymentBox($pay:uint,$type:String ='',$mes:String = 'nextGame'):void
		{
			if ($type == 'sms') 
				MailruCall.exec ( 'mailru.app.payments.showDialog',null,{'sms_price' : $pay,'service_name':$mes});
			else
				MailruCall.exec ( 'mailru.app.payments.showDialog',null,{'other_price' : $pay,'service_name':$mes});
			/*MailruCall.exec('mailru.app.payments.showDialog', $callback, {
				service_id: $service_id,
				service_name: $service_name, 
				sms_price: $sms_price,
				other_price: $other_price
			} );*/
		}
		
		private function onComplete(data:*):void
		{
			MonsterDebugger.trace(this,data as Object,'onComplete',token);
			
			/*if (data && data.error)
			{
				trace(data.error.error_msg + ' error Code '+ data.error.error_code);
				return;
			}*/
			
			Logger.log('You recive: ' + token, LogType.INFO);
			switch(token)
			{
				case Token.GET_USER_PROFILE:
				{
					MonsterDebugger.trace(this,data[0],'GET USER PROFILE');
					ParseDataMAILRU.getUserProfile(data[0]);
					//skipEventComplete = true;
					//MailruCall.addEventListener(MailruCallEvent.READ_HASH,onComplete);
					//token = Token.MR_HASH_READ;
					//trace('Token ' + Token.MR_HASH_READ);
					//MailruCall.exec('mailru.app.utils.hash.read');
					break;
				}
				case Token.MR_HASH_READ:
				{
					MonsterDebugger.trace(this,data,'MR_HASH_READ');
					MonsterDebugger.breakpoint(this);
					if (data && data != '')
						ParseDataMAILRU.getHashInfo(data.data);
					//skipEventComplete = false;
					MailruCall.removeEventListener(MailruCallEvent.READ_HASH,onComplete);
					break;
				}
					
				case Token.GET_FRIENDS_UIDS:
				{
					ParseDataMAILRU.getFriendsUids(data);
					break;
				}
				case Token.GET_FRIENDS_PROFILES:
				{
					ParseDataMAILRU.getFriendsProfiles(data);
					break;
				}
				case Token.GET_FRIENDS_UIDS_IN_APP:
				{
					ParseDataMAILRU.getFriendsUidsInApp(data);
					break;
				}
				case Token.GET_FRIENDS_PROFILES_IN_APP:
				{
					ParseDataMAILRU.getFriendsProfilesInApp(data);
					break;
				}
					
			}
		
			if (!skipEventComplete) 
			{
				dispatchEvent(new SARequestEvent(SARequestEvent.COMPLETE));
			}
		}
	}
}