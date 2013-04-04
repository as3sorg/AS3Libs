package org.as3s.utils
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class CSVLoader extends URLLoader
	{
		private var _csv:Array;
		public function get csv():Array
		{
			if (_csv==null) _csv = parse(this.data);
			return _csv;
		}
		
		private var _ignoreWhite:Boolean = true;
		public function get ignoreWhite():Boolean
		{
			return _ignoreWhite;
		}
		public function set ignoreWhite(value:Boolean):void
		{
			_ignoreWhite = value;
		}

		
		public function CSVLoader(request:URLRequest=null)
		{
			super(request);
			this.addEventListener(Event.COMPLETE, onLoad);
		}
		
		private function onLoad(e:Event):void
		{
			_csv = parse(this.data);
		}
		
		private function parse(src:String):Array
		{
			src = (src.split("\r\n")).join("\n");
			src = (src.split("\r")).join("\n");
			var lines:Array = src.split("\n");
			var res:Array = new Array();
			for(var i:int=0; i<lines.length; i++) {
				if (!_ignoreWhite || lines[i].length>0) {
					var line:Array = lines[i].split(",");
					res.push(line);
				}
			}
			return res;
		}
	}
}