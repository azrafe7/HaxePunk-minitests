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

class Triangulator
{

	/* give it an array of points (vertexes)
	 * returns an array of Triangles
	 * */
	public static function triangulate(v:Array<Point>):Array<Triangle> 
	{
		if (v.length < 3)
			return null;

		var remList:Array<Point> = new Array<Point>();
		for (p in v) remList.push(p.clone());
		
		var retList:Array<Triangle> = new Array<Triangle>();

		while (remList.length > 3)
		{
			var earIndex:Int = -1;

			for (i in 0...remList.length)
			{
				if (isEar(i, remList))
				{
					earIndex = i;
					break;
				}
			}

			if (earIndex == -1)
				return null;

			var newList:Array<Point> = new Array<Point>();
			for (p in remList) newList.push(p.clone());

			newList.splice(earIndex, 1);

			var under:Int = (earIndex == 0 ? remList.length - 1 : earIndex - 1);
			var over:Int = (earIndex == remList.length - 1 ? 0 : earIndex + 1);

			retList.push(new Triangle(remList[earIndex], remList[over], remList[under]));

			remList = newList;
		}

		retList.push(new Triangle(remList[1], remList[2], remList[0]));

		return retList;
	}

	/* takes: array of Triangles 
	 * returns: array of Polygons
	 * */
	public static function polygonizeTriangles(triangulated:Array<Triangle>):Array<Polygon> 
	{
		var polys:Array<Polygon> = new Array<Polygon>();

		if (triangulated == null)
		{
			return null;
		}
		else
		{
			var covered:Array<Bool> = new Array<Bool>();
			for (i in 0...triangulated.length)
			{
				covered[i] = false;
			}

			var notDone:Bool = true;

			while (notDone)
			{
				var poly:Polygon = null;

				var currTri:Int = -1;
				for (i in 0...triangulated.length)
				{
					if (covered[i]) continue;
					currTri = i;
					break;
				}
				if (currTri == -1)
				{
					notDone = false;
				}
				else
				{
					poly = new Polygon(triangulated[currTri].pointList);
					covered[currTri] = true;
					for (i in 0...triangulated.length)
					{
						if (covered[i]) continue;
						var newP:Polygon = poly.add(triangulated[i]);
						if (newP == null) continue;
						if (newP.isConvex())
						{
							poly = newP;
							covered[i] = true;
						}
					}

					polys.push(poly);
				}
			}
		}

		return polys;
	}

	// Checks if vertex i is the tip of an ear
	public static function isEar(i:Int, v:Array<Point>):Bool
	{
		var dx0 = 0., dy0 = 0., dx1 = 0., dy1 = 0.;

		if (i >= v.length || i < 0 || v.length < 3)
			return false;

		var upper:Int = i + 1;
		var lower:Int = i - 1;

		if (i == 0)
		{
			dx0 = v[0].x - v[v.length - 1].x;
			dy0 = v[0].y - v[v.length - 1].y;
			dx1 = v[1].x - v[0].x;
			dy1 = v[1].y - v[0].y;
			lower = v.length - 1;
		}
		else if (i == v.length - 1)
		{
			dx0 = v[i].x - v[i - 1].x;
			dy0 = v[i].y - v[i - 1].y;
			dx1 = v[0].x - v[i].x;
			dy1 = v[0].y - v[i].y;
			upper = 0;
		}
		else
		{
			dx0 = v[i].x - v[i - 1].x;
			dy0 = v[i].y - v[i - 1].y;
			dx1 = v[i + 1].x - v[i].x;
			dy1 = v[i + 1].y - v[i].y;
		}

		var cross:Float = (dx0 * dy1) - (dx1 * dy0);

		if (cross > 0)
			return false;

		var myTri:Triangle = new Triangle(v[i], v[upper], v[lower]);

		for (j in 0...v.length)
		{
			if (!(j == i || j == lower || j == upper))
			{
				if (myTri.isInside(v[j]))
					return false;
			}
		}
		
		return true;
	}
}