package org.as3s.ui
{
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	
	import org.as3s.tween.Tween;

	public class ScrollView extends View
	{
		private var _scrollEnabled:Boolean = true;
		public function get scrollEnabled():Boolean
		{
			return _scrollEnabled;
		}
		public function set scrollEnabled(value:Boolean):void
		{
			_scrollEnabled = value;
		}
		
		
//		private var zoomTimer:Timer;
		private var zooming:Boolean = false;
		private var deltaZoom:Number = 0;
		
		private var _maxZoom:Number = 2.5;
		public function get maxZoom():Number
		{
			return _maxZoom;
		}
		public function set maxZoom(value:Number):void
		{
			_maxZoom = value;
		}

		private var _minZoom:Number = 0.5;
		public function get minZoom():Number
		{
			return _minZoom;
		}
		public function set minZoom(value:Number):void
		{
			_minZoom = value;
		}
		
		private var _zoom:Number = 1.0;
		public function get zoom():Number
		{
			return _zoom;
		}
		public function set zoom(value:Number):void
		{
			if (value!=_zoom) {
				_zoom = zoom;
				
//				if (!zooming) {
//					zooming = true;
//				}
//				zoomTimer.reset();
//				zoomTimer.start();
				
				_zoom = value>maxZoom ? maxZoom : value<minZoom ? minZoom : value;
												
				// update
				super.scaleX = _zoom;
				super.scaleY = super.scaleX;
				super.x = _x - _scrollX*zoom;
				super.y = _y - _scrollY*zoom;
				
				drawMask();
				drawBackground();
			}
		}
		
		public static const MOUSEWHEEL_NONE:uint = 0;
		public static const MOUSEWHEEL_ZOOM:uint = 1;
		public static const MOUSEWHEEL_VERTICAL:uint = 2;
		public static const MOUSEWHEEL_HORIZONTAL:uint = 3;
		
		private var _mouseWheel:uint = 0;
		public function get mouseWheel():uint
		{
			return _mouseWheel;
		}
		public function set mouseWheel(value:uint):void
		{
			_mouseWheel = value;
			if (stage!=null) {
				if (value>0) {
					stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				} else {
					stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				}
			}
		}
		
		private var _scrollX:Number = 0;
		public function get scrollX():Number
		{
			return _scrollX;
		}
		public function set scrollX(value:Number):void
		{
			if (!scrollEnabled) return;
			
			if (value!=_scrollX) {
				_scrollX = value;
				super.x = _x - _scrollX*zoom;
				drawMask();
				drawBackground();
			}
		}
		
		private var _scrollY:Number = 0;
		public function get scrollY():Number
		{
			return _scrollY;
		}
		public function set scrollY(value:Number):void
		{
			if (!scrollEnabled) return;
			
			if (value!=_scrollY) {
				_scrollY = value;
				super.y = _y - _scrollY*zoom;
				drawMask();
				drawBackground();
			}
		}
		
		private var _contentWidth:Number = 0;
		public function get contentWidth():Number
		{
			return _contentWidth;
		}
		public function set contentWidth(value:Number):void
		{
			_contentWidth = value;
		}

		private var _contentHeight:Number = 0;
		public function get contentHeight():Number
		{
			return _contentHeight;
		}
		public function set contentHeight(value:Number):void
		{
			_contentHeight = value;
		}

		
		private var _x:Number = 0;
		public override function get x():Number
		{
			return _x;
		}
		public override function set x(value:Number):void
		{
			_x = value;
			super.x = _x - _scrollX;
		}
				
		private var _y:Number = 0;
		public override function get y():Number
		{
			return _y;
		}
		public override function set y(value:Number):void
		{
			_y = value;
			super.y = _y - _scrollY;
		}
		
		private var _lockVertical:Boolean = true;
		public function get lockVertical():Boolean
		{
			return _lockVertical;
		}
		public function set lockVertical(value:Boolean):void
		{
			_lockVertical = value;
		}
		
		private var _lockHorizontal:Boolean = true;
		public function get lockHorizontal():Boolean
		{
			return _lockHorizontal;
		}
		public function set lockHorizontal(value:Boolean):void
		{
			_lockHorizontal = value;
		}
		
		private var _bounceVertical:Boolean = true;
		public function get bounceVertical():Boolean
		{
			return _bounceVertical;
		}
		public function set bounceVertical(value:Boolean):void
		{
			_bounceVertical = value;
		}

		private var _bounceHorizontal:Boolean = true;
		public function get bounceHorizontal():Boolean
		{
			return _bounceHorizontal;
		}
		public function set bounceHorizontal(value:Boolean):void
		{
			_bounceHorizontal = value;
		}
		
		private var zoomTween:Tween;
		
		public static const ZOOM:String = "zoom";
		
		public function ScrollView(width:Number=0, height:Number=0, left:Number=0, top:Number=0)
		{
			super(width, height, left, top);
			
//			zoomTimer = new Timer(100, 1);
//			zoomTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onZoomTimer);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
//			addEventListener(Event.ENTER_FRAME, ease);

			userInteractionEnabled = true;
		}
		
		private function onAddedToStage(e:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownStage);
			if (_mouseWheel>0) {
				stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownStage);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
//		private function ease(e:Event):void
//		{
//			super.y = super.y + (_y - _scrollY*zoom - super.y)*0.8;
//
//		}
		
		private var maxDelta:Number = 0.5;
		private function onMouseWheel(e:MouseEvent):void
		{
			var delta:Number = 0;
			if (Capabilities.os.substring(0,3) == "Mac") {
				delta = e.delta;
			} else {
				if (e.delta>0) delta = 100.0;
				else if (e.delta<0) delta = -100.0;
			}
			
			if (mouseWheel==MOUSEWHEEL_ZOOM) {
				deltaZoom = e.delta*0.01;
				deltaZoom = deltaZoom>maxDelta ? maxDelta : deltaZoom<-maxDelta ? -maxDelta : deltaZoom;
				
				var prevZoom:Number = zoom;
				
				zoom += deltaZoom;
				
				scrollX += (mouseX-scrollX)*(zoom-prevZoom)/prevZoom;
				scrollY += (mouseY-scrollY)*(zoom-prevZoom)/prevZoom;
			} else if (mouseWheel==MOUSEWHEEL_HORIZONTAL) {
				scrollX -= delta;
			} else if (mouseWheel==MOUSEWHEEL_VERTICAL) {
				scrollY -= delta;
				bounce();
			}
			
			addEventListener(Event.ENTER_FRAME, checkBounce);
		}
		
		private var zoomX:Number = 0;
		private var zoomY:Number = 0;
		public function zoomTo(x:Number, y:Number, zoom:Number=NaN, animated:Boolean=true):void
		{
			zoomX = x;
			zoomY = y;
			if (animated) {
				if (zoomTween!=null) {
					stopZoom();
				}
				zoomTween = new Tween(this, {zoom:zoom, scrollX:x - (width/zoom)/2, scrollY:y - (height/zoom)/2});
				zoomTween.addEventListener(Event.COMPLETE, onZoomTween);
				zoomTween.execute();
//				tween.zoom = zoom;
//				tween.scrollX = x - (width/zoom)/2;
//				tween.scrollY = y - (height/zoom)/2;
//				tween.addEventListener("zoom", function(e:Event):void {
//					e.currentTarget.removeEventListener(e.type, arguments.callee);
//					dispatchEvent(new Event(ZOOM));
//				});
			} else {
				this.zoom = zoom;
				scrollX = x - (width/zoom)/2;
				scrollY = y - (height/zoom)/2;
				dispatchEvent(new Event(ZOOM));
			}
		}
		
		public function zoomToCenter(zoom:Number=NaN, animated:Boolean=true):void
		{
			zoom = zoom>maxZoom ? maxZoom : zoom<minZoom ? minZoom : zoom;
			var centerX:Number = scrollX+width/this.zoom/2;
			var centerY:Number = scrollY+height/this.zoom/2;
			var _scrollX:Number = centerX-(width/zoom/2);
			var _scrollY:Number = centerY-(height/zoom/2);
			
			if (animated) {
				if (zoomTween!=null) {
					stopZoom();
				}
				zoomTween = new Tween(this, {zoom:zoom, scrollX:_scrollX, scrollY:_scrollY});
				zoomTween.addEventListener(Event.COMPLETE, onZoomTween);
				zoomTween.execute();
//				tween.zoom = zoom;
//				tween.scrollX = _scrollX;
//				tween.scrollY = _scrollY;
//				tween.addEventListener("zoom", function(e:Event):void {
//					e.currentTarget.removeEventListener(e.type, arguments.callee);
//					dispatchEvent(new Event(ZOOM));
//				});
			} else {
				this.zoom = zoom;
				scrollX = _scrollX;
				scrollY = _scrollY;
				dispatchEvent(new Event(ZOOM));
			}
		}
		
		public function onZoomTween(e:Event):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			dispatchEvent(new Event(ZOOM));
			zoomTween = null;
		}
				
		public function stopZoom():void
		{
			if (zoomTween!=null) {
				zoomTween.reset();
				zoomTween.removeEventListener(Event.COMPLETE, onZoomTween);
				zoomTween = null;
			}
		}
		
//		private function onZoomTimer(e:TimerEvent):void
//		{
//			zooming = false;
//			dispatchEvent(new Event(ZOOM));
//		}
		
		private var _mouseX:Number = 0;
		private var _mouseY:Number = 0;
		private var _mouseDeltaX:Number = 0;
		private var _mouseDeltaY:Number = 0;

		protected  function onMouseDownStage(e:MouseEvent):void
		{
			if (!userInteractionEnabled) return;
			if (parent.mouseX<x || parent.mouseX>x+width || parent.mouseY<y || parent.mouseY>y+height) return;

			_mouseX = parent.mouseX;
			_mouseY = parent.mouseY;
			
			addEventListener(Event.ENTER_FRAME, drag);
			addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				removeEventListener(Event.ENTER_FRAME, checkBounce);
			});
			stage.addEventListener(MouseEvent.MOUSE_UP, function(e:Event):void {
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				removeEventListener(Event.ENTER_FRAME, drag);
				bounce();
			});
		}
		
		private function drag(e:Event):void
		{
			_mouseDeltaX = parent.mouseX - _mouseX;
			_mouseDeltaY = parent.mouseY - _mouseY;
			_mouseX = parent.mouseX;
			_mouseY = parent.mouseY;
			scrollX -= _mouseDeltaX/zoom;
			if (!bounceHorizontal && lockHorizontal) {
				if (scrollX<0) scrollX = 0;
				else if (scrollX>contentWidth-width) scrollX = contentWidth-width;
			}
			scrollY -= _mouseDeltaY/zoom;
			if (!bounceVertical && lockVertical) {
				if (scrollY<0) scrollY = 0;
				else if (scrollY>contentHeight-height) scrollY = contentHeight-height;
			}
		}
		
		public function bounce():void
		{
			addEventListener(Event.ENTER_FRAME, checkBounce);
		}
		
		private var deltaThreshold:Number = 0.1;
		private function checkBounce(e:Event):void
		{
			if (mousePressed) return;
			
			var l:Number = left/zoom+scrollX;
			var w:Number = width/zoom;
			var marginLeft:Number = 0-l;
			var marginRight:Number = (l+w)-contentWidth;
			if (marginLeft>0 && marginRight>0) {
				_mouseDeltaX = ((marginLeft+marginRight)/2-marginLeft)*0.1;
			} else if (marginLeft>0) {
				_mouseDeltaX = -marginLeft*0.1;
			} else if (marginRight>0) {
				_mouseDeltaX = marginRight*0.1;
			}
			
			var t:Number = top/zoom+scrollY;
			var h:Number = height/zoom;
			var marginTop:Number = 0-t;
			var marginBottom:Number = (t+h)-contentHeight;
			if (marginTop>0 && marginBottom>0) {
				_mouseDeltaY = ((marginTop+marginBottom)/2-marginTop)*0.1;
			} else if (marginTop>0) {
				_mouseDeltaY = -marginTop*0.1;
			} else if (marginBottom>0) {
				_mouseDeltaY = marginBottom*0.1;
			}
			
			if (_mouseDeltaX>-deltaThreshold && _mouseDeltaX<deltaThreshold && _mouseDeltaY>-deltaThreshold && _mouseDeltaY<deltaThreshold) {
				removeEventListener(Event.ENTER_FRAME, checkBounce);
			} else {
				_mouseDeltaX *=0.95;
				_mouseDeltaY *=0.95;		
			}
			if (lockHorizontal) {
				scrollX -= _mouseDeltaX;
				if (!bounceHorizontal) {
					if (scrollX<0) scrollX = 0;
					else if (scrollX>contentWidth-width) scrollX = contentWidth-width;
				}
			}
			if (lockVertical) {
				scrollY -= _mouseDeltaY;
				if (!bounceVertical) {
					if (scrollY<0) scrollY = 0;
					else if (scrollY>contentHeight-height) scrollY = contentHeight-height;
				}
			}
		}
		
		protected override function drawMask():void
		{
			if (_maskEnabled) {
				_mask.graphics.clear();
				_mask.graphics.beginFill(0x000000);
				_mask.graphics.drawRect(left/zoom+scrollX, top/zoom+scrollY, width/zoom, height/zoom);
				_mask.graphics.endFill();
			}
		}
		
		protected override function drawBackground():void
		{
			if (_backgroundEnabled) {
				graphics.clear();
				graphics.beginFill(_backgroundColor, _backgroundAlpha);
				graphics.drawRect(left/zoom+scrollX, top/zoom+scrollY, width/zoom, height/zoom);
				graphics.endFill();
			}
		}
	}
}
