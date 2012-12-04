package com.api.api.com.odnoklassniki.sdk.widget 
{
	import com.api.api.com.odnoklassniki.Odnoklassniki;
	/**
	 * ...
	 * @author Igor Nemenonok
	 */
	public class Widget 
	{
		
		/**
		 * Method returns 1 or more UI widgets, which can be embedded into your web application. 
		 * See Odnoklassniki widgets (http://dev.odnoklassniki.ru/wiki/display/ok/Odnoklassniki+widgets) for the full list of available widgets.
		 * http://dev.odnoklassniki.ru/wiki/display/ok/REST+API+-+widget.getWidgets
		 * @param	wids - The list of widgets IDs to return 
		 * @param	callback
		 */
		public static function getWidgets(wids:Array, callback:Function):void 
		{
			Odnoklassniki.callRestApi("widget.getWidgets", callback, { wids:wids.join(",")} );
		}
		
		/**
		 * Method returns content of 1 widget as usual HTTP response.
		 * @param	wid - The ID of widget
		 * @param	callback
		 */
		public static function getWidgetContent(wid:String, callback:Function):void 
		{
			Odnoklassniki.callRestApi("widget.getWidgetContent", callback, { wid:wid}, "XML" );
		}
		
	}

}