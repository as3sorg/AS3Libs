package org.as3s.ui
{
	import flash.display.Stage;
	import flash.events.Event;

	public class StageViewController extends ViewController
	{
		private var _stage:Stage;
		public override function get stage():Stage
		{
			return _stage;
		}
		
		public function StageViewController(stage:Stage)
		{
			_stage = stage;
			super(new View(stage.stageWidth, stage.stageHeight));
			view.resizeSubViews = true;
			stage.addChild(view);
			stage.addEventListener(Event.RESIZE, onResizeStage);
		}
		
		protected function onResizeStage(e:Event):void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
		
	}
}