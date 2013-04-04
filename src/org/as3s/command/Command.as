package org.as3s.command
{
	import flash.events.*;
	
	public class Command extends EventDispatcher
	{
		protected var _target:Object;
		public function get target():Object
		{
			return _target;
		}
		
		protected var _running:Boolean = false;
		public function get running():Boolean
		{
			return _running;
		}

		protected var _func:Function;
		protected var _args:Array;
		protected var _type:String;
		
		public function Command(target:Object=null, func:Function=null, args:Array=null, type:String="")
		{
			_target = target;
			_func = func;
			_args = args;
			_type = type;
			if (target!=null && _type!="") {
				_target.addEventListener(_type, complete);
			}
		}
		
		public function execute():void
		{
			_running = true;
			if (_func!=null) {
				_func.apply(_target, _args);
			}
			if (_type=="") {
				complete();
			}
		}
		
		public function cancel():void
		{
			_running = false;
			if (_type!="") {
				_target.removeEventListener(_type, complete);
			}
			dispatchEvent(new Event(Event.CANCEL));
		}
		
		protected function complete(event:Event = null):void
		{
			_running = false;
			if (target!=null && _type!="") {
				_target.removeEventListener(_type, complete);
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}