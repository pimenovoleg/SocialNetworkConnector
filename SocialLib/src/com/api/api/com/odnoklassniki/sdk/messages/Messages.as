package com.api.api.com.odnoklassniki.sdk.messages 
{
	import com.api.api.com.odnoklassniki.Odnoklassniki;
	/**
	 * ...
	 * @author Igor Nemenonok
	 */
	public class Messages 
	{
		/**
		 * Retrieves the list of recent conversations with friends. All messages are grouped into conversations. Each conversation contains messages sent to/received from one distinct user.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+messages.getConversations
		 * @param	callback
		 * @param	last_check - (DateTime) The time of previous check for latest conversations. The method returns conversations that has messages that was sent later than time specified in this parameter. It allows to periodically scan for new messages. If this parameter is not specified then all recent conversations are returned. 
		 * @param	return_last_msg - Specifies whether it is required or not to return text of last message. Default value: false. 
		 */
		public static function getConversations(callback:Function, last_check:String = "", return_last_msg:Boolean = false):void {
			Odnoklassniki.callRestApi("messages.getConversations", callback, Odnoklassniki.getSendObject({last_check:last_check, return_last_msg:return_last_msg}) );
		}
		
		/**
		 * Retrieves the list of messages from conversation with specified user.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+messages.getList
		 * @param	friend_uid - The ID of user whose conversation message need to retrieve 
		 * @param	first - The index of first message to return. Index 0 corresponds to most recent message in conversation. 
		 * @param	count - The count of messages to return. The maximal count that can be requested is 100 messages. 
		 * @param	callback
		 * @param	txt_limit - The maximal length of message body to return. This parameter allows to minimize the traffic. All messages will be truncated to this length if this parameter is specified. The whole message body is returned if this parameter is omitted. 
		 */
		public static function getList(friend_uid:String, first:int, count:int, callback:Function, txt_limit:String = ""):void {
			Odnoklassniki.callRestApi("messages.getList", callback, Odnoklassniki.getSendObject({friend_uid:friend_uid, first:first, count:count, txt_limit:txt_limit}) );
		}
		
		/**
		 * Retrieves full message body & meta-information for specified message ID.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+messages.get
		 * @param	msg_id - The ID of message to retrieve 
		 * @param	callback
		 */
		public static function get(msg_id:String, callback:Function):void {
			Odnoklassniki.callRestApi("messages.get", callback, {msg_id:msg_id} );
		}
		
		/**
		 * Send the message to the user on portal. The plain text messages are supported only.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+messages.send
		 * @param	friend_uid - The ID of user to whom the message is sent 
		 * @param	text - The message body. The message body should be URL encoded if this operation is invoked via HTTP GET request. The maximal length of message is 1000 symbols. 
		 * @param	callback
		 * @param	uid - The user ID of message sender. Specify the uid when calling this method without a session key. 
		 */
		public static function send(friend_uid:String, text:String, callback:Function, uid:String = ""):void {
			Odnoklassniki.callRestApi("messages.send", callback, Odnoklassniki.getSendObject({uid:uid, friend_uid:friend_uid, text:text}) );
		}
		
		/**
		 * Mark message as read. The system remembers the most recent message that was read. Therefore it make sense to call this method once for most recent message shown to user. This operation has no effect if system already recorded information about more recently read message that message specified as parameter value.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+messages.markAsRead
		 * @param	msg_id
		 * @param	callback
		 */
		public static function markAsRead(msg_id:String, callback:Function):void {
			Odnoklassniki.callRestApi("messages.markAsRead", callback, {msg_id:msg_id} );
		}
		
		/**
		 * Marks several messages as spam.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+messages.markAsSpam
		 * @param	msg_ids - IDs of messages that should be marked as spam. Maximal count of enumerated message IDs is 100
		 * @param	callback
		 */
		public static function markAsSpam(msg_ids:Array, callback:Function):void {
			Odnoklassniki.callRestApi("messages.markAsSpam", callback, {msg_ids:msg_ids.join(",")} );
		}
		
		/**
		 * Delete several messages.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+messages.delete
		 * @param	msg_ids - IDs of messages that should be marked as spam. Maximal count of enumerated message IDs is 100
		 * @param	callback
		 */
		public static function messagesDelete(msg_ids:Array, callback:Function):void {
			Odnoklassniki.callRestApi("messages.delete", callback, {msg_ids:msg_ids.join(",")} );
		}
	}

}