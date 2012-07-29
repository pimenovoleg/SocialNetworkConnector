package com.ng
{
	import com.ng.data.SocialApiData;
	import com.ng.interfaces.ISocialAPI;
	import com.ng.networks.ODNetwork;
	import com.ng.networks.VKNetwork;
	import com.ng.networks.enums.NetworkName;
	import com.ng.utils.FlashVarsUtil;
	
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class SocialAPI extends EventDispatcher
	{		
		protected var flashVars:Object;
		protected var apiSocial:ISocialAPI;
		protected var display:DisplayObject;
		protected var model:SocialApiData = SocialApiData.getInstance();		
		private var lockLocal:Boolean;
		
		public function SocialAPI($loader:LoaderInfo)
		{						
			this.flashVars = $loader.parameters;
			this.display   = $loader.content;
			if (FlashVarsUtil.getLength(flashVars) > 0)			
				lockLocal = true;			
			
		}
		
		public function start():void
		{
			network = FlashVarsUtil.selectSocial(flashVars);
		}
		
		private function set network($net:String):void
		{			
			switch($net)
			{
				case NetworkName.VK:
				{
					apiSocial = new VKNetwork(flashVars);
					break;
				}
				
				case NetworkName.OD:
				{
					apiSocial = new ODNetwork(flashVars);
					break;
				}
			}		
			model.socialApi = apiSocial;
			apiSocial.addEventListener(Event.COMPLETE, onComplete);
			apiSocial.start();
		}
		
		private function onComplete(event:Event):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function set localFlashVars($fvars:String):void
		{
			if (!lockLocal)
			{
				this.flashVars = FlashVarsUtil.parseString($fvars);				
			}
		}		

	}
}