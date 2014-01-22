package org.as3s.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.as3s.tween.TweenEquations;
	import org.as3s.tween.TweenProxy;
	
	public class View extends MovieClip
	{
		// tween
		protected var _tween:TweenProxy;
		public function get tween():TweenProxy
		{
			return _tween;
		}
		public function set tween(value:TweenProxy):void
		{
			if (_tween!=null) _tween.reset();
			_tween = value;
		}
		
		// left
		private var _left:Number = 0;
		public function get left():Number
		{
			return _left;
		}
		public function set left(value:Number):void
		{
			if (_left!=value) {
				if (resizeSubViews) {
					for (var i:int=0; i<numChildren; i++) {
						if (getChildAt(i) is View) {
							var subView:View = getChildAt(i) as View;
							if (subView.autoResize) {
								subView.x += (value-_left);
							}
						}
					}
				}
				_left = value;
				drawMask();
				drawBackground();
			}
		}
		public function get right():Number
		{
			return width+left;
		}
		
		// top
		private var _top:Number = 0;
		public function get top():Number
		{
			return _top;
		}
		public function set top(value:Number):void
		{
			if (_top!=value) {
				if (resizeSubViews) {
					for (var i:int=0; i<numChildren; i++) {
						if (getChildAt(i) is View) {
							var subView:View = getChildAt(i) as View;
							if (subView.autoResize) {
								subView.y += (value-_top);
							}
						}
					}
				}
				_top = value;
				drawMask();
				drawBackground();
			}
		}
		public function get bottom():Number
		{
			return height+top;
		}

		
		// x
		private var _x:Number = 0;
		public override function get x():Number
		{
			return _x;
		}
		public override function set x(value:Number):void
		{
			_x = value;
			super.x = value;
		}
		
		// y
		private var _y:Number = 0;
		public override function get y():Number
		{
			return _y;
		}
		public override function set y(value:Number):void
		{
			_y = value;
			super.y = value;
		}
		
		// width
		private var _width:Number = 0;
		public override function get width():Number
		{
			return _width;
		}
		public override function set width(value:Number):void
		{
			if (_width!=value) {
				if (_width>0 && resizeSubViews) {
					for (var i:int=0; i<numChildren; i++) {
						if (getChildAt(i) is View) {
							var subView:View = getChildAt(i) as View;
							if (subView.autoResize) {
								var scale:Number;
								var r:Number = right-(subView.x + subView.right);
								var l:Number = (subView.x+subView.left)-left;
								if (subView.autoResize & RESIZE_WIDTH) {
									if (subView.autoResize & RESIZE_LEFT_MARGIN && subView.autoResize & RESIZE_RIGHT_MARGIN) {
										scale = value/width;
										subView.x = left + scale*(subView.x-left);
									} else if (subView.autoResize & RESIZE_RIGHT_MARGIN) {
										scale = (value-l)/(width-l);
										subView.x = left + l - scale*subView.left;
									} else if (subView.autoResize & RESIZE_LEFT_MARGIN) {
										scale = (value-r)/(width-r);
										subView.x = left + l*scale - scale*subView.left;
									} else {
										scale = (value-r-l)/(width-r-l);
										subView.x = left + l - scale*subView.left;
									}
									subView.left *= scale;
									subView.width *= scale;
								} else {
									if (subView.autoResize & RESIZE_LEFT_MARGIN && subView.autoResize & RESIZE_RIGHT_MARGIN) {
										scale = (value-subView.width)/(width-subView.width);
										subView.x = left + l*scale -subView.left;
									} else if (subView.autoResize & RESIZE_LEFT_MARGIN) {
										subView.x = left + l - subView.left + (value-width);
									}
								}
							}
						}
					}
				}
				_width = value;
				drawMask();
				drawBackground();
			}
		}

		// height
		private var _height:Number = 0;
		public override function get height():Number
		{
			return _height;
		}
		public override function set height(value:Number):void
		{
			if (_height!=value) {
				if (_height>0 && resizeSubViews) {
					for (var i:int=0; i<numChildren; i++) {
						if (getChildAt(i) is View) {
							var subView:View = getChildAt(i) as View;
							if (subView.autoResize) {
								var scale:Number;
								var b:Number = bottom-(subView.y + subView.bottom);
								var t:Number = (subView.y+subView.top)-top;
								if (subView.autoResize & RESIZE_HEIGHT) {
									if (subView.autoResize & RESIZE_TOP_MARGIN && subView.autoResize & RESIZE_BOTTOM_MARGIN) {
										scale = value/height;
										subView.y = top + scale*(subView.y-top);
									} else if (subView.autoResize & RESIZE_BOTTOM_MARGIN) {
										scale = (value-t)/(height-t);
										subView.y = top + t - scale*subView.top;
									} else if (subView.autoResize & RESIZE_TOP_MARGIN) {
										scale = (value-b)/(height-b);
										subView.y = top + t*scale - scale*subView.top;
									} else {
										scale = (value-b-t)/(height-b-t);
										subView.y = top + t - scale*subView.top;
									}
									subView.top *= scale;
									subView.height *= scale;
								} else {
									if (subView.autoResize & RESIZE_TOP_MARGIN && subView.autoResize & RESIZE_BOTTOM_MARGIN) {
										scale = (value-subView.height)/(height-subView.height);
										subView.y = top + t*scale -subView.top;
									} else if (subView.autoResize & RESIZE_TOP_MARGIN) {
										subView.y = top + t - subView.top + (value-height);
									}
								}
							}
						}
					}
				}
				_height = value;
				drawMask();
				drawBackground();
			}
		}
		
		// fade
		private var _fade:Number = 1.0;
		public function get fade():Number
		{
			return _fade;
		}
		public function set fade(value:Number):void
		{
			if (_fade!=value) {
				_fade = value;
				transform.colorTransform = new ColorTransform(value, value, value);		
			}
		}

		
		// background
		protected var _backgroundEnabled:Boolean = false;
		public function get backgroundEnabled():Boolean
		{
			return _backgroundEnabled;
		}
		public function set backgroundEnabled(value:Boolean):void
		{
			if (_backgroundEnabled!=value) {
				_backgroundEnabled = value;
				drawBackground();
			}
		}
		
		protected var _backgroundColor:uint = 0xffffff;
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		public function set backgroundColor(value:uint):void
		{
			if (_backgroundColor!=value) {
				_backgroundColor = value;
				drawBackground();
			}
		}
		
		protected var _backgroundAlpha:Number = 1.0;
		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}
		public function set backgroundAlpha(value:Number):void
		{
			if (_backgroundAlpha!=value) {
				_backgroundAlpha = value;
				drawBackground();
			}
		}
		
		// border
		public static const BORDER_NONE:uint = 0x00;
		public static const BORDER_TOP:uint = 0x01;
		public static const BORDER_BOTTOM:uint = 0x02;
		public static const BORDER_LEFT:uint = 0x04;
		public static const BORDER_RIGHT:uint = 0x08;
		public static const BORDER:uint = 0x08|0x04|0x02|0x01;
		
		protected var _border:uint = BORDER_NONE;
		public function get border():uint
		{
			return _border;
		}
		public function set border(value:uint):void
		{
			if (_border!=value) {
				_border = value;
				drawBackground();
			}
		}
		
		protected var _borderThickness:Number = 0;
		public function get borderThickness():Number
		{
			return _borderThickness;
		}
		public function set borderThickness(value:Number):void
		{
			if (_borderThickness!=value) {
				_borderThickness = value;
				drawBackground();
			}
		}
		
		protected var _borderColor:uint = 0x000000;
		public function get borderColor():uint
		{
			return _borderColor;
		}
		public function set borderColor(value:uint):void
		{
			if (_borderColor!=value) {
				_borderColor = value;
				drawBackground();
			}
		}
		
		protected var _borderAlpha:Number = 1.0;
		public function get borderAlpha():Number
		{
			return _borderAlpha;
		}
		public function set borderAlpha(value:Number):void
		{
			if (_borderAlpha!=value) {
				_borderAlpha = value;
				drawBackground();
			}
		}
		
		// mask
		protected var _mask:Shape;
		protected var _maskEnabled:Boolean = false;
		public function get maskEnabled():Boolean
		{
			return _maskEnabled;
		}
		public function set maskEnabled(value:Boolean):void
		{
			if (_maskEnabled!=value) {
				_maskEnabled = value;
				this.mask = _maskEnabled ? _mask : null;
				drawMask();
			}
		}
		
		// resize
		public static const RESIZE_NONE:uint = 0x00;
		public static const RESIZE_TOP_MARGIN:uint = 0x01;
		public static const RESIZE_BOTTOM_MARGIN:uint = 0x02;
		public static const RESIZE_LEFT_MARGIN:uint = 0x04;
		public static const RESIZE_RIGHT_MARGIN:uint = 0x08;
		public static const RESIZE_MARGIN:uint = 0x01|0x02|0x04|0x08;
		public static const RESIZE_WIDTH:uint = 0x10;
		public static const RESIZE_HEIGHT:uint = 0x20;
		public static const RESIZE:uint = 0x01|0x02|0x04|0x08|0x10|0x20;
		
		protected var _autoResize:uint = RESIZE;
		public function get autoResize():uint
		{
			return _autoResize;
		}
		public function set autoResize(value:uint):void
		{
			_autoResize = value;
		}
		
		protected var _resizeSubViews:Boolean = true;
		public function get resizeSubViews():Boolean
		{
			return _resizeSubViews;
		}
		public function set resizeSubViews(value:Boolean):void
		{
			_resizeSubViews = value;
		}
		
		// userInteraction
		protected var _userInteractionEnabled:Boolean = false;
		public function get userInteractionEnabled():Boolean
		{
			return _userInteractionEnabled;
		}
		public function set userInteractionEnabled(value:Boolean):void
		{
			if (value!=_userInteractionEnabled) {
				_userInteractionEnabled = value;
				mouseEnabled = value;
				useHandCursor = value;
				buttonMode = value;
				if (_userInteractionEnabled) {
					addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true);
					addEventListener(MouseEvent.CLICK, onClick, true);
				} else {
					removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, true);
				}
			}
		}
		
		// parent
		public function get parentView():View
		{
			return parent as View;
		}
				
		public function View(width:Number = 0, height:Number = 0, left:Number = 0, top:Number = 0)
		{
			super();
			
			mouseEnabled = _userInteractionEnabled;
			useHandCursor = _userInteractionEnabled;
			buttonMode = _userInteractionEnabled;
			
			_mask = new Shape();
			_mask.visible = false;
			addChild(_mask);
			
			_left = left;
			_top = top;
			_width = width;
			_height = height;
			
			_tween = new TweenProxy(this, TweenEquations.easeOutQuad, 15);
		}
		
		protected function drawMask():void
		{
			if (_maskEnabled) {
				_mask.graphics.clear();
				_mask.graphics.beginFill(0x000000);
				_mask.graphics.drawRect(_left, _top, _width, _height);
				_mask.graphics.endFill();
			}
		}
		
		protected function drawBackground():void
		{
//			trace("drawBackground");
			if (_backgroundEnabled||_border) {
				graphics.clear();
				if (_backgroundEnabled) {
					graphics.beginFill(_backgroundColor, _backgroundAlpha);
					graphics.drawRect(_left, _top, _width, _height);
					graphics.endFill();
				}
				if (_border) {
					graphics.lineStyle(borderThickness, borderColor, borderAlpha);
					graphics.moveTo(_left, _top);
					if (_border & BORDER_TOP) {
						graphics.lineTo(_left+_width, _top);
					} else {
						graphics.moveTo(_left+_width, _top);						
					}
					if (_border & BORDER_RIGHT) {
						graphics.lineTo(_left+_width, _top+_height);
					} else {
						graphics.moveTo(_left+_width, _top+_height);						
					}
					if (_border & BORDER_BOTTOM) {
						graphics.lineTo(_left, _top+_height);
					} else {
						graphics.moveTo(_left, _top+_height);						
					}
					if (_border & BORDER_LEFT) {
						graphics.lineTo(_left, _top);
					}
				}
			}
		}
		
		private var _mousePressed:Boolean = false;
		public function get mousePressed():Boolean
		{
			return _mousePressed;
		}

		private var mouseDownPoint:Point;
		private var clickThreshold:Number = 5;
		private function onMouseDown(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_mousePressed = true;
			mouseDownPoint = new Point(e.stageX, e.stageY);
		}
		private function onMouseUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_mousePressed = false;
		}
		
		private function onClick(e:MouseEvent):void
		{	
			var dx:Number = e.stageX-mouseDownPoint.x;
			var dy:Number = e.stageY-mouseDownPoint.y;
			var distance:Number = Math.sqrt(dx*dx + dy*dy);
			if (distance>clickThreshold) {
				e.stopPropagation();
			}
		}
		
		protected var _rendered:Boolean = false;
		public function get rendered():Boolean
		{
			return _rendered;
		}
		public function set rendered(value:Boolean):void
		{
			if (value!=_rendered) {
				_rendered = value;
				for (var i:int=0; i<numChildren; i++) {
					var child:DisplayObject = getChildAt(i);
					child.visible = !_rendered;
				}
				if (_rendered) {
					_bitmap.visible = true;
					_bitmap.alpha = 1;					
				} else {
					_bitmap.visible = false;
					_bitmap.alpha = 0;			
				}
			}
		}

		protected var _bitmap:Bitmap;
		protected var _bitmapData:BitmapData;
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData = value;
		}
		
		public function render():void
		{
			if (!_bitmap) {
				_bitmap = new Bitmap();
			} else {
				removeChild(_bitmap);
			}
			
			if (_bitmapData) {
				_bitmapData.dispose();
			}
			
			_bitmapData = new BitmapData(width*scaleX, height*scaleY);

			var matrix:Matrix = new Matrix();
			matrix.translate(-left, -top);
			matrix.scale(scaleX, scaleY);
			_bitmapData.draw(this, matrix);
			
			_bitmap.bitmapData = _bitmapData;
			_bitmap.x = -left;
			_bitmap.y = top;
			
			addChild(_bitmap);			
		}
	}
}