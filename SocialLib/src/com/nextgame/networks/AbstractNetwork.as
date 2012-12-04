package com.nextgame.networks
{
	import com.nextgame.data.FriendVO;
	import com.nextgame.data.SocialApiData;
	import com.nextgame.data.UserVO;
	import com.nextgame.data.WallVO;
	import com.nextgame.logging.LogType;
	import com.nextgame.logging.Logger;
	import com.nextgame.networks.enums.Token;
	import com.nextgame.utils.ObjectPool;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class AbstractNetwork extends EventDispatcher
	{	
		/**
		 *Id пользователя запустившего приложение 
		 */
		protected var _uid:String;
		/**
		 * имя социальной сети
		 */
		protected var _network:String;
		/**
		 * ID социальной сети
		 */
		protected var _networkID:int = 0;
		/**
		 *название запроса, который происходит в данный момент к социальной сети 
		 */
		protected var token:String;
		protected var _flashVars:Object;
		/**
		 *модель данных социальной сети 
		 */
		protected var model:SocialApiData = SocialApiData.getInstance();	
		
		/**
		 *первоначальный стек (пулл) поочередно выполняющихся запросов к социальной сети 
		 */
		private var pool:ObjectPool;
		
		protected var skipEventComplete : Boolean = false;
		
		/**
		 * 
		 * @param $fl - _flashVars социльной сети
		 * @param $api - сторонее апи социльной сети
		 * @param $onComplete - обработчик завершения запуска SocialAPI
		 * 
		 */
		
		public function AbstractNetwork( $fl:Object, $api:*, $onComplete:Function )
		{
			this._flashVars = $fl;
			this.model.socialApi = $api;			
			this.addEventListener(Event.COMPLETE, $onComplete);
			createModelInstance();
			createPool();
		}
		
		/**
		 *создание экземпляров классов Модели, которые 100% будут использоватся для инициализации SocialAPI 
		 * 
		 */
		private function createModelInstance():void
		{			
			model.wall = new WallVO();
			model.user = new UserVO();			
		}
	
		public function createPool():void
		{
			pool = new ObjectPool();
			pool.allocate(this);		
		}
		
		public function get flashvars():Object
		{
			return _flashVars;
		}
		
		public function get network():String
		{
			return _network;
		}
		
		public function get networkID():int
		{
			return _networkID;
		}
		
		public function get uid():String
		{
			return _uid;
		}
					
		public function standartPool():void
		{			
			pool.initialze('getUserProfile');
			pool.initialze('getFriendsUids');
			pool.initialze('getFriendsProfiles');
			pool.initialze('getFriendsUidsInApp');
			pool.initialze('getFriendsProfilesInApp');			
			pool.process();
		}
		
		public function standartMailPool():void
		{			
			pool.initialze('getUserProfile');
			pool.initialze('getAppHash');
			pool.initialze('getFriendsProfiles');
			pool.initialze('getFriendsProfilesInApp');			
			pool.process();
		}
		
		public function nextGamePool():void
		{
			pool.initialze('getUserProfile');
			pool.initialze('getFriendsUids');
			pool.initialze('getFriendsProfiles');
			pool.initialze('getFriendsProfilesInApp');
			pool.process();
		}
		
// --------- OVERRIDES METHODS ---------------------------------------------------------//		
		/**
		 *К данным методам, всегда идет вызов через super, чтобы отметить конкретный Token 
		 * 
		 */
		public function getUserProfile():void
		{
			token = Token.GET_USER_PROFILE;
		}
	
		public function getFriendsUids():void
		{
			token = Token.GET_FRIENDS_UIDS;			
		}
		
		public function getFriendsProfiles():void
		{
			token = Token.GET_FRIENDS_PROFILES;
			if (model.user.friends_uids == null)
			{
				Logger.log('У вас нет друзей!', LogType.ERROR);				
			}			
		}
		
		public function getFriendsUidsInApp():void
		{
			token = Token.GET_FRIENDS_UIDS_IN_APP;	
		}
		
		public function getFriendsProfilesInApp():void
		{
			token = Token.GET_FRIENDS_PROFILES_IN_APP;
			if (model.user.friendsInApp_uids == null)
			{
				Logger.log('У вас нет друзей в приложении!', LogType.ERROR);				
			}
		}
		
		public function getAppHash():void
		{
			token = Token.MR_HASH_READ;
		}
		
		/**
		 * @param ---VK---
		 * 
		 * @param ---MAIL---
		 * @param type - 'pay' or 'sms'
		 * 
		 * @param ---OD---
		 * @param type - name of payment
		 * @param messge  - description
		 */
		
		public function showPaymentBox($pay:uint,$type:String ='',$mes:String = 'nextGame'):void
		{
			
		}
		
		public function showInviteBox($text:String=null, $params:String=null):void
		{
			
		}
		
		
		/**
		 * @param ---VK---
		 * ( если  photo_ID = null, то нужен mc )
		 * @param wallUid : (V) ID стена на которую будет поститься
		 * @param mc : MovieClip для поста на стену
		 * @param message : (V)Текст сообщение в посте.
		 * @param post_id : строка передоваемая в приложение, после пререхода со стены.
		 * @param photo_id : ID фотографии, залитой на сервер Вконтакте
		 * 
		 * @param ---Mailru---
		 * @param title: заголовок записи, будет написан жирным шрифтом,
		 * @param text: основной текст вашей записи,
		 * @param img_url:  картинка, которая будет отображаться в записи ('http://exmaple.com/img.gif'),
		 * @param action_links: абсолютные URL'ы работают только для внешних сайтов
		 * для приложений href будет даписан в якорь ссылки на страницу приложения 
		 * array[{text: заголовок ссылки 1, 'href': http://example.com/test1},
		 * text: 'заголовок ссылки 2, 'href': http://example.com/test2}]
		 * 
		 * @param --OD---
		 * @param message: (V)Текст сообщение в посте.
		 * @param attachment : ссылка на картинку (exmpl : 	'{\"media\" : [{\"type\" : \"image\",\"src\" : \"'+dirName +'OD/'+ img+'\"}]}'	) 
		 * @param action_links : Параметры передоваемые в приложение по переходу с ленты (exmpl:	'[{\"text\" : \"'+Имя ссылки+'\", \"href\":\" +Параметры+\"}]'	 )
		 * 
		 */
		
		public function wall_postMessage($params:Object,$cbFunc:Function):void
		{
			token = Token.POST_TO_STREAM;
		}

		public function getWallpostServer($cbFunc:Function):void
		{
			$cbFunc('');
		}
		
	}
}