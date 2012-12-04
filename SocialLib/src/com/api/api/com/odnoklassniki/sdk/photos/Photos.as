package com.api.api.com.odnoklassniki.sdk.photos 
{

	import com.adobe.serialization.json.JSON;
	import com.api.api.com.odnoklassniki.Odnoklassniki;
	import com.api.api.com.odnoklassniki.sdk.errors.Errors;
	
	/**
	 * ...
	 * @author Igor Nemenonok
	 */
	public class Photos 
	{
		/**
		 * Returns base URL used for photo upload. Can return empty value if same server should be used, otherwise returns base part of URL, which must be used to call photos.upload
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+photos.getUploadUrl
		 * @param	uid - The user ID for the user whose status you want to change. Specify the uid when calling this method without a session key
		 * @param	aid - Album ID. If null, photo will be uploaded to the user personal photo album. If album ID is application, than photo will be uploaded to the application album of the specified user. 
		 * @param	callback
		 */
		public static function getUploadUrl(callback:Function, uid:String = "", aid:String = ""):void {
			Odnoklassniki.callRestApi("photos.getUploadUrl", callback, Odnoklassniki.getSendObject({ uid:uid, aid:aid }) );
		}
		
		/**
		 * Upload one or more photos, with ability to specify caption and geographic location for each photo
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+photos.upload
		 * @param	files - Images to upload (Bitmap / BitmapData / ByteArray)
		 * @param	url - Upload url.
		 * @param	uid	- The user ID for the user whose photo you want to upload. Specify the uid when calling this method without a session key. 
		 * @param	aid - Album ID. If null, photo will be uploaded to the user personal photo album. If album ID is application, than photo will be uploaded to the mobile photo album of the specified user (works only for mobile photo uploads, applications have to create album first).
		 * @param	photos - Array of Objects containing additional info about photo (caption, location)
		 * @param	callback
		 */
		public static function upload(files:Array, callback:Function, url:String = "", uid:String = "", aid:String = "", photos:Array = null):void {
			var send_obj:Object = { files:files };
			
			if (uid) send_obj.uid = uid;
			if (aid) send_obj.uid = aid;
			if (photos) send_obj.photos = JSON.encode(photos);
			
			url = (!url) ? "http://apimobile.odnoklassniki.ru/" : url;
			
			Odnoklassniki.callRestApi("photos.upload", callback, send_obj, 'JSON', "POST", url);
		}
		
		/**
		 * Creates photo album for specified user 
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+photos.createAlbum
		 * @param	title - The title for created photo album. 
		 * @param	type - The visibility of photo album. One of: (friends - The photo album will be visible for friends of user only; public - The photo album will be visible for all portal users)
		 * @param	description - The description for created photo album. 
		 * @param	callback
		 */
		public static function createAlbum(title:String, type:String, callback:Function, description:String = ""):void {
			if (!title || !type) {
				Errors.showError("Required fields: title, type");
			}
			Odnoklassniki.callRestApi("photos.createAlbum", callback, Odnoklassniki.getSendObject({ title:title, type:type, description:description}) );
		}
		
		/**
		 * Retrieves the list of photo albums for specified user 
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+photos.getAlbums
		 * @param	uid - The user ID of the viewer. Specify the uid when calling this method without a session key. 
		 * @param	fid - The user ID for the user whose photo albums you want to return. If null, current user's albums will be returned (From 08.09.2010)
		 * @param	pagingAnchor - This is anchor used for paging across user photo albums. Paging parameters allows to request photo albums before or after those albums that were retrieved before. The value of this parameter should be equal to value returned as result by previous call of this function.If this parameter is omitted then albums from beginning are returned. 
		 * @param	pagingDirection - Specified direction of paging. This parameter has effect if pagingAnchor is specified only, otherwise it is ignored. The value should be one of: forward or backward. 
		 * @param	count - The count of photo albums to return. The maximal count that can be requested is 100 albums. The default value is 10. 
		 * @param	detectTotalCount - Try to detect the total number of albums available. The default is false.
		 * @param	callback
		 */
		public static function getAlbums(callback:Function, uid:String = "", fid:String = "", pagingAnchor:String = "", pagingDirection:String = "", count:int = 0, detectTotalCount:Boolean = false):void {
			Odnoklassniki.callRestApi("photos.getAlbums", callback, Odnoklassniki.getSendObject({ uid:uid, fid:fid, pagingAnchor:pagingAnchor, pagingDirection:pagingDirection, count:count, detectTotalCount:detectTotalCount}) );
		}
		
		/**
		 * Retrieves the list of all user's photos evaluations.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+photos.getPhotoMarks
		 */
		public static function getPhotoMarks(callback:Function, pagingAnchor:String = "", pagingDirection:String = "", count:int = 0, detectTotalCount:Boolean = false):void {
			Odnoklassniki.callRestApi("photos.getPhotoMarks", callback, Odnoklassniki.getSendObject({ pagingAnchor:pagingAnchor, pagingDirection:pagingDirection, count:count, detectTotalCount:detectTotalCount}) );
		}
		
		/**
		 * Retrieves the list of personal photos for specified user.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+photos.getUserPhotos
		 */
		public static function getUserPhotos(callback:Function, uid:String = "", fid:String = "", pagingAnchor:String = "", pagingDirection:String = "", count:int = 0, detectTotalCount:Boolean = false):void {
			Odnoklassniki.callRestApi("photos.getUserPhotos", callback, { uid:uid, fid:fid, pagingAnchor:pagingAnchor, pagingDirection:pagingDirection, count:count, detectTotalCount:detectTotalCount} );
		}
		
		/**
		 * Retrieves the list of album photos for specified album.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+photos.getUserAlbumPhotos
		 * @param	aid - The ID for the album whose photo you want to return.
		 * @param	uid - The user ID for the user whose photo albums you want to return. If null, current user's albums will be returned (From 08.09.2010)
		 * @param	pagingAnchor - This is anchor used for paging across user photo albums. Paging parameters allows to request photo albums before or after those albums that were retrieved before. The value of this parameter should be equal to value returned as result by previous call of this function.If this parameter is omitted then albums from beginning are returned. 
		 * @param	pagingDirection - Specified direction of paging. This parameter has effect if pagingAnchor is specified only, otherwise it is ignored. The value should be one of: forward or backward. 
		 * @param	count - The count of photo albums to return. The maximal count that can be requested is 100 albums. The default value is 10. 
		 * @param	detectTotalCount - Try to detect the total number of albums available. The default is false.
		 * @param	callback
		 */
		public static function getUserAlbumPhotos(aid:String, callback:Function, uid:String = "", pagingAnchor:String = "", pagingDirection:String = "", count:int = 0, detectTotalCount:Boolean = false):void {
			Odnoklassniki.callRestApi("photos.getUserAlbumPhotos", callback, Odnoklassniki.getSendObject({aid:aid, uid:uid, pagingAnchor:pagingAnchor, pagingDirection:pagingDirection, count:count, detectTotalCount:detectTotalCount}) );
		}
	}

}