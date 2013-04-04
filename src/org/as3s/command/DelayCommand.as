package org.as3s.command
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class DelayCommand extends Command
	{
		private static var frame:Sprite = new Sprite();
		private static var list:Array = [];
		
		private static function add(delay:DelayCommand):void
		{
			if (list.length==0) {
				frame.addEventListener(Event.ENTER_FRAME, update);
			}
			if (list.indexOf(delay)<0) {
				list.push(delay);
			}
		}
		
		private static function remove(delay:DelayCommand):void
		{
			var index:int = list.indexOf(delay);
			if (index>=0) {
				list.splice(index, 1);
			}
			if (list.length==0) {
				frame.removeEventListener(Event.ENTER_FRAME, update);
			}
		}
		
		private static function update(e:Event):void
		{
			for each (var delay:DelayCommand in list) {
				delay.update();
			}
		}
		
		/**
		 * Duration 
		 */		
		private var _duration:Number;
		public function get duration():Number
		{
			return _duration;
		}
		public function set duration(value:Number):void
		{
			_duration = value;
		}
		
		/**
		 * Use Seconds 
		 */		
		private var _useSeconds:Boolean = false;
		public function get useSeconds():Boolean
		{
			return _useSeconds;
		}
		public function set useSeconds(value:Boolean):void
		{
			_useSeconds = value;
		}
				
		private var _frames:int = 0;
		private var _startTime:Number;
		private function get time():int {
			return _useSeconds ? getTimer() : _frames;
		}
		
		public function DelayCommand(duration:Number = 1, useSeconds:Boolean = false)
		{
			_duration = useSeconds ? duration*1000 : duration;
			_useSeconds = useSeconds;
			
			super();
		}
		
		public override function execute():void
		{			
			_startTime = time;
			DelayCommand.add(this);
		}
				
		private function update():void {
			var t:Number = time-_startTime;
			if (t>=duration) {
				DelayCommand.remove(this);
				trace("delayed");
				super.execute();
			} else {
				_frames++;				
			}
		}
		
		public override function cancel():void
		{
			DelayCommand.remove(this);
			super.cancel();
		}
				
	}
}