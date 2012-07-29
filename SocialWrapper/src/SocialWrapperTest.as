package
{
	import com.ng.SocialAPI;
	import com.ng.data.SocialApiData;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	public class SocialWrapperTest extends Sprite
	{
		private var model:SocialApiData = SocialApiData.getInstance();
		public function SocialWrapperTest()
		{
			var sw:SocialAPI = new SocialAPI(loaderInfo);
			sw.addEventListener(Event.COMPLETE, onComplete);
			//* FOR DEBBUG you can put flashVars :)					
			sw.localFlashVars = '';
			sw.start();
		}
		
		private function onComplete(event:Event):void
		{
			trace(' Loading Social APP - COMPLETE !');
		//	setTimeout(wall, 2000);					
		}
		
		
		/**
		 * Post on own wall 
		 * 
		 */
		private function wall():void
		{
			var mm:MovieClip = new mc() as MovieClip;			
			//model.socialApi.wall_postMessage(model.user.uid, mm, 'Хочу еще и еще !');
			
		}
		
	}
}