/**
 * Base64
 * Base64 Encoder/Decoder Class
 * 
 * Download: http://as3s.org/uploads/utils/base64.zip
 * 
 * Copyright (c) 2009 Hisato Ogata
 * Licensed under the MIT License
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 * @langversion ActionScript 3.0
 * @playerversion Flash 9
 * 
 * @version 1.00
 * @author Hisato Ogata
 * @see http://as3s.org/
 * 
 * @example usage:
 * <listing version="3.0">
 *  
 *  // Base64 Encode String
 * 	var b64_str:String = Base64.encode("abc");
 *  var b64_str:String = Base64.encode("abc", Endian.LITTLE_ENDIAN);
 * 
 *  // Base64 Encode ByteArray
 *  var ba:ByteArray = new ByteArray();
 *  ba.writeUTFBytes("abc");
 *  var b64_ba:String = Base64.encodeByteArray(ba);
 * 
 *  // Base64 Decode to String
 *  var str:String = Base64.decode(b64_str);
 *  var str:String = Base64.decode(b64_str, Endian.LITTLE_ENDIAN);
 * 
 *  // Base64 Decode to ByteArray
 *  var ba:ByteArray = Base64.decodeToByteArray(b64_ba);
 *  var ba:ByteArray = Base64.decodeToByteArray(b64_ba, Endian.LITTLE_ENDIAN);
 *  
 *  // Set Default Endian
 * 	Base64.defaultEndian = Endian.LITTLE_ENDIAN;
 * 
 * </listing>
 */

package org.as3s.utils {
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class Base64 {
		
		private static const CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
		
		/**
		 * Default Endian 
		 */		
		private static var _defaultEndian:String = Endian.BIG_ENDIAN;
		public static function get defaultEndian():String
		{
			return _defaultEndian;
		}
		public static function set defaultEndian(value:String):void
		{
			_defaultEndian = value;
		}
		
		/**
		 * Encode String 
		 * @param src
		 * @param endian
		 * @return 
		 * 
		 */		
		public static function encode(src:String, endian:String = ""):String {
			var ba:ByteArray = new ByteArray();
			ba.endian = endian=="" ? _defaultEndian : endian;
			ba.writeUTFBytes(src);
			return encodeByteArray(ba);
		}
		
		/**
		 * Encode ByteArray 
		 * @param ba
		 * @return 
		 * 
		 */		
		public static function encodeByteArray(ba:ByteArray):String {
			var output:String = "";
			
			var buf0:Number; var buf1:Number; var buf2:Number;
			var out0:uint; var out1:uint; var out2:uint; var out3:uint;
			
			ba.position = 0;			
			while (ba.bytesAvailable > 0)
			{
				buf0 = ba.readUnsignedByte();
				buf1 = ba.bytesAvailable>0 ? ba.readUnsignedByte() : Number.NaN;
				buf2 = ba.bytesAvailable>0 ? ba.readUnsignedByte() : Number.NaN;
				
				out0 = buf0 >> 2;
				out1 = ((buf0 & 0x03) << 4) | (buf1 >> 4);
				out2 = ((buf1 & 0x0f) << 2) | (buf2 >> 6);
				out3 = buf2 & 0x3f;
				
				if (isNaN(buf1)) out2 = 64;
				if (isNaN(buf2)) out3 = 64;
				
				output += CHARS.charAt(out0) + CHARS.charAt(out1) + CHARS.charAt(out2) + CHARS.charAt(out3);
			}
			
			return output;
		}
		
		/**
		 * Decode to String 
		 * @param src
		 * @param endian
		 * @return 
		 * 
		 */		
		public static function decode(src:String, endian:String = Endian.LITTLE_ENDIAN):String {
			var bytes:ByteArray = decodeToByteArray(src, endian);
			return bytes.readUTFBytes(bytes.length);
		}
		
		/**
		 * Decode to ByteArray 
		 * @param src
		 * @param endian
		 * @return 
		 * 
		 */		
		public static function decodeToByteArray(src:String, endian:String = ""):ByteArray
		{
			src = src.split("\r\n").join("");
			
			var ba:ByteArray = new ByteArray();
			ba.endian = endian=="" ? _defaultEndian : endian;
			
			var buf0:uint; var buf1:uint; var buf2:uint; var buf3:uint;
			var out0:uint; var out1:uint; var out2:uint;
			
			var i:int = 0;
			var size:int = src.length;
			while (i < size)
			{
				buf0 = CHARS.indexOf(src.charAt(i++));
				buf1 = CHARS.indexOf(src.charAt(i++));
				buf2 = CHARS.indexOf(src.charAt(i++));
				buf3 = CHARS.indexOf(src.charAt(i++));
				
				out0 = (buf0 << 2) | (buf1 >> 4);
				out1 = ((buf1 & 0x0f) << 4) | (buf2 >> 2);
				out2 = ((buf2 & 0x03) << 6) | buf3;
				
				if (buf1!=64) ba.writeByte(out0);
				if (buf2!=64) ba.writeByte(out1);
				if (buf3!=64) ba.writeByte(out2);
			}
			
			ba.position = 0;			
			return ba;
		}
		
		public function Base64() {
		}
	}
}
