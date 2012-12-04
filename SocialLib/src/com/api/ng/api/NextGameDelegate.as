package com.api.ng.api
{
	
	import com.adobe.crypto.MD5;
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class NextGameDelegate
	{
		protected var _uid:String;
		protected var _app_id:String;
		public static var _private_key:String;
		protected var _session_key:String;
		protected var _rest_url:String;
		
		private var _global_options: Object;		
		private var loader:URLLoader;
		
		public function NextGameDelegate(uid:String, app_id:String, private_key:String, session_key:String, rest_url:String = "")
		{
			_uid = uid;
			_app_id = app_id;
			_private_key = private_key;
			_session_key = session_key;
			_rest_url = rest_url;
		}
		
		public function request(method: String, options: Object = null):void 
		{			
			if (options == null)
				options = new Object();
			
			options.onComplete = options.onComplete;			
			_sendRequest(method, options);
		}
		
		private function _sendRequest(method:String, options:Object):void 
		{
			var request_params:Object 	= {};			
			request_params.method 		= method;
			request_params.session_key 	= _session_key;
			request_params.app_id 		= _app_id;
			
			if (options.params) 
			{
				for (var i: String in options.params) 
				{					
					request_params[i] = options.params[i];
				}
			}
			
			var urlVars:URLVariables = new URLVariables;
			for (var key: String in request_params) 
			{
				urlVars[key] = request_params[key];
			}	
			
			urlVars.method 		= method;
			urlVars.session_key = _session_key;
			urlVars.app_id 		= _app_id;
			urlVars.sig 		= generate_signature( request_params );
			
			
			var request:URLRequest = new URLRequest();
			request.url 	= _rest_url;
			request.method 	= URLRequestMethod.POST;
			request.data 	= urlVars;
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat 	 = URLLoaderDataFormat.TEXT;			
			loader.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				var loader:URLLoader = URLLoader(e.target);	
				var data:Object = {};
				var ch:String = loader.data;
				if (ch.slice(0,1) == "{")
				{
					data = JSON.decode(loader.data);					
					options.onComplete(data);
				}
				else
				{
					data.method = method;
					options.onComplete(data);
				}
				
			});
			
			try {
			//	trace(request.url + '?' + unescape(urlVars.toString()));
				loader.load(request);
			}
			catch (error:Error) {
				options.onError(error);
			}
		}
		
		private function generate_signature(params: Object): String 
		{
			var vars:Array = [];
			
			var s:String = "";			
			s += _uid;
			
			for (var key:String in params) 
			{					
				var arg:* = params[key];
				if (arg == null)
					continue;
				vars.push(key + '=' + arg.toString());
			}
			
			vars.sort();
			
			s += vars.join('');
			s += _private_key;
			
			return MD5.hash(s);
		}	
	}
}