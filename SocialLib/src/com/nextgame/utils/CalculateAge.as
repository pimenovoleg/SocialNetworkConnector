package com.nextgame.utils
{
	public class CalculateAge
	{		
		public static function dateStringToObject(dateString:String):Date 
		{
			if (!dateString)
				return null;
			
			if (dateString == "")
				return null;
			
			var date_ar:Array;
			if (dateString.search('-') != -1)
				date_ar = dateString.split("-");
			if (dateString.search('.') != -1)
			{
				date_ar = dateString.split(".");
				return new Date(date_ar[2],date_ar[1] - 1,date_ar[0]);
			}
			
			return new Date(date_ar[0],date_ar[1] - 1,date_ar[2]);
		}

		public static function getDate(date:Date):String
		{
			if (date == null)
				return '';
			
			var currentMonth:Number = date.getMonth();
			var currentDay:Number = date.getDate();
			var currentYear:Number = date.getFullYear();
			
			var str:String = currentDay.toString() + " - " + currentMonth.toString() + ' - ' + currentYear;
			
			return str;
		}
		
		public static function calculateAge(birthdate:Date):Number 
		{
			if (birthdate == null)
				return 0;
			
			var dtNow:Date = new Date();
			var currentMonth:Number = dtNow.getMonth();
			var currentDay:Number = dtNow.getDay();
			var currentYear:Number = dtNow.getFullYear();
			
			var bdMonth:Number = birthdate.getMonth();
			var bdDay:Number = birthdate.getDay();
			var bdYear:Number = birthdate.getFullYear();
			
			var years:Number = dtNow.getFullYear() - birthdate.getFullYear();
			
			if (currentMonth < bdMonth || (currentMonth == bdMonth && currentDay < bdDay)) {
				years--;
			}
			return years;
		}

	}
}