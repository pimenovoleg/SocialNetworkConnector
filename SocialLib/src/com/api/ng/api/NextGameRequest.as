package com.api.ng.api
{
	
	import com.api.ng.enum.NextGameMethod;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	
	public class NextGameRequest extends EventDispatcher
	{
		protected static var ngd: NextGameDelegate;
		
		public function NextGameRequest(private_key:String, flashVars:Object)
		{
			ngd = new NextGameDelegate(flashVars.uid, flashVars.app_id, private_key, flashVars.session_key, flashVars.api_server);
		}
		
		public static function call(method: String, params: Object, onComplete:Function):void 
		{
			var options: Object = new Object();
			options.params = params;
			options.onComplete = onComplete;			
			ngd.request(method, options);
		}
		
		public static function openDialog(service_id:String, coins:uint, name:String, description:String, extra:String):void
		{
			ExternalInterface.call(NextGameMethod.OPEN_DIALOG, service_id, coins, name, description, extra);
		}
		
		public static function openInviteDialog():void
		{
			ExternalInterface.call(NextGameMethod.OPEN_INVITE_DIALOG);
		}
		
		public static function wallPost(text:String):void
		{
			ExternalInterface.call(NextGameMethod.WAAL_POST, text);
		}
	}
}