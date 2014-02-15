 /* 
 * Based on JSFL util by mayobutter (Box2D Forums)
 * and  Eric Jordan (http://www.ewjordan.com/earClip/) Ear Clipping experiment in Processing
 * 
 * Tarwin Stroh-Spijer - Touch My Pixel - http://www.touchmypixel.com/
 * */

package com.touchmypixel.geom;

import flash.geom.Point;

	
class Triangle {
	
	public var points(default, null):Array<Point>;
	
	public function new(points:Array<Point>) {
	  
		if (points.length != 3) throw "Triangle must have exactly 3 points.";
		this.points = points; 
		
		var x1 = points[0].x;
		var y1 = points[0].y;
		var x2 = points[1].x;
		var y2 = points[1].y;
		var x3 = points[2].x;
		var y3 = points[2].y;		
		
		var dx1:Float = x2 - x1;
		var dx2:Float = x3 - x1;
		var dy1:Float = y2 - y1;
		var dy2:Float = y3 - y1;
		var cross:Float = (dx1 * dy2) - (dx2 * dy1);
		var ccw:Bool = cross > 0;
		
		if (!ccw) {	// swap 2nd with 3rd
			points[1].setTo(x3, y3);
			points[2].setTo(x2, y2);
		}			
	}
	
	public static function fromFlatArray(array:Array<Float>):Triangle {
		var _points = new Array<Point>();
		
		for (i in 0...array.length >> 1) {
			_points.push(new Point(array[i], array[i + 1]));
		}
		
		return new Triangle(_points);
	}
	
	public function isPointInside(p:Point) {
		var vx2:Float = p.x - points[0].x; 		   var vy2 = p.y - points[0].y;
		var vx1:Float = points[1].x - points[0].x; var vy1 = points[1].y - points[0].y;
		var vx0:Float = points[2].x - points[0].x; var vy0 = points[2].y - points[0].y;
		
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