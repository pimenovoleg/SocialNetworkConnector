package com.api.nextgame 
{
	import com.api.nextgame.apis.RestAPI;
	import com.api.nextgame.controller.NGCaller;
	import com.api.nextgame.interfaces.ICall;
	import com.api.nextgame.interfaces.INextGameApi;
	import com.nextgame.utils.FlashVarsUtil;
	
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;

	/**
	 * ...
	 * @author NextGame
	 */
	public class NextGameApi
	{				
		protected var private_key:String;		
		protected var loaderInfo:LoaderInfo;		
		protected var apiNG:INextGameApi;
		public var flashVars:Object;
		protected var api:String;
		public var call:ICall;
		/**
		 *lock для блокировки старта локально/ на сайте 
		 */
		protected var lockLocal:Boolean;
		/**
		 * 
		 * @param private_key - клиентский ключ приложения
		 * @param loaderInfo  - параметры flashvars
		 * @param format	  - формат результата запроса, по умолчанию JSON
		 * @param apiType	  - используемый api для запросов, по умолчанию REST
		 * 
		 */
		public function NextGameApi(private_key:String, loaderInfo:LoaderInfo=null)
		{
			this.private_key = private_key;			
			this.loaderInfo  = loaderInfo;
			this.flashVars	 = loaderInfo != null?loaderInfo.parameters:{};
			this.api 		 = api;
			
			if (FlashVarsUtil.getLength(flashVars) == 0)
				lockLocal = true;								
			else	
				init();			
		}
		
		public function set debug($fvars:String):void
		{	
			if (FlashVarsUtil.getLength(flashVars) == 0)
				flashVars = FlashVarsUtil.parseString($fvars);
			init();
		}
		
		public function init():void
		{
			
			apiNG = new RestAPI(flashVars.uid, flashVars.app_id, private_key, flashVars.session_key, flashVars.api_server);
			
			call = new NGCaller(apiNG);
		}
		
	}

}