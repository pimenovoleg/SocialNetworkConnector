package com.api.api.com.odnoklassniki.sdk.friends 
{
	import com.api.api.com.odnoklassniki.Odnoklassniki;
	/**
	 * ...
	 * @author Igor Nemenonok
	 */
	public class Friends 
	{
		/**
		 * Returns status of friendship between users specified by 2 arrays of the same lenght
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+friends.areFriends
		 * @param	uids1 - The list of source user IDs 
		 * @param	uids2 - The list of target user IDs 
		 * @param	callback
		 */
		public static function areFriends(uids1:Array, uids2:Array, callback:Function):void {
			Odnoklassniki.callRestApi("friends.areFriends", callback, { uids1:uids1.join(","), uids2:uids2.join(",") } );
		}
		
		/**
		 * Returns users' IDs of the current user's friends. The current user is determined from the session_key or uid parameters.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+friends.get
		 * @param	callback
		 * @param	uid - The user ID for the user whose friends you want to return. Specify the uid when calling this method without a session key. 
		 */
		public static function get(callback:Function, uid:String):void {
			Odnoklassniki.callRestApi("friends.get", callback, Odnoklassniki.getSendObject({ uid:uid }) );
		}
		
		/**
		 * Returns users' IDs of the current user's friends, who are authorized the calling application. The current user is determined from the session_key.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+friends.getAppUsers
		 * @param	callback
		 */
		public static function getAppUsers(callback:Function):void {
			Odnoklassniki.callRestApi("friends.getAppUsers", callback );
		}
		
		/**
		 * Returns users' IDs of the current user's friends, who have birthday today or in the nearest future . The current user is determined from the session_key or uid parameters.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+friends.getBirthdays
		 * @param	uid - The user ID for the user whose friends you want to return. Specify the uid when calling this method without a session key. 
		 * @param	future - If false - returns only friends having birthday within nearest 3 days, otherwise returns users having birthday during next 30 days. 
		 * @param	callback
		 */
		public static function getBirthdays(callback:Function, uid:String = "", future:Boolean = true):void {
			Odnoklassniki.callRestApi("friends.getBirthdays", callback, Odnoklassniki.getSendObject({uid:uid, future:future}) );
		}
		
		/**
		 * Returns users' IDs of the mutual friends between the source user and target user
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+friends.getMutualFriends
		 * @param	target_id - The source user ID. Specify the source_id when calling this method without a session key
		 * @param	source_id - Target user ID
		 * @param	callback
		 */
		public static function getMutualFriends(target_id:String, callback:Function, source_id:String = ""):void {
			Odnoklassniki.callRestApi("friends.getMutualFriends", callback, Odnoklassniki.getSendObject({target_id:target_id, source_id:source_id}) );
		}
		
		/**
		 * Returns users' IDs of the current user's friends, who are currently online . The current user is determined from the session_key or uid parameters.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+friends.getOnline
		 * @param	uid	- The user ID for the user whose friends you want to return. Specify the uid when calling this method without a session key.
		 * @param	online - One of : web, wap, mobile. If specified, only users online at the specific portal are retrieved
		 * @param	callback
		 */
		public static function getOnline(callback:Function, uid:String = "", online:String = ""):void {
			Odnoklassniki.callRestApi("friends.getOnline", callback, Odnoklassniki.getSendObject({uid:uid, online:online}) );
		}
		
	}

}