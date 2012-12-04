package com.nextgame.utils 
{
	import com.nextgame.events.SARequestEvent;
	
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class ObjectPool
	{
		private var object:Object;
		
		private var keyIndex:int 	= 0;
		private var valueIndex:int 	= 0;
		
		public function ObjectPool()
		{			
		}

		/**
		 * 
		 * @param C    The class to create 
		 *
		 */
		public function allocate(C:*):void
		{
			deconstruct();			
			object = C;
			object.addEventListener(SARequestEvent.COMPLETE, completeFunc);
			
			iter = new Iterrator();
		}
		
		/**
		 * method for applying a function.
		 * 
		 * @param func The function's name.
		 * @param args The function's arguments.
		 */
		private var iter:Iterrator;
		public function initialze(func:String, args:Array=null):void
		{	
			iter.put(func, args);		
		}
		
		public function process():void
		{
			object[iter.keys[keyIndex]].apply(object, iter.values[valueIndex]);			
		}
		
		private function completeFunc(event:SARequestEvent):void
		{
			keyIndex++;
			valueIndex++;
			if (iter.keys.length == keyIndex)
			{
				object.dispatchEvent(new Event(Event.COMPLETE));
				deconstruct();
				return;
			}
			process();
		}
		
		private function deconstruct():void
		{		
			if (object != null)
				object.removeEventListener(SARequestEvent.COMPLETE, completeFunc);	
			object = null;	
			iter = null;						
		}
		
		private function getClass(C:Class):*
		{
			return new C;
		}		
	}
}