package org.as3s.utils
{
	public dynamic class List extends Array
	{		
		
		public function List(...args)
		{
			var n:uint = args.length;
			if (n==1 && (args[0] is Number)) {
				var dlen:Number = args[0];
				var ulen:uint = dlen;
				if (ulen != dlen) {
					throw new RangeError("List index is not a 32-bit unsigned integer ("+dlen+")");
				}
				length = ulen;
			}
			else {
				length = n;
				for (var i:int=0; i<n; i++) {
					this[i] = args[i];
				}
			}
		}
		
		public function add(item:*):void
		{
			if (contains(item)) {
				remove(item);
			}
			push(item);
		}
		
		public function remove(item:*):void
		{
			var index:int = indexOf(item);
			if (index>=0) {
				splice(index, 1);
			}
		}
		
		public function contains(item:*):Boolean
		{
			return indexOf(item)>=0;
		}
	}
}