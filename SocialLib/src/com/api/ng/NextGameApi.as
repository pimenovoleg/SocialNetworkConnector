package com.api.ng
{
	
	import com.api.ng.api.NextGameRequest;
	import com.api.ng.utils.FlashVarsUtil;
	
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class NextGameApi extends EventDispatcher
	{
		protected var flashVars:Object;		
		protected var key:String;
		protected var connection:NextGameRequest;
		
		private var isLocal:Boolean;
		
		/**
		 * 
		 * @param $key - клиент-ключ приложения
		 * @param $flashvars - данные передаваемые во flashvars приложения
		 * 
		 */
		public function NextGameApi($key:String, $loader:LoaderInfo)
		{
			this.key 	     = $key;			
			this.flashVars	 = $loader != null?$loader.parameters:{};
			
			if (FlashVarsUtil.getLength(flashVars) == 0)
			{
				trace('Local');
				isLocal = true;
			}
			else
			{
				trace('on site');
				init();
			}
		}
		
		public function set debug($flashvars:String):void
		{
			if (isLocal)
			{
				flashVars = FlashVarsUtil.parseString($flashvars);
				init();
			}
		}
		
		public function set debugObject($flashvars:Object):void
		{
			if (isLocal)
			{
				flashVars = $flashvars;
				init();
			}
		}
		
		private function init():void
		{
			connection = new NextGameRequest(key, flashVars);
		}
	}
}