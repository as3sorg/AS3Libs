package org.as3s.utils
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class XMLLoader extends URLLoader
	{		
		private var _xml:XML;
		public function get xml():XML
		{
			return _xml;
		}
		
		public function XMLLoader(request:URLRequest=null)
		{
			super(request);
			this.addEventListener(Event.COMPLETE, onLoad);
		}
		
		private function onLoad(e:Event):void
		{
			_xml = parse(this.data);
		}
		
		private function parse(src:String):XML
		{
			return XML(src);
		}
	}
}