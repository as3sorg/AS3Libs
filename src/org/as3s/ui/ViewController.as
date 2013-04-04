package org.as3s.ui
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;

	public class ViewController extends EventDispatcher
	{
		private var _view:View;
		public function get view():View
		{
			return _view;
		}
		
		public function get stage():Stage
		{
			return parent.stage;
		}
		
		private var _parent:ViewController;
		public function get parent():ViewController
		{
			return _parent;
		}
		
		public function ViewController(view:View, parent:ViewController=null)
		{
			_view = view;
			_parent = parent;			
		}
						
	}
}