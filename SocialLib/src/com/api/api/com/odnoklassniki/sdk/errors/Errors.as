package com.api.api.com.odnoklassniki.sdk.errors 
{
	/**
	 * ...
	 * @author Igor Nemenonok
	 */
	public class Errors 
	{
		
		public static function showError(s:String):void 
		{
			throw new Error(s);
		}
		
	}

}