 /* 
 * Based on JSFL util by mayobutter (Box2D Forums)
 * and Eric Jordan (http://www.ewjordan.com/earClip/) Ear Clipping experiment in Processing
 * 
 * Tarwin Stroh-Spijer - Touch My Pixel - http://www.touchmypixel.com/
 * */

package com.touchmypixel.geom;

import com.touchmypixel.geom.Polygon;
import flash.geom.Point;


class Triangulator {
	
	/**
	 * Give it an array of points (vertices), returns an array of Triangles.
	 */ 
	public static function triangulate(points:Array<Point>):Array<Triangle>
	{
		var xA = new Array<Float>();
		var yA = new Array<Float>();
		
		for (p in points) {
			xA.push(p.x);
			yA.push(p.y);
		}
		
		return triangulateFromFlatArrays(xA, yA);
	}
	
	/**
	 * Give it x and y arrays of coords, returns an array of Triangles.
	 */ 
	public static function triangulateFromFlatArrays(xv:Array<Float>, yv:Array<Float>):Array<Triangle>
	{
		if (xv.length < 3 || yv.length < 3 || yv.length != xv.length) {
			throw "Both arrays must be of the same length and have at least 3 vertices.";
		}
		
		var i:Int = 0;
		var vNum:Int = xv.length;
	  
		var buffer = new Array<Triangle>();
		var bufferSize:Int = 0;
		var xrem = new Array<Float>();
		var yrem = new Array<Float>();
		
		for (i in 0...vNum) {
			xrem[i] = xv[i];
			yrem[i] = yv[i];
		}

		while (vNum > 3){
			//Find an ear
			var earIndex = -1;
			for (i in 0...vNum) {
				if (isEar(i, xrem, yrem)) {
					earIndex = i;
					break;
				}
			}

			//If we still haven't found an ear, we're screwed.
			//The user did Something Bad, so return null.
			//This will probably crash their program, since
			//they won't bother to check the return value.
			//At this we shall laugh, heartily and with great gusto.
			if (earIndex == -1) {
				trace('No ear found');
				return null;
			}

			//Clip off the ear:
			//  - remove the ear tip from the list

			//Opt note: actually creates a new list, maybe
			//this should be done in-place instead.  A linked
			//list would be even better to avoid array-fu.
			--vNum;
			var newx = new Array<Float>();
			var newy = new Array<Float>();
			var currDest:Int = 0;
			for (i in 0...vNum) {
				if (currDest == earIndex) ++currDest;
				newx[i] = xrem[currDest];
				newy[i] = yrem[currDest];
				++currDest;
			}

			//  - add the clipped triangle to the triangle list
			var under:Int = earIndex == 0 ? xrem.length - 1 : earIndex - 1;
			var over:Int = (earIndex == xrem.length - 1) ? 0 : earIndex + 1;
			var toAdd:Triangle = Triangle.fromFlatArray([xrem[earIndex], yrem[earIndex], xrem[over], yrem[over], xrem[under], yrem[under]]);
			buffer[bufferSize] = toAdd;
			++bufferSize;
				
			//  - replace the old list with the new one
			xrem = newx;
			yrem = newy;
		}
		
		var toAddMore:Triangle = Triangle.fromFlatArray([xrem[1], yrem[1], xrem[2], yrem[2], xrem[0], yrem[0]]);
		buffer[bufferSize] = toAddMore;
		++bufferSize;

		return buffer;
	}
	
	/**
	 * Give it an array of Triangles, returns an array of Polygons.
	 */ 
	public static function polygonizeTriangles(triangulated:Array<Triangle>):Array<Polygon>
	{
		var polys:Array<Polygon>;
		var polyIndex:Int = 0;

		var i:Int = 0;
		
		if (triangulated == null) {
			return null;
		} else {
			polys = new Array<Polygon>();
			var covered = new Array<Bool>();
			
			for (i in 0...triangulated.length) {
				covered[i] = false;
			}

			var notDone:Bool = true;
			while(notDone) {
				var currTri:Int = -1;
				var poly:Polygon = null;
				for (i in 0...triangulated.length) {
					if (covered[i]) continue;
					currTri = i;
					break;
				}
				if (currTri == -1) {
					notDone = false;
				} else {
					poly = new Polygon(triangulated[currTri].points);
					covered[currTri] = true;
					for (i in 0...triangulated.length) {
						if (covered[i]) continue;
						var newP:Polygon = poly.add(triangulated[i]);
						if (newP == null) continue;
						if (newP.isConvex()){
							poly = newP;
							covered[i] = true;
						}
					}
				}
				polys[polyIndex] = poly;
				polyIndex++;
			}
		}
		
		return polys;
	}

	/**
	 * Checks if vertex i is the tip of an ear.
	 */ 
	private static function isEar(i:Int, xv:Array<Float>, yv:Array<Float>):Bool
	{
		var dx0:Float, dy0:Float, dx1:Float, dy1:Float;
		dx0 = dy0 = dx1 = dy1 = 0;
		if (i >= xv.length || i < 0 || xv.length < 3) {
			return false;
		}
		var upper:Int = i + 1;
		var lower:Int = i - 1;
		if (i == 0) {
			dx0 = xv[0] - xv[xv.length - 1];
			dy0 = yv[0] - yv[yv.length - 1];
			dx1 = xv[1] - xv[0];
			dy1 = yv[1] - yv[0];
			lower = xv.length - 1;
		} else if (i == xv.length - 1) {
			dx0 = xv[i] - xv[i - 1];
			dy0 = yv[i] - yv[i - 1];
			dx1 = xv[0] - xv[i];
			dy1 = yv[0] - yv[i];
			upper = 0;
		} else {
			dx0 = xv[i] - xv[i - 1];
			dy0 = yv[i] - yv[i - 1];
			dx1 = xv[i + 1] - xv[i];
			dy1 = yv[i + 1] - yv[i];
		}
		
		var cross:Float = (dx0 * dy1) - (dx1 * dy0);
		if (cross > 0) return false;
		var myTri:Triangle = Triangle.fromFlatArray([xv[i], yv[i], xv[upper], yv[upper], xv[lower], yv[lower]]);

		for (j in 0...xv.length) {
			if (!(j == i || j == lower || j == upper)) {
				_p.setTo(xv[j], yv[j]);
				if (myTri.isPointInside(_p)) return false;
			}
		}
		return true;
	}
	
	private static var _p:Point = new Point();
}
