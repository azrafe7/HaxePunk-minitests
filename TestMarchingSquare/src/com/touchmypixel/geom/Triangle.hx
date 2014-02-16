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

class Triangle
{
	public var pointList:Array<Point> = null;

	public function new(point1:Point, point2:Point, point3:Point)
	{
		var dx1:Float = point2.x - point1.x;
		var dx2:Float = point3.x - point1.x;
		var dy1:Float = point2.y - point1.y;
		var dy2:Float = point3.y - point1.y;
		var cross:Float = (dx1 * dy2) - (dx2 * dy1);

		var ccw:Bool = (cross > 0);

		pointList = new Array<Point>();

		if (ccw)
		{
			pointList.push(new Point(point1.x, point1.y));
			pointList.push(new Point(point2.x, point2.y));
			pointList.push(new Point(point3.x, point3.y));
		}
		else
		{
			pointList.push(new Point(point1.x, point1.y));
			pointList.push(new Point(point3.x, point3.y));
			pointList.push(new Point(point2.x, point2.y));
		}
	}

	public function isInside(point:Point):Bool
	{
		var vx2:Float = point.x - pointList[0].x;
		var vy2:Float = point.y - pointList[0].y;
		var vx1:Float = pointList[1].x - pointList[0].x;
		var vy1:Float = pointList[1].y - pointList[0].y;
		var vx0:Float = pointList[2].x - pointList[0].x;
		var vy0:Float = pointList[2].y - pointList[0].y;

		var dot00:Float = vx0 * vx0 + vy0 * vy0;
		var dot01:Float = vx0 * vx1 + vy0 * vy1;
		var dot02:Float = vx0 * vx2 + vy0 * vy2;
		var dot11:Float = vx1 * vx1 + vy1 * vy1;
		var dot12:Float = vx1 * vx2 + vy1 * vy2;
		var invDenom:Float = 1.0 / (dot00 * dot11 - dot01 * dot01);
		var u:Float = (dot11 * dot02 - dot01 * dot12) * invDenom;
		var v:Float = (dot00 * dot12 - dot01 * dot02) * invDenom;

		return ((u > 0) && (v > 0) && (u + v < 1));
	}
}
