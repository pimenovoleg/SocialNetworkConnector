package com.api.api.com.odnoklassniki.sdk.share 
{
	import com.api.api.com.odnoklassniki.Odnoklassniki;
	/**
	 * ...
	 * @author Igor Nemenonok
	 */
	public class Share 
	{
		
		/**
		 * Add share with link URL and optional commentary. URL must be accessible by odnoklassniki server.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+share.addLink
		 * @param	linkUrl - Shared resource URL 
		 * @param	callback
		 * @param	comment - First comment attached to shared resource link 
		 */
		public static function addLink(linkUrl:String, callback:Function, comment:String = ""):void {
			Odnoklassniki.callRestApi("share.addLink", callback, Odnoklassniki.getSendObject({linkUrl:linkUrl, comment:comment }) );
		}
		
	}

}