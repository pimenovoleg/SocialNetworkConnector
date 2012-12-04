package com.nextgame.parsers
{
	import com.api.mailru.js.MailruAnswers;
	import com.api.od.ODAnswers;
	import com.api.vk.events.CustomEvent;
	
	public class ParseNetAnswer
	{
		public static const WALL_POSTED : String = 'Posted on the wall';
		public static const WALL_NON_POSTED : String = 'Dont posted on the wall';
		public static const WALL_ERROR : String = 'Error then posting on the wall';
		public static const WALL_WAIT : String = 'need to wait (still working)';
	
		public static function wallAnswer ($ans:*):String
		{
			var stringAnser : String;
			if ($ans.data && $ans.data.status) // mail.ru (type  = 'common.streamPublish');
				stringAnser = $ans.data.status;
			else if ($ans is CustomEvent) // vk
				stringAnser = $ans.type;
			else if ($ans.result) // OD
				stringAnser = $ans.result;
			
			
			switch (stringAnser)
			{
				case ODAnswers.STREAM_PUBLISHED:
				case CustomEvent.WALL_SAVE:
				case MailruAnswers.STREAM_PUBLISHED:	
					return WALL_POSTED;
					break;
				case CustomEvent.WALL_CANCEL:
				case MailruAnswers.STREAM_NON_PUBLISHED:
					return WALL_NON_POSTED;
					break;
				case MailruAnswers.STREAM_FAIL:
				case MailruAnswers.STREAM_AUTH_ERROR:
					return WALL_ERROR;
					break;
				case MailruAnswers.STREAM_OPEN:
					return WALL_WAIT;
					break;
				default:
					return WALL_WAIT;
			}
			
			return WALL_ERROR;
		}
		
	}
}