 /* 
 * Based on JSFL util by mayobutter (Box2D Forums)
 * and  Eric Jordan (http://www.ewjordan.com/earClip/) Ear Clipping experiment in Processing
 * 
 * Tarwin Stroh-Spijer - Touch My Pixel - http://www.touchmypixel.com/
 * */

package com.touchmypixel.geom;

import flash.geom.Point;


class Polygon {
	
	public var points(default, null):Array<Point>;
	
	public function new(points:Array<Point>)
	{
		this.points = points;
	}

	public function set(poly:Polygon)
	{
		points = new Array<Point>();
		for (p in poly.points) points.push(p.clone());
	}
	
	/*
	 * Assuming the polygon is simple, checks
	 * if it is convex.
	 */
	public function isConvex():Bool
	{
		var isPositive:Bool = false;
		var nVertices:Int = points.length;
		
		for (i in 0...nVertices) {
			var lower:Int = (i == 0 ? nVertices - 1 : i - 1);
			var middle:Int = i;
			var upper:Int = (i == nVertices - 1 ? 0 : i + 1);
			var dx0:Float = points[middle].x - points[lower].x;
			var dy0:Float = points[middle].y - points[lower].y;
			var dx1:Float = points[upper].x - points[middle].x;
			var dy1:Float = points[upper].y - points[middle].y;
			var cross:Float = dx0 * dy1 - dx1 * dy0;
			//Cross product should have same sign
			//for each vertex if poly is convex.
			var newIsP:Bool = cross > 0;
			if (i == 0) {
				isPositive = newIsP;
			} else if (isPositive != newIsP) {
				return false;
			}
		}
		return true;
	}

	/*
	 * Tries to add a triangle to the polygon.
	 * Returns null if it can't connect properly.
	 * Assumes bitwise equality of join vertices.
	 */
	public function add(tri:Triangle):Polygon
	{
		var triPoints = tri.points;
		
		//First, find vertices that connect
		var firstP:Int = -1; 
		var firstT:Int = -1;
		var secondP:Int = -1; 
		var secondT:Int = -1;
		
		var i:Int = 0;
		var nVertices = points.length;
		
		for (i in 0...nVertices) {
			if (triPoints[0].x == points[i].x && triPoints[0].y == points[i].y) {
				if (firstP == -1) {
					firstP = i; firstT = 0;
				} else {
					secondP = i; secondT = 0;
				}
			} else if (triPoints[1].x == points[i].x && triPoints[1].y == points[i].y) {
				if (firstP == -1) {
					firstP = i; firstT = 1;
				} else{
					secondP = i; secondT = 1;
				}
			} else if (triPoints[2].x == points[i].x && triPoints[2].y == triPoints[i].y) {
				if (firstP == -1) {
					firstP = i; firstT = 2;
				} else{
					secondP = i; secondT = 2;
				}
			} else {
				//prIntln(t.x[0]+" "+t.y[0]+" "+t.x[1]+" "+t.y[1]+" "+t.x[2]+" "+t.y[2]);
				//prIntln(x[0]+" "+y[0]+" "+x[1]+" "+y[1]);
			}
		}
		
		//Fix ordering if first should be last vertex of poly
		if (firstP == 0 && secondP == nVertices - 1) {
			firstP = nVertices - 1;
			secondP = 0;
		}
		
		//Didn't find it
		if (secondP == -1) return null;
		
		//Find tip index on triangle
		var tipT:Int = 0;
		if (tipT == firstT || tipT == secondT) tipT = 1;
		if (tipT == firstT || tipT == secondT) tipT = 2;
		
		var newPoints = new Array<Point>();
		var currOut = 0;
		
		for (i in 0...nVertices) {
			newPoints[currOut] = points[i];
			if (i == firstP) {
				++currOut;
				newPoints[currOut] = triPoints[tipT];
			}
			++currOut;
		}
		
		return new Polygon(newPoints);
	}
}