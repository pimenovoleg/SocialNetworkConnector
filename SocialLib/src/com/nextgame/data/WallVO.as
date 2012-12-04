package com.nextgame.data
{
	import flash.display.MovieClip;

	public class WallVO
	{
		public var wall_uid:String;
		public var mc:*;
		public var vk_upload_url:String;
		public var message:String; 
		public var post_id:String; 
		public var photo_id:String;
		
		public var photo_url:String;
			
		public var server:String;
		public var photo:String;
		public var hash:String
		
		public var resig :String;
		
		public var cbFunc:Function;
		
		public function WallVO()
		{
		}
	}
}