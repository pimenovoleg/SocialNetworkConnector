package com.api.od
{
	import com.ng.utils.MD5;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class ODApi
	{
		private var application_key:String;
		private var session_key:String;
		private var session_secret_key:String;
		private var api_server:String;
		protected var loader:URLLoader;
		protected var completeCallback:Function;
		protected var failCallback:Function;
		
		public function ODApi($flashVars:Object)
		{
			this.application_key 	= $flashVars.application_key;
			this.session_key 	 	= $flashVars.session_key;
			this.session_secret_key = $flashVars.session_secret_key;
			this.api_server			= $flashVars.api_server;
		}
		
		private function signature(params:Object):String 
		{
			var keys:Array = new Array();
			for (var k:String in params)
				keys.push(k);
			keys.sort();
			
			var sig:String = "";                        
			for (var i:int = 0; i < keys.length; i++)
				sig = sig + keys[i] + "=" + params[keys[i]];
			
			sig = sig + this.session_secret_key;
			
			return MD5.encrypt(sig);
		}
		
		private function addLoader():void
		{
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onDataComplete);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		}
		
		private function removeLoader():void
		{
			if (loader == null) return;
			
			loader.removeEventListener(Event.COMPLETE, onDataComplete);
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		}
		
		private function createConstatsArg($params:Object):void
		{
			$params.format = "JSON";
			$params.application_key = application_key; 
			$params.session_key = session_key; 
			$params.sig = signature($params); 
		}
		
		public function sendRequest($params:Object, $completeCallback:Function, $failCallback:Function = null):void
		{
			addLoader();
			createConstatsArg($params);
			
			this.completeCallback 	= $completeCallback;
			this.failCallback 		= $failCallback;
			
			var request:URLRequest = new URLRequest(this.api_server + "fb.do?");
			request.method = URLRequestMethod.GET;
			request.data = new URLVariables();
			for (var k:String in $params)
				request.data[k] = $params[k];
			
			loader.load(request);
		}
		
		private function onError(event:ErrorEvent):void
		{
			
		}
		
		private function onDataComplete(event:Event):void
		{
			var str:String = event.currentTarget.data;
			var decode:Object = JSON.parse(str);
			completeCallback(decode);
		}
		
		private function onHTTPStatus(event:HTTPStatusEvent):void
		{
			
		}
		
	}
}