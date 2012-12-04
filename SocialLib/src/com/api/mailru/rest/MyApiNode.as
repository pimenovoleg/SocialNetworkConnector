package com.api.mailru.rest
{
	import com.adobe.serialization.json.JSON;
	import com.api.nextgame.events.NextGameEvent;
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class MyApiNode extends EventDispatcher
	{
		public var vid:String;
		public var app_id:Number;
		public var private_key:String;
		public var session_key:String;
		public var format:String;
		public var server_url:String;
		
		private var completeHandler:Function;
		
		private var url_loader:URLLoader;
		private var url_request:URLRequest;
		
		public function MyApiNode(vid: String,
								  app_id: Number,
								  private_key: String, 
								  session_key: String,
								  callbackComplete:Function,
								  format: String = 'JSON',
								  server_url: String = 'http://www.appsmail.ru/platform/api?')
		{
			this.vid=vid;
			this.app_id=app_id;
			this.private_key=private_key;
			this.session_key=session_key;
			this.format=format;
			this.server_url=server_url;
			this.completeHandler = callbackComplete;			
		}
		
		private function request(query:String):void
		{
			url_request = new URLRequest(query);
			url_loader  = new URLLoader;
			url_loader.addEventListener(Event.COMPLETE, completeData);
			url_loader.load(url_request);
			MonsterDebugger.trace(this,query,'MyApi','request');
		}
		
		private function completeData(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var data: Object = JSON.decode(loader.data);
			this.completeHandler(data);
			MonsterDebugger.trace(this,data,'MyApi','completeData');
		}
		
		/* Friends */
		public function friendsGet(ext: Number = -1):void 
		{
			var api: MyApi = new MyApi(vid,
									   app_id,
									   'friends.get',
									   private_key,
									   session_key,
									   format,
									   server_url);
			if (ext!=-1) {
				api.addParameter('ext', ext.toString());
			}
			request(api.getQuery());
		}

		public function friendsGetAppUsers(ext: Number = -1):void 
		{
			var api: MyApi = new MyApi(vid,
									   app_id,
									   'friends.getAppUsers',
									   private_key,
									   session_key,
									   format,
									   server_url);
			if (ext!=-1) {
				api.addParameter('ext', ext.toString());
			}
			request(api.getQuery());
		}

		/* Users */
		public function isAppUser(uid: Number = -1):void 
		{
			var api: MyApi = new MyApi(vid,
									   app_id,
									   'users.isAppUser',
									   private_key,
									   session_key,
									   format,
									   server_url);
			if (uid!=-1) {
				api.addParameter('uid', uid.toString());
			}
			request(api.getQuery());
		}


		public function usersGetInfo(uids: Array):void 
		{
			var api: MyApi = new MyApi(vid,
									   app_id,
									   'users.getInfo',
									   private_key,
									   session_key,
									   format,
									   server_url);
			api.addParameter('uids', uids.join(','));
			request(api.getQuery());		
		}

		public function usersHasAppPermission(ext_perm: String):void 
		{
			var api: MyApi = new MyApi(vid,
									   app_id,
									   'users.hasAppPermission',
									   private_key,
									   session_key,
									   format,
									   server_url);
			api.addParameter('ext_perm', ext_perm);			
		}
		
		/* Payments */
		public function paymentsOpenDialog(window_id: String, service_id: Number, service_name: String, sms_price: Number = -1, other_price: Number = -1):String {
			var api: MyApi = new MyApi(vid,
									   app_id,
									   'payments.openDialog',
									   private_key,
									   session_key,
									   format,
									   server_url);
			api.addParameter('window_id', window_id);
			api.addParameter('service_id', service_id.toString());
			api.addParameter('service_name', service_name);
			if (sms_price!=-1) {
				api.addParameter('sms_price', sms_price.toString());
			}
			if (other_price!=-1) {
				api.addParameter('other_price', other_price.toString());
			}
			return api.getQuery();
		}		
		
		/* Stream */
		public function streamPublish(text: String, post: String, img: Number = -1):String {
			var api: MyApi = new MyApi(vid,
									   app_id,
									   'stream.publish',
									   private_key,
									   session_key,
									   format,
									   server_url);
			api.addParameter('text', text);
			api.addParameter('post', post);
			if (img!=-1) {
				api.addParameter('img', img.toString());
			}
			return api.getQuery();
		}				
		
		/* Photos */
		public function photosGetAlbums(aids: String = null):String {
			var api: MyApi = new MyApi(vid,
									   app_id,
									   'photos.getAlbums',
									   private_key,
									   session_key,
									   format,
									   server_url);
			if (aids) {
				api.addParameter('aids', aids);
			}
			return api.getQuery();
		}				

		public function photosGet(aid: String = null, pids: String = null):String {
			var api: MyApi = new MyApi(vid,
									   app_id,
									   'photos.get',
									   private_key,
									   session_key,
									   format,
									   server_url);
			api.addParameter('aid', aid);
			if (pids) {
				api.addParameter('pids', pids);
			}
			return api.getQuery();
		}		
		
		/* Audios */
		public function audiosGet(mids: String = null):String {
			var api: MyApi = new MyApi(vid,
									   app_id,
									   'audios.get',
									   private_key,
									   session_key,
									   format,
									   server_url);
			if (mids) {
				api.addParameter('mids', mids);
			}
			return api.getQuery();
		}						
		
		public function audiosLinkAudio(mid: String):String {
			var api: MyApi = new MyApi(vid,
									   app_id,
									   'audios.linkAudio',
									   private_key,
									   session_key,
									   format,
									   server_url);
			api.addParameter('mid', mid.toString());
			return api.getQuery();
		}				
		
		
	}
}