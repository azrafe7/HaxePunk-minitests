/*
 * Example application to show how to use Ear Clipping to create convex polygons from arbitary concave ones
 * Click to create vertexes. Press any key to clear everything!
 * Make sure you draw in a CCW direction.
 * 
 * Based on JSFL util by mayobutter (Box2D Forums)
 * and Eric Jordan (http://www.ewjordan.com/earClip/) Ear Clipping experiment in Processing
 * 
 * Tarwin Stroh-Spijer - Touch My Pixel - http://www.touchmypixel.com/
 *
 * C# Port by Ben Baker - Headsoft - http://headsoft.com.au/
 *
 * */

package com.touchmypixel.geom;

import flash.geom.Point;

class Polygon
{
	public var pointList:Array<Point> = null;

	public function new(?points:Array<Point> = null)
	{
		this.pointList = points != null ? points : new Array<Point>();
	}

	/*
	 * Assuming the polygon is simple, checks
	 * if it is convex.
	 */
	public function isConvex():Bool
	{
		var isPositive:Bool = false;

		for (i in 0...pointList.length)
		{
			var lower:Int = (i == 0 ? pointList.length - 1 : i - 1);
			var middle:Int = i;
			var upper:Int = (i == pointList.length - 1 ? 0 : i + 1);
			var dx0:Float = pointList[middle].x - pointList[lower].x;
			var dy0:Float = pointList[middle].y - pointList[lower].y;
			var dx1:Float = pointList[upper].x - pointList[middle].x;
			var dy1:Float = pointList[upper].y - pointList[middle].y;
			var cross:Float = dx0 * dy1 - dx1 * dy0;
			//Cross product should have same sign
			//for each vertex if poly is convex.
			var newIsP:Bool = (cross > 0 ? true : false);

			if (i == 0)
				isPositive = newIsP;
			else if (isPositive != newIsP)
				return false;
		}

		return true;
	}

	/*
	 * Tries to add a triangle to the polygon.
	 * Returns null if it can't connect properly.
	 * Assumes bitwise equality of join vertices.
	 */
	public function add(t:Triangle):Polygon
	{
		//First, find vertices that connect
		var firstP:Int = -1;
		var firstT:Int = -1;
		var secondP:Int = -1;
		var secondT:Int = -1;

		for (i in 0...pointList.length)
		{
			if (t.pointList[0].x == this.pointList[i].x && t.pointList[0].y == this.pointList[i].y)
			{
				if (firstP == -1)
				{
					firstP = i; firstT = 0;
				}
				else
				{
					secondP = i; secondT = 0;
				}
			}
			else if (t.pointList[1].x == this.pointList[i].x && t.pointList[1].y == this.pointList[i].y)
			{
				if (firstP == -1)
				{
					firstP = i; firstT = 1;
				}
				else
				{
					secondP = i; secondT = 1;
				}
			}
			else if (t.pointList[2].x == this.pointList[i].x && t.pointList[2].y == this.pointList[i].y)
			{
				if (firstP == -1)
				{
					firstP = i; firstT = 2;
				}
				else
				{
					secondP = i; secondT = 2;
				}
			}
			else
			{
				//println(t.PointList[0].X+" "+t.PointList[0].y+" "+t.PointList[1].X+" "+t.PointList[1].y+" "+t.PointList[2].X+" "+t.PointList[2].y);
				//println(x[0]+" "+y[0]+" "+x[1]+" "+y[1]);
			}
		}

		//Fix ordering if first should be last vertex of poly
		if (firstP == 0 && secondP == pointList.length - 1)
		{
			firstP = pointList.length - 1;
			secondP = 0;
		}

		//Didn't find it
		if (secondP == -1)
			return null;

		//Find tip index on triangle
		var tipT:Int = 0;
		if (tipT == firstT || tipT == secondT) tipT = 1;
		if (tipT == firstT || tipT == secondT) tipT = 2;

		var newPointList:Array<Point> = new Array<Point>();

		for (i in 0...pointList.length)
		{
			newPointList.push(pointList[i]);

			if (i == firstP)
				newPointList.push(t.pointList[tipT]);
		}

		return new Polygon(newPointList);
	}
}
