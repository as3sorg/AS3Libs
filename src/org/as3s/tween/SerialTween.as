package org.as3s.tween
{
	import flash.events.Event;

	public class SerialTween extends Tween
	{
		protected var _list:Array;
		public function get list():Array
		{
			return _list;
		}
		
		public function get currentTween():Tween
		{
			if (list.length>0) {
				return list[0];
			} else {
				return null;
			}
		}
		
		public override function get playing():Boolean
		{
			if (currentTween!=null) {
				return currentTween.playing;
			} else {
				return false;
			}
		}
		
		public function SerialTween(...args)
		{
			_list = args;
			super(this, null);
		}
		
		public override function execute():void
		{
			if (list.length>0) {
				var tween:Tween = list[0];
				tween.addEventListener(Event.COMPLETE, complete);
				tween.addEventListener(Event.CANCEL, cancelled);
				tween.execute();
			}
		}
		
		public override function play():void
		{
			if (currentTween!=null) {
				currentTween.play();
			}
		}
		
		public override function stop():void
		{
			if (currentTween!=null) {
				currentTween.stop();
			}
		}
		
		public override function reset():void
		{
			if (currentTween!=null) {
				currentTween.reset();
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
			for each (var tween:Tween in list) {
				tween.cancel();
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