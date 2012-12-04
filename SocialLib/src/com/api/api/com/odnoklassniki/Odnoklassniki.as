package com.api.api.com.odnoklassniki 
{	
	import com.adobe.serialization.json.JSON;
	import com.api.api.com.odnoklassniki.core.OdnoklassnikiSession;
	import com.api.api.com.odnoklassniki.events.ApiServerEvent;
	import com.api.api.com.odnoklassniki.net.OdnoklassnikiRequest;
	
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author Igor Nemenonok
	 */
	public class Odnoklassniki extends EventDispatcher
	{
		protected static var _instance:Odnoklassniki;
		
		public var session:OdnoklassnikiSession;
		
		protected static var _can_initiate:Boolean = false; 
		
		protected var openRequests:Dictionary;
		
		public static var API_SERVER:String;
		
		public function Odnoklassniki() 
		{
			if (_can_initiate == false) {
				throw new Error('Odnoklassniki is an singleton! Call Odnoklassniki.getInstace() instead.');
			}else {
				openRequests = new Dictionary();
			}
		}
		
		/**
		 * 
		 * @param	base - reference to application container
		 * @param	secretKey - secret key of your application
		 */
		public static function initialize(fv:Object, secretKey:String):void 
		{
			var flash_vars:Object = fv;
			getInstance().session = new OdnoklassnikiSession(flash_vars.apiconnection);
			getInstance().session.sessionKey = flash_vars.session_key;
			getInstance().session.sessionSecretKey = flash_vars.session_secret_key;
			getInstance().session.uid = flash_vars.logged_user_id;
			getInstance().session.applicationKey = flash_vars.application_key;
			getInstance().session.secretKey = secretKey;
			API_SERVER = flash_vars.api_server;
		}
		
		protected static function getInstance():Odnoklassniki {
			if (_instance == null) {
				_can_initiate = true;
				_instance = new Odnoklassniki();
				_can_initiate = false;
			}
			return _instance;
		}
		
		public static function dispatchEvent(event:*):void 
		{
			getInstance().dispatchEvent(event);
		}
		
		public static function addEventListener(type:String, fn:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			getInstance().addEventListener(type, fn, useCapture, priority, useWeakReference);
		}
		
		public static function hasEventListener(type:String):Boolean {
			return getInstance().hasEventListener(type);
		}
		
		/**
		 * @param	method - name of the method in odnoklassniki API
		 * @param	params - array of parameters passed to method
		 */
		public static function call(method:String,
									params:Array = null):void {
			getInstance().send(method, params);
		}
		
		private function send(method:String, params:Array):void 
		{
			if (getInstance().session.is_connected)
			{
				getInstance().session.connection.send.apply(getInstance().session.connection, ["_proxy_" + getInstance().session.connectionName, method].concat(params));
			}
			else {
				dispatchEvent(new ApiServerEvent(ApiServerEvent.NOT_YET_CONNECTED));
			}
		}
		
		/**
		 * @param	method - Method from Odnoklassniki Rest API
		 * @param	callback - Callback function
		 * @param	params - parameters to send
		 * @param	requestMethod - request method GET/POST
		 */
		public static function callRestApi(method:String, 
										callback:Function, 
										params:Object = null, 
										format:String = 'JSON',
										requestMethod:String = "GET",
										url:String = null):void {
			getInstance().doCallRestApi(method, callback, params, format, requestMethod, url);
		}
		
		private function doCallRestApi(method:String, 
										callback:Function, 
										params:Object = null, 
										format:String = 'JSON',
										requestMethod:String = "GET",
										url:String = null):void {
			var req:OdnoklassnikiRequest = new OdnoklassnikiRequest(API_SERVER, requestMethod);
			req.call(method, params, handleRequestLoad, format, url);
			
			openRequests[req] = callback;
		}
		
		private function handleRequestLoad(rq:OdnoklassnikiRequest):void 
		{
			var resultCallback:Function = openRequests[rq];
			if (resultCallback === null) {
                delete openRequests[rq];
            }
			
			if (rq.success) {
				var data:Object = rq.data;
				resultCallback(data);
			}
			
			delete openRequests[rq];
			
		}
		
		/**
		 * 
		 * @param	data - parameters object
		 * @param	exception
		 * @param	format
		 * @return	MD5.hash of data object
		 */
		public static function getSignature(data:Object, exception:Boolean = false, format:String = "JSON"):Object {
			return getInstance().session.getSignature(data, exception, format);
		}

		/**
		 * Current session
		 */
		public static function get session():OdnoklassnikiSession {
			return getInstance().session;
		}
		
		
		// PUBLIC METHODS
		public static function showPermissions(... permissions ) : void
		{
			getInstance().send("showPermissions", [JSON.encode(permissions)]);
		}
		
		public static function showInvite(text : String = null, params : String = null) : void
		{
			getInstance().send("showInvite", [text, params]);
		}
		
		public static function showNotification(text : String, params : String = null) : void
		{
			getInstance().send("showNotification", [text, params]);
		}
		
		public static function showPayment(name : String, description : String, code : String, price : int = -1, options : String = null, attributes : String = null, currency: String = null, callback : String = 'false') : void
		{
			getInstance().send("showPayment", [name, description, code, price, options, attributes, currency, callback]);
		}
		
		public static function showConfirmation(method : String, userText : String, signature : String) : void
		{
			getInstance().send("showConfirmation", [method, userText, signature]);
		}
		
		public static function setWindowSize(width : int, height : int) : void
		{
			getInstance().send("setWindowSize", [width.toString(), height.toString()]);
		}
		
		private static function getFlashVars(base:DisplayObject):Object {
			return Object( LoaderInfo( base.loaderInfo ).parameters );
		}
		
		public static function getSendObject(d:Object):Object {
			var send_obj:Object = { };
			for (var s:String in d) {
				if (d[s])
					send_obj[s] = d[s];
			}
			return send_obj;
		}
		
	}

}