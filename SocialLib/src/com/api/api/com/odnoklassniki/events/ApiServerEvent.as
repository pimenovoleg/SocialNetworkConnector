package com.api.api.com.odnoklassniki.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Igor Nemenonok
	 */
	public class ApiServerEvent extends Event 
	{
		public static const CONNECTED:String = "odnoklassniki_connected";
		public static const CONNECTION_ERROR:String = "odnoklassniki_connection_error";
		public static const PROXY_NOT_RESPONDING:String = "odnoklassniki_proxy_not_reponding";
		public static const NOT_YET_CONNECTED:String = "odnoklassniki_not_yet_connected";
		
		
		public var data:Object;
		
		public function ApiServerEvent(type:String, data:Object = null) 
		{
			this.data = data;
			super(type);
		}
		
	}

}