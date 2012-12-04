package com.api.nextgame.apis 
{
	
	import com.api.nextgame.enum.Request;
	import com.api.nextgame.events.NextGameEvent;
	import com.api.nextgame.interfaces.INextGameApi;
	import com.api.nextgame.utils.JSONParser;
	import com.api.nextgame.utils.NGError;
	import com.api.nextgame.utils.RequestFormat;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author NextGame
	 */
	public class RestAPI extends EventDispatcher implements INextGameApi 
	{
		private var _uid:String;
		private var _app_id:String; 		
		private var _private_key:String;		
		private var _session_key:String;
		private var _rest_url:String;
		
		private var jsonParser:JSONParser;
		private var loader:URLLoader;
		
		public var urlVars:URLVariables;
		
		/**
		 * 
		 * @param uid
		 * @param app_id
		 * @param private_key
		 * @param session_key
		 * @param rest_url
		 * 
		 */
		public function RestAPI(uid:String, app_id:String, private_key:String, session_key:String, rest_url:String = "") 
		{
			this._uid = uid;
			this._app_id = app_id;
			this._private_key = private_key;
			this._session_key = session_key;
			this._rest_url = rest_url;
			this.urlVars = new URLVariables;
			this.jsonParser = new JSONParser();
		}
		
		public function get rest_url():String
		{
			return _rest_url;
		}

		public function get uid():String
		{
			return _uid;
		}
		
		public function get app_id():String 
		{
			return _app_id;
		}
		
		public function get private_key():String
		{
			return _private_key;
		}
		
		public function get session_key():String
		{
			return _session_key;
		}
		
		/**
		 * 
		 * @param method - метод запроса
		 * 
		 */
		public function request(method:String, ...args):void
		{
			if (method == Request.OPEN_DIALOG)
			{
				openDialog(args[0], args[1], args[2], args[3], args[4]);
				return;
			}
			else if(method == Request.OPEN_INVITE_DIALOG)
			{
				openInviteDialog();
				return;
			}
				
			addUrlVars(method);
			addURLLoader();
			RequestFormat.format(this.urlVars, private_key);		
			doRequest();
		}
		
		private function openInviteDialog():void
		{
			trace('openInviteDialog NG');
			ExternalInterface.call(Request.OPEN_INVITE_DIALOG);
		}
		
		private function openDialog(service_id:String, coins:uint, name:String, description:String, extra:String):void
		{
			trace('openDialog NG');
			ExternalInterface.call("payment.openDialog", service_id, coins, name, description, extra);
		}
		
		private function doRequest():void
		{
			var request:URLRequest = new URLRequest(rest_url);
			request.contentType = "application/x-www-form-urlencoded";
			request.method = URLRequestMethod.POST;			
			request.data = urlVars;
			
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(request);
			trace(request.url + '?' + unescape(urlVars.toString()));
		}
		
		private function addUrlVars(method:String):void
		{
			if (urlVars != null)
				urlVars = new URLVariables;	
				
			urlVars.uid = uid;
			urlVars.method = method;
			urlVars.session_key = session_key;
			urlVars.app_id = app_id;
		}
		
		private function addURLLoader():void 
		{
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onDataComplete);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		}
		
		private function removeURLLoader():void
		{
			if (loader == null) return;			
			loader.removeEventListener(Event.COMPLETE, onDataComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		}
		
		private function onHTTPStatus(event:HTTPStatusEvent):void {}
		private function onError(event:ErrorEvent):void {}
		
		
		private function onDataComplete(event:Event):void 
		{
			removeURLLoader();
			var result:String = event.target.data as String;
			
			var error:NGError = jsonParser.validationResult(result);
			
			if (error.error == null) 
			{
				var dataResult:* = jsonParser.parse();
				
				dispatchEvent(new NextGameEvent(NextGameEvent.COMPLETE, false, false, true, dataResult));
			}
			else
			{
				dispatchEvent(new NextGameEvent(NextGameEvent.COMPLETE, false, false, false, null, error));
			}			
		}
		
		
		
	}

}