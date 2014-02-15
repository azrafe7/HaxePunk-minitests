package com.mindrocks.delaunay;



/**
 * ...
 * @author sledorze
 */

class ArrayHelper  {
	
	/*inline public static function filter<T>(v : Array<T>, pred : T -> Bool) : Array<T> {
		var res = new Array<T>();
		for (e in v) {
			if (pred(e))
				res.push(e);
		}
		return res;
	}*/
	
	/**
	 * Empties an array of its' contents
	 * @param array filled array
	 */
	public static inline function clear<T>(array:Array<T>)
	{
#if (cpp || php)
		array.splice(0, array.length);
#else
		untyped array.length = 0;
#end
	}

}