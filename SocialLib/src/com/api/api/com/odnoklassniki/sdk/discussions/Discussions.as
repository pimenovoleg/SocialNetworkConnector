package com.api.api.com.odnoklassniki.sdk.discussions 
{	
	import com.api.api.com.odnoklassniki.Odnoklassniki;

	/**
	 * ...
	 * @author Igor Nemenonok
	 */
	public class Discussions 
	{
		/**
		 * Get discussions for user.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+discussions.getDiscussions
		 * @param	callback
		 * @param	entityTypes - List of discussion objects types: GROUP_TOPIC, GROUP_PHOTO,USER_STATUS,USER_PHOTO,USER_FORUM,USER_ALBUM,SHARE 
		 * @param	offset - Offset index from the beginning of results list 
		 * @param	count - Expected results count: default is 10 
		 */
		public static function getDiscussions(callback:Function, entityTypes:Array = null, offset:int = 0, count:int = 10):void {
			Odnoklassniki.callRestApi("discussions.getDiscussions", callback, Odnoklassniki.getSendObject({entityTypes:((entityTypes) ? entityTypes.join(",") : ""), offset:offset, count:count}) );
		}
		
		
		/**
		 * Get comments count within single discussion.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+discussions.getDiscussionCommentsCount
		 * @param	entityType - discussion object type: GROUP_TOPIC, GROUP_PHOTO,USER_STATUS,USER_PHOTO,USER_FORUM,USER_ALBUM,SHARE 
		 * @param	entityId - Discussed object ID 
		 * @param	callback
		 */
		public static function getDiscussionCommentsCount(entityType:String, entityId:String, callback:Function):void {
			Odnoklassniki.callRestApi("discussions.getDiscussionCommentsCount", callback, {entityType:entityType, entityId:entityId} );
		}
		
		/**
		 * Add comment to discussion.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+discussions.addDiscussionComment
		 * @param	entityType - discussion object type: GROUP_TOPIC, GROUP_PHOTO,USER_STATUS,USER_PHOTO,USER_FORUM,USER_ALBUM,SHARE 
		 * @param	entityId - Discussed object ID 
		 * @param	comment - Commentary text 
		 * @param	callback
		 */
		public static function addDiscussionComment(entityType:String, entityId:String, comment:String, callback:Function):void {
			Odnoklassniki.callRestApi("discussions.addDiscussionComment", callback, {entityType:entityType, entityId:entityId, comment:comment} );
		}
		
		/**
		 * Delete comment from discussion.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+discussions.deleteDiscussionComment
		 * @param	entityType - discussion object type: GROUP_TOPIC, GROUP_PHOTO,USER_STATUS,USER_PHOTO,USER_FORUM,USER_ALBUM,SHARE 
		 * @param	entityId - Discussed object ID 
		 * @param	conversationId - Conversation ID
		 * @param	messageIndex - Message index 
		 * @param	callback
		 */
		public static function deleteDiscussionComment(entityType:String, entityId:String, conversationId:Number, messageIndex:Number, callback:Function):void {
			Odnoklassniki.callRestApi("discussions.deleteDiscussionComment", callback, {entityType:entityType, entityId:entityId, conversationId:conversationId, messageIndex:messageIndex } );
		}
		
		/**
		 * Get comments from discussion thread
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+discussions.getDiscussionComments
		 * @param	entityType - discussion object type: GROUP_TOPIC, GROUP_PHOTO,USER_STATUS,USER_PHOTO,USER_FORUM,USER_ALBUM,SHARE
		 * @param	entityId - Discussed object ID 
		 * @param	callback
		 * @param	offset - Offset index from beginning of comments list 
		 * @param	count - Results count 
		 */
		public static function getDiscussionComments(entityType:String, entityId:String, callback:Function, offset:int = 0, count:int = 0):void {
			Odnoklassniki.callRestApi("discussions.getDiscussionComments", callback, Odnoklassniki.getSendObject({entityType:entityType, entityId:entityId, offset:offset, count:count }) );
		}
		
		/**
		 * Mark discussion thread comments as read
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+discussions.markDiscussionAsRead
		 * @param	entityType - discussion object type: GROUP_TOPIC, GROUP_PHOTO,USER_STATUS,USER_PHOTO,USER_FORUM,USER_ALBUM,SHARE
		 * @param	entityId - Discussed object ID 
		 * @param	callback
		 */
		public static function markDiscussionAsRead(entityType:String, entityId:String, callback:Function):void {
			Odnoklassniki.callRestApi("discussions.markDiscussionAsRead", callback, {entityType:entityType, entityId:entityId} );
		}
	}

}