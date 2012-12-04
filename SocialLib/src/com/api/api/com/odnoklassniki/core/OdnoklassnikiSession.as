package com.api.api.com.odnoklassniki.core 
{
	import com.adobe.crypto.MD5;
	import com.api.api.com.odnoklassniki.Odnoklassniki;
	import com.api.api.com.odnoklassniki.events.ApiCallbackEvent;
	import com.api.api.com.odnoklassniki.events.ApiServerEvent;
	
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.net.LocalConnection;
	import flash.utils.Timer;

	/**
	 * ...
	 * @author Igor Nemenonok
	 */
	public class OdnoklassnikiSession 
	{
		
		/**
		 * Current user's id
		 */
		public var uid:String;
		
		/**
		 * Current user's full information
		 */
		public var user:Object;
		
		/**
		 * Application key for the application
		 */
		public var applicationKey:String;
		
		/**
		 * Application's secret key
		 */
		public var secretKey:String;
		
		/**
		 * Current user's session key
		 */
		public var sessionKey:String;
		
		/**
		 * Current user's secret session key
		 */
		public var sessionSecretKey:String;
		
		
		//connection properties
		private var _is_connected:Boolean = false;
		private var _self_connected:Boolean = false;
		private var _connection_name:String;
		private var _connection : LocalConnection = new LocalConnection;
		private var _reconnect_timer : Timer = new Timer(200);
		
		/**
		 * Creates a new OdnoklassnikiSession
		 */
		public function OdnoklassnikiSession(con:String) {
			this._reconnect_timer.addEventListener(TimerEvent.TIMER, this.tryToConnect);
			
			this._connection.allowDomain("*");
			this._connection.addEventListener(StatusEvent.STATUS, this.handleOutStatus);
			this._connection.client = this;
			
			this._connection_name = con;
			tryToConnect();
		}
		
		/**
		 * Gets the status of the current connection
		 */
		public function get is_connected():Boolean {
			return _is_connected;
		}
		
		public function get connectionName():String {
			return this._connection_name;
		}
		
		public function get connection():LocalConnection {
			return this._connection;
		}
		
		private function tryToConnect(event : TimerEvent = null):void 
		{
			try{
				if (!_self_connected) {
					/*
					  If client connection, does not exists, try to create new one. 
					  If fails to create client connection, we assume that client connection with the same name already exists.
					  Probably this is an old connection from the previous session (possible with HTML applications)
					*/
					this._connection.connect("_api_" + this._connection_name);
					this._self_connected = true;
				}
			}catch (e:Error) {
				//Try to close existing client connection in previous session
				var cc2 : LocalConnection = new LocalConnection();
				cc2.addEventListener(StatusEvent.STATUS, this.handleOutStatusConcurrent, false, 0 , true);
				cc2.send("_api_" + this._connection_name, "closeConnection");
				//Start timer, which will retry creation of client connection
				this._reconnect_timer.start();
				return;
			}
			
			/**
			 * If client connection created succesfully, but not proxy not yet connected to this client, we will start timer to monitor, that succefull connection.
			 * 
			 */
			if (!this._is_connected) {
				if(event)
				{
					//if timer, that we assume that, proxy was connected to another client (previous session) and ask it to reconnect to this client instance
					this._reconnect_timer.reset();
					trace("Telling proxy to make reconnect...");
					var cc : LocalConnection = new LocalConnection();
					cc.addEventListener(StatusEvent.STATUS, this.handleOutStatusReconnect, false, 0 , true);
					cc.send("_proxy_" + this._connection_name, "makeReconnect");
					
				}
				else
				{
					//start timer on first iteration 
					this._reconnect_timer.start();
				}
			}
		}
		
		private function handleOutStatus(event : StatusEvent) : void
		{
			if (event.level != StatusEvent.STATUS)
			{
				Odnoklassniki.dispatchEvent(new ApiServerEvent(ApiServerEvent.CONNECTION_ERROR));
			}
		}
		
		private function handleOutStatusReconnect(event : StatusEvent) : void
		{
			if (event.level != StatusEvent.STATUS)
			{
				Odnoklassniki.dispatchEvent(new ApiServerEvent(ApiServerEvent.PROXY_NOT_RESPONDING));
			}
		}
		
		private function handleOutStatusConcurrent(event : StatusEvent) : void
		{
			if (event.level != StatusEvent.STATUS)
			{
				Odnoklassniki.dispatchEvent(new ApiServerEvent(ApiServerEvent.CONNECTION_ERROR));
			}
		}
		
		public function establishConnection() : void
		{
			this._reconnect_timer.reset();
			
			if (!this._is_connected)
			{
				this._is_connected = true;
				Odnoklassniki.dispatchEvent(new ApiServerEvent(ApiServerEvent.CONNECTED));
			}
		}
		
		public function apiCallBack(methodName : String, result : String, params : String) : void
		{
			Odnoklassniki.dispatchEvent(new ApiCallbackEvent(ApiCallbackEvent.CALL_BACK, false, false, methodName, result, params));
		}
		
		/**
		 * Closes current LocalConnection
		 */
		public function closeConnection() : void
		{
			this._connection.close();
		}
		
		/**
		 * @param	data - 
		 */
		public function getSignature(data:Object, exception:Boolean = false, format:String = "JSON"):Object
		{
			data["format"] = format;
			data["application_key"] = this.applicationKey;
			if (data['uid'] == undefined || exception)
				data["session_key"] = this.sessionKey;
			
			var sig : String = '';
			var keys : Array = [], key : String;
			
			for (key in data) { 
				keys.push(key); 
			}
			keys.sort();
			
			var i: int = 0, l : int = keys.length;
			for (i; i < l; i++)
			{
				sig += keys[i] + "=" + data[keys[i]];
			}
			sig += (data['uid'] != undefined && !exception) ? this.secretKey : this.sessionSecretKey;
			
			data["sig"] = MD5.hash(sig).toLowerCase();
			return data;
		}

	}

}