package com.api.vk
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import com.adobe.serialization.json.JSON;
	import com.nextgame.utils.MultipartData;
	import com.nextgame.utils.MultipartURLLoader;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
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
				var data:Object = JSON.decode(String(event.currentTarget.loader.data));				
				callback(data);
			});
			loader.addFile(byte_arr,"photo.png","photo", "multipart/form-data; boundary=" + MultipartData.BOUNDARY);
			loader.load(server_url);
		}
		
	}
}