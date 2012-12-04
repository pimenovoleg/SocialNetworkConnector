package com.api.api.com.odnoklassniki.sdk.stream 
{	
	import com.adobe.serialization.json.JSON;
	import com.api.api.com.odnoklassniki.Odnoklassniki;
	import com.api.api.com.odnoklassniki.events.ApiCallbackEvent;

	/**
	 * ...
	 * @author Igor Nemenonok
	 */
	public class Stream 
	{
		
		private static var _callback:Function;
		private static var _request:Object;
		
		/**
		 * This method publishes a post into the user's news and returns ID of the post.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+stream.publish
		 * @param	confirmation_message - Confirmation message shown for user before publishing
		 * @param	publish_message - The message the user enters for the post at the time of publication. Maximum length is 100 characters. 
		 * @param	callback
		 * @param	uid - The user ID. Specify the uid when calling this method without a session key. 
		 * @param	attachment - Object that contains the text of the post, relevant links, a media type (image, mp3, flash), as well as any other key/value pairs you may want to add
		 * @param	action_links - Array of action link objects, containing the link text and a hyperlink. 
		 */
		public static function publish(confirmation_message:String, publish_message:String, callback:Function, uid:String = "", attachment:Object = null, action_links:Array = null):void
		{
			_callback = callback;
			if(!Odnoklassniki.hasEventListener(ApiCallbackEvent.CALL_BACK)){
				Odnoklassniki.addEventListener(ApiCallbackEvent.CALL_BACK, onCallBack);
			}
			
			_request = { method : "stream.publish", message : publish_message};
			if (uid) _request.uid = uid;
			if (attachment) _request.attachment = JSON.encode(attachment);
			if (action_links) _request.action_links = JSON.encode(action_links);
			
			_request = Odnoklassniki.getSignature(_request, true);
			Odnoklassniki.showConfirmation("stream.publish", confirmation_message, _request.sig);
		}
		
		static private function onCallBack(event:ApiCallbackEvent):void 
		{
			if (event.method == "showConfirmation") {
				switch (event.result) {
					case "ok":
						_request["resig"] = event.data;
						Odnoklassniki.callRestApi("stream.publish", onStreamPublish, _request);
						break;
					case "cancel":
						_callback( { "cancel":"notification has been canceled" } );
						break;
				}
			}
		}
		
		static private function onStreamPublish(d:Object):void 
		{
			_callback(d);
		}
		
	}

}