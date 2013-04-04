package org.as3s.command
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class LoaderCommand extends Command
	{
		private var _loader:URLLoader;
		public function get loader():URLLoader
		{
			return _loader;
		}
		
		public function LoaderCommand(loader:URLLoader, url:URLRequest)
		{
			_loader = loader;
			super(loader, loader.load, [url], Event.COMPLETE);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		protected function onIOError(e:IOErrorEvent):void
		{
			super.cancel();
		}
	}
}