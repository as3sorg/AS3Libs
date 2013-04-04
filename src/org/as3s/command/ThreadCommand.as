package org.as3s.command
{
	import flash.display.Sprite;
	import flash.events.*;
	
	public class ThreadCommand extends Command
	{
		private static var frame:Sprite = new Sprite();
		
		protected var _list:Array;
		public function get list():Array
		{
			return _list;
		}
		
		protected var _pool:Array;
		
		private var _currentCommand:Command;
		public function get currentCommand():Command
		{
			return _currentCommand;
		}
		
		private var _commandsPerFrame:Number = 1;		
		public function get commandsPerFrame():Number
		{
			return _commandsPerFrame;
		}
		public function set commandsPerFrame(value:Number):void
		{
			if (value==0) {
				_commandsPerFrame = 0;
				_framesPerCommand = Infinity;				
			} else if (value<1) {
				_commandsPerFrame = 1;
				_framesPerCommand = Math.round(1/value);
			} else {
				_commandsPerFrame = Math.round(value);
				_framesPerCommand = 1;
			}
		}
		
		private var _framesPerCommand:Number = 1;
		public function get framesPerCommand():Number
		{
			return _framesPerCommand;
		}
		public function set framesPerCommand(value:Number):void
		{
			if (value==0) {
				_commandsPerFrame = Infinity;
				_framesPerCommand = 0;				
			} else if (value<1) {
				_commandsPerFrame = Math.round(1/value);
				_framesPerCommand = 1;
			} else {
				_commandsPerFrame = 1;
				_framesPerCommand = Math.round(value);
			}
		}
				
		public function ThreadCommand(...args)
		{
			_list = args;
			_pool = [];
			super(this, null, null, Event.COMPLETE);
		}
		
		public override function execute():void
		{
			if (list.length>0) {
				var i:int=0;
				var frames:int = 0;
				frame.addEventListener(Event.ENTER_FRAME, function(e:Event):void {
					if (++frames>=_framesPerCommand) {
						frames = 0;
						var commands:int = _commandsPerFrame;
						while (_commandsPerFrame==Infinity || commands--) {
							if (i<list.length) {
								_currentCommand = list.shift();
								_pool.push(currentCommand);
								currentCommand.addEventListener(Event.COMPLETE, complete);
								currentCommand.addEventListener(Event.CANCEL, cancelled);
								currentCommand.execute();
							} else {
								e.currentTarget.removeEventListener(e.type, arguments.callee);
								break;
							}
						}
					}
				});
			}
		}
		
		protected override function complete(e:Event = null):void
		{
			var index:int = _pool.indexOf(e.target);
			if (index>=0) {
				_pool.splice(index, 1);
			}
			if (_pool.length==0) {
				super.complete();
			}
		}
		
		public override function cancel():void
		{
			_list = [];
			for each (var command:Command in _pool) {
				command.cancel();
			}
		}
		
		protected function cancelled(e:Event):void
		{
			var index:int = _pool.indexOf(e.target);
			trace("canncelled:"+index);
			if (index>=0) {
				_pool.splice(index, 1);
			}
			if (_pool.length==0) {
				super.cancel();
			}
		}
	}
}