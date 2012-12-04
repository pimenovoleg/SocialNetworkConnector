package com.api.od
{
	public class ODMethod
	{
		/**
		 * Returns users' IDs of the current user's friends 
		 */
		public static const FRIENDS_GET:String = 'friends.get';
		
		/**
		 * Returns users' IDs of the current user's friends, who are authorized the calling application 
		 */
		public static const FRIENDS_GET_APP_USERS:String = 'friends.getAppUsers';
		
		/**
		 * Returns a wide array of user-specific information for each user identifier passed. 
		 */
		public static const USERS_GET_INFO:String = 'users.getInfo';
		
		/**
		 * public some in the users stream. 
		 */
		public static const PUBLISH_STREAM : String = 'stream.publish';
		
	}
}