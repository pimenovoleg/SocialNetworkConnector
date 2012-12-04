package com.api.nextgame.utils 
{
	import com.adobe.serialization.json.JSON;
	import com.api.nextgame.data.FriendData;
	import com.api.nextgame.data.UserData;
	import com.api.nextgame.enum.Request;
	
	
	/**
	 * ...
	 * @author NextGame
	 */
	public class JSONParser 
	{
		private var ngError:NGError;
		private var decodedData:*;
		
		public function JSONParser() {}
		
		public function validationResult(data:String):NGError
		{
			ngError = new NGError();
			decodedData = null;
			decodedData = JSON.decode(data);
			
			if (decodedData.result)
				ngError.error = null;
			else
			{
				ngError.error = new Error();				
				ngError.reason = decodedData.errdescr;
				ngError.type = decodedData.errno;
			}				
			return ngError;
		}		
		
		public function parse():*
		{
			var ngResult:*;
			
			switch(decodedData.method)
			{
				case Request.GET_INFO:
				{
					ngResult = parseUsersGetInfo(decodedData.data, false);
					break;
				}
				
				case Request.GET_FRIENDS_PROFILES:
				{
					if (decodedData.data is Array)
						ngResult = decodedData.data;
					else
						ngResult = parseUsersGetInfo(decodedData.data, true);
					break;
				}
				
				case Request.GET_BALANCE:
				{
					ngResult = decodedData.data.balance;
					break;
				}
			}
			
			return ngResult;
		}
		
		private function parseUsersGetInfo(data:*, friends:Boolean):Array
		{
			var res:Array = [];
			for (var key:String in data)			
			{
				var info:*; 
				if (friends)
					info = new FriendData();
				else
					info = new UserData(); 
				
				info.avatar_url = data[key].avatar_url;
				info.birthday = data[key].birthday;
				info.city = data[key].city;
				info.country = data[key].country;
				info.first_name = data[key].first_name;
				info.last_name = data[key].last_name;
				info.uid = data[key].id;
				info.name = data[key].name;
				info.nick_name = data[key].nick_name;
				info.sex = data[key].sex;
				
				res.push(info);
			}
			
				
			return res;
		}
		
	}

}