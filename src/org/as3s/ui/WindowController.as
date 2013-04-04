package org.as3s.ui
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;

	public class WindowController extends StageViewController
	{
		
		private var _window:NativeWindow;
		public function get window():NativeWindow
		{
			return _window;
		}
		
		public function get fullScreen():Boolean
		{
			return window.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		public function set fullScreen(value:Boolean):void
		{
			if (value!=fullScreen) {
				if (value) {
					stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;				
				} else {
					stage.displayState = StageDisplayState.NORMAL;
				}
			}
		}
		
		private var _screenIndex:int = 0;
		public function get screenIndex():int
		{
			return _screenIndex;
		}
		public function set screenIndex(value:int):void
		{
			if (value!=screenIndex) {
				if (Screen.screens.length>value) {
					_screenIndex = value;
					window.x = Screen.screens[value].bounds.x;
				}
			}
		}
		
		public function WindowController(window:NativeWindow=null, options:NativeWindowInitOptions=null)
		{
			if (window!=null) {
				_window = window;
			} else {
				if (options==null) {
					options = new NativeWindowInitOptions();
				}
				_window = new NativeWindow(options);
			}
						
			super(_window.stage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
		public function activate():void
		{
			if (window!=null) {
				window.activate();
			}
		}
						
		public function close():void
		{
			if (window!=null) {
				window.close();
			}
		}
			
	}
}