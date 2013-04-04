/**
 * TweenProxy Class for ActionScript3.0
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
	import flash.events.Event;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	public dynamic class TweenProxy extends Proxy
	{		
		private var _target:Object;		
		private var _equation:Function;
		private var _duration:Number;
		private var _delay:Number;
		private var _useSeconds:Boolean = false;
		
		private var _tweens:Object;
		
		private var _listeners:Object;
				
		public function TweenProxy(target:Object, equation:Function = null, duration:Number = 15, delay:Number = 0, useSeconds:Boolean = false):void
		{
			_target = target;
			_equation = equation;
			_duration = duration;
			_delay = delay;
			_useSeconds = useSeconds;
			
			_tweens = {};
			_listeners = {};
		}
		
		override flash_proxy function getProperty(key:*):*
		{
			if (_tweens[key]==null) {
				return _target[key];
			} else {
				return _tweens[key].props[key];
			}
		}
		
		override flash_proxy function setProperty(key:*, value:*):void
		{			
			var tween:Tween;
			if (_tweens[key]==null) {
				var props:Object = {};
				props[key] = value;
				tween = new Tween(_target, props, _equation, _duration, _delay, 1, false, _useSeconds);
				if (_listeners[key]!=null) {
					for each (var listener:Function in _listeners[key]) {
						tween.addEventListener(Event.COMPLETE, listener);
					}
				}
				_tweens[key] = tween;
			} else {
				tween = _tweens[key];
				tween.props[key] = value;
			}
			tween.execute();
		}
		
		override flash_proxy function callProperty(name:*, ... args):*
		{
			return _target[name].apply(_target, args);
		}
		
		public function getTarget():Object
		{
			return _target;
		}
		
		public function getTween(key:*):Tween
		{
			return _tweens[key];
		}
		
		public function reset():void
		{
			for each (var tween:Tween in _tweens) {
				tween.reset();
			}
		}
		
		public function addEventListener(key:String, listener:Function):void
		{
			if (_listeners[key]==null) {
				_listeners[key] = [];
			}
			if (_listeners[key].indexOf(listener)<0) {
				_listeners[key].push(listener);
			}
			if (_tweens[key]!=null) {
				_tweens[key].addEventListener(Event.COMPLETE, listener);
			}
		}
		
		public function hasEventListener(key:String):Boolean
		{
			return _listeners[key]!=null && _listeners[key].length>0;
		}
		
		public function removeEventListener(key:String, listener:Function):void
		{
			if (_listeners[key]==null) return;
			var index:int = _listeners[key].indexOf(listener);
			if (index>=0) {
				_listeners[key].splice(index, 1);
			}
			if (_tweens[key]!=null) {
				_tweens[key].removeEventListener(Event.COMPLETE, listener);
			}
		}
				
	}
	
}
