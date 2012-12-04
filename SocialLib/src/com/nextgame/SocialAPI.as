package com.nextgame
{
	import com.nextgame.data.SocialApiData;
	import com.nextgame.networks.AbstractNetwork;
	import com.nextgame.networks.MAILNetwork;
	import com.nextgame.networks.NGNetwork;
	import com.nextgame.networks.ODNetwork;
	import com.nextgame.networks.VKNetwork;
	import com.nextgame.networks.enums.NetworkAlias;
	import com.nextgame.utils.FlashVarsUtil;
	
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class SocialAPI extends EventDispatcher
	{		
		/**
		 * параметры flashvars
		 */
		protected var flashVars:Object;
		/**
		 *доступ к методам конкретной социальной сети 
		 */
		protected var apiSocial:AbstractNetwork;
		/**
		 * секретный, клиентский ключ
		 */
		protected var key:String;
		/**
		 * обработчик завершения инициализации SocialAPI
		 */
		protected var completeCall:Function;
		/**
		 *lock для блокировки старта локально/ на сайте 
		 */
		private var lockLocal:Boolean;
		
		/**
		 * 
		 * @param $loader - для обработки flashvars приложения
		 * @param $completeCall - обработчик завершения инициализации SocialAPI
		 * @param $key - секретный, клиентский ключ
		 * 
		 */
		public function SocialAPI($loader:LoaderInfo, $completeCall:Function, $key:String=null)
		{						
			this.flashVars    = $loader.parameters;			
			this.key	      = $key;
			this.addEventListener(Event.COMPLETE, $completeCall);
			
			if (FlashVarsUtil.getLength(flashVars) == 0)
				lockLocal = true;
			else
				start();			
		}
		
		public function setKey($key:String):void
		{
			this.key = $key;
		}
		
		private function start():void
		{		
			var str:String = FlashVarsUtil.selectSocial(flashVars);
			
			trace('SocialAPI network - ' + str);
			network = str;
		}
		
		private function set network($net:String):void
		{			
			switch($net)
			{
				case NetworkAlias.VK:
				{
					apiSocial = new VKNetwork(flashVars, onComplete);
					break;
				}
				
				case NetworkAlias.OD:
				{
					apiSocial = new ODNetwork(flashVars, onComplete);
					break;
				}
					
				case NetworkAlias.NG:
				{
					apiSocial = new NGNetwork(flashVars, onComplete, key);
					break;
				}
				
				case NetworkAlias.MAIL:
				{
					apiSocial = new MAILNetwork(flashVars, onComplete, key);
					break;
				}
			}								
		}
		
		private function onComplete(event:Event):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 
		 * @param $fvars - локальный запуск flashvars
		 * Если вы забыли закомментировать данный сеттер в коде приложения, переменная lockLocal заблокирует 
		 * повторную инициализацию SocialAPI
		 * 
		 */
		public function set localFlashVars($fvars:Object):void
		{
			if (lockLocal)
			{				
				flashVars = $fvars;
				if (typeof($fvars) == 'string')
					flashVars = FlashVarsUtil.parseString($fvars as String);
				start();
			}
		}		

	}
}