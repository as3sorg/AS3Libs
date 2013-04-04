package org.as3s.command
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class TimerCommand extends Command
	{
		private var _timer:Timer;
		public function get timer():Timer
		{
			return _timer;
		}
		
		private var _command:Command;
		public function get command():Command
		{
			return _command;
		}

		public function TimerCommand(command:Command, delay:Number, repeat:int=1)
		{
			_command = command;
			_timer = new Timer(delay, repeat);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			super(timer, timer.start, null, TimerEvent.TIMER_COMPLETE);
		}
		
		private function onTimer(e:TimerEvent):void
		{
			command.execute();
		}
		
		public override function cancel():void
		{
			timer.reset();
			super.cancel();
		}
		
	}
}