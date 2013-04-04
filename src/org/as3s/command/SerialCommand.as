package org.as3s.command
{
	import flash.events.*;
	
	public class SerialCommand extends Command
	{
		
		protected var _list:Array;
		public function get list():Array
		{
			return _list;
		}
		
		public function get currentCommand():Command
		{
			if (list.length>0) {
				return list[0];
			} else {
				return null;
			}
		}
		
		public function SerialCommand(...args)
		{
			_list = args;
			super(this, null, null, Event.COMPLETE);
		}
		
		public override function execute():void
		{
			if (list.length>0) {
				var command:Command = list[0];
				command.addEventListener(Event.COMPLETE, complete);
				command.addEventListener(Event.CANCEL, cancelled);
				command.execute();
			}
		}
		
		protected override function complete(e:Event = null):void
		{
			list.shift();
			if (list.length>0) {
				execute();
			} else {
				super.complete();
			}
		}
		
		public override function cancel():void
		{
			for each (var command:Command in list) {
				command.cancel();
			}
		}
		
		protected function cancelled(e:Event):void
		{
			var index:int = list.indexOf(e.target);
			if (index>=0) {
				list.splice(index, 1);
			}
			if (list.length==0) {
				super.cancel();
			}
		}
		
	}
}