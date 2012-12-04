package com.api.api.com.odnoklassniki.net 
{
	
	import com.adobe.images.PNGEncoder;
	import com.adobe.serialization.json.JSON;
	import com.api.api.com.odnoklassniki.Odnoklassniki;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Igor Nemenonok
	 */
	public class OdnoklassnikiRequest
	{
		
		protected var urlLoader:URLLoader;
		protected var urlRequest:URLRequest;
		protected var _data:Object;
		protected var _serverUrl:String;
		protected var _requestMethod:String;
		protected var _callback:Function;
		protected var _success:Boolean = false;
		protected var _format:String = "XML";
		protected var _method:String;
		
		public function OdnoklassnikiRequest(url:String, requestMethod:String = 'GET', callback:Function = null){
			_serverUrl = url;
			_requestMethod = requestMethod;
			_callback = callback;
		}
		
		/**
		 * @param	method 		- Rest API method
		 * @param	data 		- data object
		 * @param	callback 	- callback function
		 * @param	format 		- JSON/XML
		 * @param	url			- request url
		 */
		public function call(method:String, data:*= null, callback:Function = null, format:String = "JSON", url:String = null):void {
			if (callback != null) {
				_callback = callback;
			}
			_method = method;
			_format = format;
			
			//If user wants to upload photos
			if (method == "photos.upload") {
				uploadPhotos(data, callback, format, url);
				return;
			}
			
			if (!data) data = { };
			
			data['method'] = method;
			
			if(!data.sig){
				data = Odnoklassniki.getSignature(data, false, format);
			}
			
			var req_url:String = (url) ? url+"fb.do" : _serverUrl + "fb.do";
			
			urlRequest = new URLRequest(req_url);
			urlRequest.method = _requestMethod;
			urlRequest.data = getUrlVars(data);
			
			load();
        }
		
		/**
		 * Upload photos to server
		 * @param	data 		- data object
		 * @param	callback 	- callback function
		 * @param	format 		- JSON/XML
		 * @param	url			- request url
		 */
		public function uploadPhotos(data:*, callback:Function = null, format:String = "JSON", url:String = null):void {
			if (!data) data = { };
			
			data['method'] = "photos.upload";
			
			var req_url:String = (url) ? url + "fb.do" : _serverUrl + "fb.do";
			
			//Check to see if there is a file we can upload.
			var fileData:Array = [];
			if(data.files){
				for (var i:int = 0; i < data.files.length; i++) {
					if (isValueFile(data.files[i])) {
						fileData.push(data.files[i]);
					}
				}
				delete data.files;
			}
			
			//getting signature for request
			data = Odnoklassniki.getSignature(data, false, format);
			req_url += getUrlParams(data);
			
			urlRequest = new URLRequest(req_url);
			
			//There is no files, so just send it off.
			if (fileData.length==0) {
				urlRequest.data = getUrlVars(data);
                load();
                return;
			}
			
			//There is fileData attached here, need to format it correctly,
            //then send it to Facebook.
            var post:PostRequest = new PostRequest();

			for (i= 0; i < fileData.length; i++) {
				var file_name:String = "file_" + (i + 1);
				//If we have a Bitmap, extract its BitmapData for upload.
				if (fileData[i] is Bitmap) {
					fileData[i] = (fileData[i] as Bitmap).bitmapData;
				}

				if (fileData[i] is ByteArray) {
					//If we have a ByteArray, upload as is.
					post.writeFileData(file_name, fileData[i] as ByteArray, 'image/jpeg');

				} else if (fileData[i] is BitmapData) {
					//If we have a BitmapData, create a ByteArray, then upload.
					var ba:ByteArray = PNGEncoder.encode(fileData[i] as BitmapData);
					post.writeFileData(file_name, ba, 'image/jpeg');
				}
				fileData[i] = null;
			}
			fileData = null;
			
			post.close();
			
			urlRequest.method = URLRequestMethod.POST;
            urlRequest.data = post.getPostData();
			
			urlRequest.requestHeaders.push(new URLRequestHeader('Content-Type', 'multipart/form-data; boundary=' + post.boundary));
			
            load();
		}
		
		private function getUrlParams(data:Object):String
		{
			var s:String = "?";
			for (var k:String in data) {
				if(k!="files")
					s += k + "=" + data[k] + "&";
			}
			return s;
		}
		
		protected function isValueFile(value:Object):Boolean {
            return (value is Bitmap || value is BitmapData || value is ByteArray);
        }
		
		private function getUrlVars(data:Object):URLVariables 
		{
			var urlVars:URLVariables = new URLVariables();
            if (data == null) {
                return urlVars;
            }

            for (var s:String in data) {
                urlVars[s] = data[s];
            }

            return urlVars;
		}
		
		private function load():void 
		{
			urlLoader = new URLLoader();
            urlLoader.addEventListener(Event.COMPLETE, onComplete, false, 0, false);

            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);

            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
			
			urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);

            urlLoader.load(urlRequest);
		}
		
		private function onComplete(e:Event):void 
		{
			if(_format == "JSON"){
				_data = JSON.decode(urlLoader.data);
				try {
					_data.method = _method;
				}catch(e:Error){}
			}else{
				_data = urlLoader.data;
			}
			_success = true;
			complete();
		}
		
		private function complete():void 
		{
			_callback(this);
			close();
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			_success = false;
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void 
		{
			if (_callback!=null) {
				_callback( { error:"security_error" } );
			}
		}
		
		private function onProgress(e:ProgressEvent):void 
		{
			
		}
		
		/**
		 * Closes the connection and removing all listeners
		 */
		private function close():void 
		{
			if (urlLoader != null) {
                urlLoader.removeEventListener(Event.COMPLETE, onComplete);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				urlLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);

                try {
                    urlLoader.close();
                } catch (e:*) { }

                urlLoader = null;
            }
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function get success():Boolean {
			return _success;
		}
		
	}

}