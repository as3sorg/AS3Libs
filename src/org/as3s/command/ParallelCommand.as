package org.as3s.command
{
	import flash.events.*;
	
	public class ParallelCommand extends Command
	{
		protected var _list:Array;
		public function get list():Array
		{
			return _list;
		}
		
		public function ParallelCommand(...args)
		{
			_list = args;
			super(this, null, null, Event.COMPLETE);
		}
		
		public override function execute():void
		{
			var i:int = list.length;
			while(i--) {
				var command:Command = list[i];
				command.addEventListener(Event.COMPLETE, complete);
				command.addEventListener(Event.CANCEL, cancelled);
				command.execute();
			}
		}
		
		protected override function complete(e:Event = null):void
		{
			var index:int = list.indexOf(e.target);
			if (index>=0) {
				list.splice(index, 1);
			}
			if (list.length==0) {
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