package org.as3s.ui
{
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class WireframeView extends View
	{
		private var _textField:TextField;
		public function get textField():TextField
		{
			return _textField;
		}
		
		public function get text():String
		{
			return textField.text;
		}
		public function set text(value:String):void
		{
			textField.text = value;
		}
		
		public function WireframeView(parent:View, text:String="", borderEnabled:Boolean=false)
		{
			super(parent.width, parent.height, parent.left, parent.top);
			
//			backgroundEnabled = true;
//			backgroundAlpha = 0.5;
//			backgroundColor = 0x000000;
			
//			resizeSubViews = true;
			
			autoResize = View.RESIZE_NONE;

			if (borderEnabled) {
				border = BORDER;
				borderAlpha = 0.5;
				borderColor = 0xffffff;
			}
			
			_textField = new TextField();
//			textField.x = left;
//			textField.width = width;
			textField.mouseEnabled = false;
			textField.selectable = false;
			textField.textColor = 0xffffff;
			textField.defaultTextFormat = new TextFormat("_sans", 24);
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = text;
			textField.alpha = 0.5;
			addChild(textField);
			
//			textField.y = top+(height-textField.height)/2;
			
//			userInteractionEnabled = true;
//			useHandCursor = true;
		}
		
		
	}
}