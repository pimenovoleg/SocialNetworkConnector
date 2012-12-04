package com.api.mailru.rest{

	import com.demonsters.debugger.MonsterDebugger;
	import com.nextgame.utils.MD5;
	
	
	public class MyApi {
		private var parameters:Array;

		public var vid:String;
		public var app_id:Number;
		public var method:String;
		public var private_key:String;
		public var session_key:String;
		public var format:String;
		public var server_url:String;

		public function MyApi(vid: String, app_id: Number, method: String, private_key: String, 
							  session_key: String, format: String, server_url: String) {
			this.vid=vid;
			this.app_id=app_id;
			this.method=method;
			this.private_key=private_key;
			this.session_key=session_key;
			this.format=format;
			this.server_url=server_url;

			parameters = new Array();
			parameters.push(new Parameter('app_id', app_id.toString()));
			parameters.push(new Parameter('method', method));
			parameters.push(new Parameter('session_key', session_key));
			parameters.push(new Parameter('format', format));
		}

		public function addParameter(p_name: String, p_value: String):void {
			parameters.push(new Parameter(p_name, p_value));
		}

		public function toString():String {
			parameters.push(new Parameter('sig', getSig(parameters)));
			return server_url+parameters.join('&');
		}

		public function getQuery():String {
			return this.toString();
		}

		private function getSig(parameters: Array):String {
			parameters.sortOn("name");
			return MD5.encrypt(vid + joinToUsualString(parameters) + private_key);
		}

		private function joinToUsualString(parameters: Array):String {
			var i:int;
			var str:String='';
			for (i = 0; i < parameters.length; i++) {
				str+=parameters[i].toUsualString();
			}
			return str;
		}
	}
}