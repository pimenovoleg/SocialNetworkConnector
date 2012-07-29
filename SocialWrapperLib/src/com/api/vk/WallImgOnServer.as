package com.api.vk
{
	import com.adobe.images.PNGEncoder;
	import com.ng.utils.MultipartURLLoader;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	public class WallImgOnServer extends EventDispatcher
	{
		public static function loadImage(mc:MovieClip, server_url:String, callback:Function):void
		{		
			var bitmap_data:BitmapData = new BitmapData(mc.width,mc.height);
			bitmap_data.draw(mc);
			var byte_arr:ByteArray = PNGEncoder.encode(bitmap_data);
			
			var loader:MultipartURLLoader = new MultipartURLLoader();
			loader.addEventListener(Event.COMPLETE, function(event:Event):void 
			{
				var data:Object = JSON.parse(String(event.currentTarget.loader.data));				
				callback(data);
			});
			loader.addFile(byte_arr,"photo.png","photo");
			loader.load(server_url);
		}		
	}
}