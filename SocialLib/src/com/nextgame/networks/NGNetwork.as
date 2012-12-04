package com.nextgame.networks
{
	
	import com.api.ng.NextGameApi;
	import com.api.ng.api.NextGameRequest;
	import com.api.ng.enum.NextGameMethod;
	import com.nextgame.events.SARequestEvent;
	import com.nextgame.logging.LogType;
	import com.nextgame.logging.Logger;
	import com.nextgame.networks.enums.NetworkName;
	import com.nextgame.networks.enums.Token;
	import com.nextgame.parsers.ParserDataNG;
	
	import flash.display.MovieClip;
	
	public class NGNetwork extends AbstractNetwork
	{
		private var api:NextGameApi;

		private var uids:String;
		
		public function NGNetwork($fl:Object, $onComplete:Function, $key:String)
		{	
			super($fl, this, $onComplete);
			api = new NextGameApi($key, null);
			api.debugObject = $fl;
							
			standartPool();
			_network = NetworkName.NG;
			_networkID = NetworkName.NG_ID;
		}
		
		override public function getUserProfile():void
		{
			super.getUserProfile();
			NextGameRequest.call( NextGameMethod.GET_INFO, {uid:flashvars.uid}, onComplete );				
		}
		
		override public function getFriendsUids():void
		{
			super.getFriendsUids();
			NextGameRequest.call( NextGameMethod.GET_FRIENDS, {uid:flashvars.uid}, onComplete );			
		}
		
		override public function getFriendsProfiles():void
		{
			super.getFriendsProfiles();
			
			if (model.user.friends_uids == null || model.user.friends_uids.length == 0)
			{
				onComplete({});
				return;
			}
			else
				uids = model.user.friends_uids.toString();
			
			NextGameRequest.call( NextGameMethod.GET_INFO, {uid: uids}, onComplete );
			
		}
		
		override public function getFriendsUidsInApp():void
		{
			super.getFriendsUidsInApp();
			NextGameRequest.call( NextGameMethod.GET_APP_FRIENDS, {uid:flashvars.uid}, onComplete );
		}
		
		override public function getFriendsProfilesInApp():void
		{
			super.getFriendsProfilesInApp();
			if (model.user.friendsInApp_uids == null || model.user.friendsInApp_uids.length == 0)
			{
				onComplete({});
				return;
			}
			else
				uids = model.user.friendsInApp_uids.toString();
			
			NextGameRequest.call( NextGameMethod.GET_INFO, {uid: uids}, onComplete );
		}
		
		override public function wall_postMessage($params:Object,cbFunc:Function):void
		{
			NextGameRequest.wallPost($params.message);
		}
		
		override public function showInviteBox($text:String=null, $params:String=null):void
		{
			NextGameRequest.openInviteDialog();
		}
		
		override public function showPaymentBox($pay:uint, $type:String ='',$mes:String = 'nextGame'):void
		{	
			NextGameRequest.openDialog('', $pay, $type, '', '');
		}
		
		private function onComplete(data:*):void
		{
			Logger.log('You recive: ' + token, LogType.INFO);			
			
			if (data.result)
			{
				switch(token)
				{
					case Token.GET_USER_PROFILE:
					{
						ParserDataNG.getUserProfile(data.data);						
						break;
					}
					case Token.GET_FRIENDS_UIDS:
					{
						ParserDataNG.getFriendsUids(data.data);
						break;
					}
					case Token.GET_FRIENDS_PROFILES:
					{
						ParserDataNG.getFriendsProfiles(data.data);
						break;
					}
					case Token.GET_FRIENDS_UIDS_IN_APP:
					{
						ParserDataNG.getFriendsUidsInApp(data.data);
						break;
					}
					case Token.GET_FRIENDS_PROFILES_IN_APP:
					{
						ParserDataNG.getFriendsProfilesInApp(data.data);
						break;
					}
						
				}
			}
			dispatchEvent(new SARequestEvent(SARequestEvent.COMPLETE));
		}
	}
}