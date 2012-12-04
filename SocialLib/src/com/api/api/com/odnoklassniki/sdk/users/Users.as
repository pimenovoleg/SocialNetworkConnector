package com.api.api.com.odnoklassniki.sdk.users 
{
	import com.api.api.com.odnoklassniki.Odnoklassniki;
	/**
	 * ...
	 * @author Igor Nemenonok
	 */
	public class Users 
	{
		
		/**
		 * This method lets application check, if the application has not exceeded the limit of method calls for the specified user.
		 * Every application user has a certain amount of method calls. Limits are described in Application Limits
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+users.getCallsLeft
		 * @param	methods - List of method names
		 * @param	callback
		 * @param	uid - ID of the user 
		 */
		public static function getCallsLeft(methods:Array, callback:Function, uid:String = ""):void {
			Odnoklassniki.callRestApi("users.getCallsLeft", callback, Odnoklassniki.getSendObject({uid:uid, methods:methods.join(",")}) );
		}
		
		/**
		 * Retrieves the list of all guests for the specified user.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+users.getGuests
		 * @param	callback
		 * @param	pagingAnchor - Paging anchor is used for paging across the list of the user's guests.
		 * @param	pagingDirection - Specified direction of paging (forward, backward)
		 * @param	count - The count of user's guest to be returned. The maximal count that can be requested is 20 guests. The default value is 10. 
		 * @param	detectTotalCount - Try to detect the total number of guests. The default is false. 
		 */
		public static function getGuests(callback:Function, pagingAnchor:String = "", pagingDirection:String = "forward", count:int = 10, detectTotalCount:Boolean = false):void {
			Odnoklassniki.callRestApi("users.getGuests", callback, Odnoklassniki.getSendObject({pagingAnchor:pagingAnchor, pagingDirection:pagingDirection, count:count, detectTotalCount:detectTotalCount}) );
		}
		
		/**
		 * Returns a wide array of user-specific information for each user identifier passed.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+users.getInfo
		 * @param	uids - The list of user ID's . The max number of IDs is 100. 
		 * @param	fields - The list of field names 
		 * @param	callback
		 * @param	emptyPictures - If true - do not return default Odnoklassniki images when user photo is not available (From 02.09.2010) 
		 */
		public static function getInfo(uids:Array, fields:Array, callback:Function, emptyPictures:Boolean = false):void {
			Odnoklassniki.callRestApi("users.getInfo", callback, Odnoklassniki.getSendObject({uids:uids.join(","), fields:fields.join(","), emptyPictures:emptyPictures}) );
		}
		
		/**
		 * Returns information about currently logged in user
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+users.getLoggedInUser
		 * @param	callback
		 */
		public static function getLoggedInUser(callback:Function):void {
			Odnoklassniki.callRestApi("users.getLoggedInUser", callback );
		}
		
		/**
		 * Checks if the application has the permission to perform certain method calls for the specified user.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+users.hasAppPermission
		 * @param	ext_perm - Name of the permission you want to check 
		 * @param	callback
		 * @param	uid - ID of the user
		 */
		public static function hasAppPermission(ext_perm:String, callback:Function, uid:String = ""):void {
			Odnoklassniki.callRestApi("users.hasAppPermission", callback, Odnoklassniki.getSendObject({uid:uid, ext_perm:ext_perm}) );
		}
		
		/**
		 * Remove permissions from list of user permissions for calling application.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+users.removeAppPermissions
		 * @param	ext_perm - Name of the permission you want to check 
		 * @param	callback
		 * @param	uid - ID of the user
		 */
		public static function removeAppPermissions(ext_perm:String, callback:Function, uid:String = ""):void {
			Odnoklassniki.callRestApi("users.removeAppPermissions", callback, Odnoklassniki.getSendObject({uid:uid, ext_perm:ext_perm}) );
		}
		
		/**
		 * Checks if user has installed the application
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+users.isAppUser
		 * @param	uid - ID of the user is session not specified
		 * @param	callback
		 */
		public static function isAppUser(callback:Function, uid:String = ""):void {
			Odnoklassniki.callRestApi("users.isAppUser", callback, Odnoklassniki.getSendObject({uid:uid}) );
		}
		
		/**
		 * Sets or clears user's status with optional geographic location
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+users.setStatus 
		 * @param	callback
		 * @param	uid - The user ID for the user whose status you want to change. Specify the uid when calling this method without a session key.
		 * @param	status - Status text. If not specified, status will be reset (Location ignored) . 
		 * @param	location - JSON encoded Geographic location. 
		 */
		public static function setStatus(callback:Function, uid:String, status:String = "", location:String = ""):void {
			Odnoklassniki.callRestApi("users.setStatus", callback, Odnoklassniki.getSendObject({uid:uid, status:status, location:location}) );
		}
		
		/**
		 * Get current session or oauth session user information
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+users.getCurrentUser
		 * @param	callback
		 */
		public static function getCurrentUser(callback:Function):void {
			Odnoklassniki.callRestApi("users.getCurrentUser", callback );
		}
	}

}