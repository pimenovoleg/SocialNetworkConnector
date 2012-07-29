package com.ng.interfaces
{
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	
	public interface ISocialAPI extends IEventDispatcher
	{
		function start():void;
		function getUserProfile():void;
		function getFriendsUids():void;
		function getFriendsProfiles():void;
		function getFriendsUidsInApp():void;
		function getFriendsProfilesInApp():void;
		
		function wall_postMessage($wallUid:String, $mc:MovieClip, $message:String, $post_id:String = 'wallpost13', $photo_id:String=null):void;
		
		/*function showInviteUsersWindow():void;
		function showPaymentWindow():void;
		*/
	}
}