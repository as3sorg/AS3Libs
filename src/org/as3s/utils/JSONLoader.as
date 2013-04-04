package org.as3s.utils
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class JSONLoader extends URLLoader
	{		
		private var _json:Object;
		public function get json():Object
		{
			return _json;
		}
		
		public function JSONLoader(request:URLRequest=null)
		{
			super(request);
			this.addEventListener(Event.COMPLETE, onLoad);
		}
		
		private function onLoad(e:Event):void
		{
			_json = parse(this.data);
		}
		
		private function parse(src:String):Object
		{
			return JSON.parse(src);
		}
	}
}