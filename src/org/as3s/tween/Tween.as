/**
 * Tween Class for ActionScript3.0
 * 
 * Copyright (c) Hisato Ogata
 * Licensed under the MIT License
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * @langversion ActionScript 3.0
 * @playerversion Flash 9
 * 
 * @version 0.5
 * @author Hisato Ogata
 * @see http://as3s.org/
 * 
 * @example usage:
 * <listing version="3.0">
 * 
 * </listing>
 */

package org.as3s.tween
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.as3s.command.Command;
	
	public class Tween extends Command
	{
		public static const UPDATE:String = "tween_update";
		
		private static var frame:Sprite = new Sprite();
		private static var list:Array = [];
		
		private static function add(tween:Tween):void
		{
			if (list.length==0) {
				frame.addEventListener(Event.ENTER_FRAME, update);
			}
			if (list.indexOf(tween)<0) {
				list.push(tween);
			}
		}
		
		private static function remove(tween:Tween):void
		{
			var index:int = list.indexOf(tween);
			if (index>=0) {
				list.splice(index, 1);
			}
			if (list.length==0) {
				frame.removeEventListener(Event.ENTER_FRAME, update);
			}
		}
		
		private static function update(e:Event):void
		{
			for each (var tween:Tween in list) {
				tween.update();
			}
		}
		
		/**
		 * Properties
		 */		
		private var _props:Object;
		public function get props():Object
		{
			return _props;
		}
		public function set props(value:Object):void
		{
			_props = value;
		}

		/**
		 * Tween eqauation 
		 */		
		private var _equation:Function;
		public function get equation():Function
		{
			return _equation;
		}
		public function set equation(value:Function):void
		{
			_equation = value;
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
		 * Delay 
		 */
		private var _delay:Number = 0;
		public function get delay():Number
		{
			return _delay;
		}
		public function set delay(value:Number):void
		{
			_delay = value;
		}

		/**
		 * Repeat count 
		 */		
		private var _repeat:int = 1;
		public function get repeat():int
		{
			return _repeat;
		}
		public function set repeat(value:int):void
		{
			_repeat = value;
		}

		/**
		 * Auto reverse
		 */
		private var _reverse:Boolean = false;
		public function get reverse():Boolean
		{
			return _reverse;
		}
		public function set reverse(value:Boolean):void
		{
			_reverse = value;
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
		
		/**
		 * Playing flag 
		 */		
		private var _playing:Boolean = false;
		public function get playing():Boolean
		{
			return _playing;
		}
		
		private var _params:Object;
		private var _frames:int = 0;
		private var _startTime:Number;
		private var _stopTime:Number = 0;
		private var _pauseDuration:Number = 0;
		private var _reversing:Boolean = false;
		private function get time():int {
			return _useSeconds ? getTimer() : _frames;
		}

		public function Tween(target:Object, props:Object, equation:Function = null, duration:Number = 15, delay:Number = 0, repeat:int = 1, reverse:Boolean = false, useSeconds:Boolean = false)
		{
			_props = props;
			_equation = equation==null ? TweenEquations.easeOutQuad : equation;
			_duration = useSeconds ? duration*1000 : duration;
			_delay = useSeconds ? delay*1000 : delay;
			_repeat = repeat;
			_reverse = reverse;
			_useSeconds = useSeconds;
			
			super(target, null, null, Event.COMPLETE);
		}
		
		public override function execute():void
		{
			_params = {};
			for (var key:String in _props) {
				var p:Object = {};
				p.begin = _target[key];
				p.end = _props[key];
				p.change = p.end - p.begin;
				_params[key] = p;
			}

			reset();
			play();
		}
		
		public function play():void
		{
			Tween.add(this);
			if (_stopTime==0) {
				_startTime = time;
			} else {
				_pauseDuration += time - _stopTime;
			}
			_playing = true;
		}
		
		public function stop():void
		{
			_stopTime = time;
			Tween.remove(this);
			_playing = false;
		}
		
		public function reset():void
		{
			_frames = 0;
			_stopTime = 0;
			_pauseDuration = 0;
			_reversing = false;
			Tween.remove(this);
			_playing = false;
		}
		
		private function update():void {
			var t:Number = time-_pauseDuration-_startTime-_delay;
			_frames++;
			if (t<0) return;
						
			var key:String;
			var p:Object;
			if (t<duration) {
				for (key in _params) {
					p = _params[key];
					_target[key] = _equation(t, p.begin, p.change, _duration);
					if (hasEventListener(Tween.UPDATE)) dispatchEvent(new Event(Tween.UPDATE));
				}
			} else {
				if (!_reverse) {
					for (key in _params) {
						_target[key] = _params[key].end;
						if (hasEventListener(Tween.UPDATE)) dispatchEvent(new Event(Tween.UPDATE));
					}
					complete();
				} else {
					if (t<duration*2) {
						t = duration*2 - t;
						for (key in _params) {
							p = _params[key];
							_target[key] = _equation(t, p.begin, p.change, _duration);
							if (hasEventListener(Tween.UPDATE)) dispatchEvent(new Event(Tween.UPDATE));
						}
					} else {
						for (key in _params) {
							_target[key] = _params[key].begin;
							if (hasEventListener(Tween.UPDATE)) dispatchEvent(new Event(Tween.UPDATE));
						}
						complete();
					}
				}
			}
		}
		
		public override function cancel():void
		{
			Tween.remove(this);
			_playing = false;
			super.cancel();
		}
		
		protected override function complete(event:Event=null):void
		{
			if (_repeat>1 || _repeat==0) {
				if (_repeat>1) repeat--;
				reset();
				play();
			} else {
				Tween.remove(this);
				_playing = false;
				super.complete();
			}
		}
		
		public override function toString():String
		{
			var str:String = "[Tween " + _target.toString() + " {";
			for (var key:String in props) {
				str += key + ":" + props[key] + ",";
			}
			str = str.slice(0, -1);
			str += "}]";
			return str;
		}
		
	}
}