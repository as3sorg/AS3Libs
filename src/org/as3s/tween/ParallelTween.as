package org.as3s.tween
{
	import flash.events.*;
		
	public class ParallelTween extends Tween
	{
		protected var _list:Array;
		public function get list():Array
		{
			return _list;
		}
		
		public override function get playing():Boolean
		{
			for each (var tween:Tween in list) {
				if (tween.playing) return true;
			}
			return false;
		}
		
		public function ParallelTween(...args)
		{
			_list = args;
			super(this, null);
		}
		
		public override function execute():void
		{
			var i:int = list.length;
			while(i--) {
				var tween:Tween = list[i];
				tween.addEventListener(Event.COMPLETE, complete);
				tween.addEventListener(Event.CANCEL, cancelled);
				tween.execute();
			}
		}
		
		public override function play():void
		{
			for each (var tween:Tween in list) {
				tween.play();
			}
		}
		
		public override function stop():void
		{
			for each (var tween:Tween in list) {
				tween.stop();
			}
		}
		
		public override function reset():void
		{
			for each (var tween:Tween in list) {
				tween.reset();
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