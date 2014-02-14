package ;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.ByteArray;


enum StepDirection {
	None;
	Up;
	Left;
	Down;
	Right;
}


/**
 * Marching Sqaures implementation
 * 
 * @see http://devblog.phillipspiess.com/2010/02/23/better-know-an-algorithm-1-marching-squares/
 * 
 * @author azrafe7
 */
class MarchingSquares
{
	static private var ZERO:Point = new Point();
	
	public var alphaThreshold:Int = 1;

	private var prevStep:StepDirection = None;
	private var nextStep:StepDirection = None;
	
	private var bmd:BitmapData = null;
	private var width:Int;
	private var height:Int;
	private var byteArray:ByteArray;
	
	private var point:Point = new Point();

	
	public function new(bmd:BitmapData, alphaThreshold:Int = 1)
	{
		source = bmd;
		
		this.alphaThreshold = alphaThreshold;
	}
	
	public var source(default, set):BitmapData;
	private function set_source(value:BitmapData):BitmapData 
	{
		if (bmd != value) {
			bmd = value;
			byteArray = bmd.getPixels(bmd.rect);
			width = bmd.width;
			height = bmd.height;
		}
		return bmd;
	}
	
	public function march():Array<Point> 
	{
		findStartPoint();
		
		return walkPerimeter(Std.int(point.x), Std.int(point.y));
	}
	
	public function findStartPoint():Point {
		// Scan along the whole image
		byteArray.position = 0;
		point.setTo(0, 0);
		
		for (idx in 0...byteArray.length >> 2)
		{
			var alphaIdx:Int = idx << 2;
			if (byteArray[alphaIdx] >= alphaThreshold) {
				point.setTo(idx % width, idx / height);
				break;
			}
		}
		
		return point;
 	}
	
	public function walkPerimeter(startX:Int, startY:Int):Array<Point> 
	{
		// Do some sanity checking, so we aren't
		// walking outside the image
		if (startX < 0) startX = 0;
		if (startX > width) startX = width;
		if (startY < 0) startY = 0;
		if (startY > height) startY = height;

		// Set up our return list
		var pointList = new Array<Point>();

		// Our current x and y positions, initialized
		// to the init values passed in
		var x:Int = startX;
		var y:Int = startY;

		// The main while loop, continues stepping until
		// we return to our initial points
		do {
			// Evaluate our state, and set up our next direction
			step(x, y);

			// If our current point is within our image
			// add it to the list of points
			if (x >= 0 && x < width && y >= 0 && y < height) pointList.push(new Point(x, y));

			switch (nextStep)
			{
				case StepDirection.Up:    y--; 
				case StepDirection.Left:  x--; 
				case StepDirection.Down:  y++; 
				case StepDirection.Right: x++; 
				default:
			}
		} while (x != startX || y != startY);

		return pointList;
	}
	
	public function step(x:Int, y:Int):Void 
	{
		var upLeft = isPixelSolid(x - 1, y - 1);
		var upRight = isPixelSolid(x, y - 1);
		var downLeft = isPixelSolid(x - 1, y);
		var downRight = isPixelSolid(x, y);
		
		// Store our previous step
		prevStep = nextStep;

		// Determine which state we are in
		var state:Int = 0;

		if (upLeft) state |= 1;
		if (upRight) state |= 2;
		if (downLeft) state |= 4;
		if (downRight) state |= 8;

		// State now contains a number between 0 and 15
		// representing our state.
		// In binary, it looks like 0000-1111 (in binary)

		// An example. Let's say the top two pixels are filled,
		// and the bottom two are empty.
		// Stepping through the if statements above with a state
		// of 0b0000 initially produces:
		// Upper Left == true ==>  0b0001
		// Upper Right == true ==> 0b0011
		// The others are false, so 0b0011 is our state
		// (That's 3 in decimal.)

		// Looking at the chart above, we see that state
		// corresponds to a move right, so in our switch statement
		// below, we add a case for 3, and assign Right as the
		// direction of the next step. We repeat this process
		// for all 16 states.

		// So we can use a switch statement to determine our
		// next direction based on
		switch (state)
		{
			case 1, 5, 13: 
				nextStep = StepDirection.Up;
			case 2, 3, 7: 
				nextStep = StepDirection.Right;
			case 4, 12, 14: 
				nextStep = StepDirection.Left;
			case 6:
				if (prevStep== StepDirection.Up) nextStep = StepDirection.Left;
				else nextStep = StepDirection.Right;
			case 8, 10, 11: 
				nextStep = StepDirection.Down;
			case 9:
				if (prevStep== StepDirection.Right) nextStep = StepDirection.Up;
				else nextStep = StepDirection.Down;
			default: nextStep = StepDirection.None;
		}
	}
	
	inline public function isPixelSolid(x:Int, y:Int):Bool {
		return (x >= 0 && y >= 0 && x < width && y < height && (byteArray[(y * width + x) << 2] >= alphaThreshold));
	}
	
	
	
	/**
	 * Simplify polyline using Ramer-Douglas-Peucker algorithm
	 * 
	 * @see http://karthaus.nl/rdp/
	 */
	static public function simplify(points:Array<Point>, epsilon:Float = 1):Array<Point> 
	{
		var firstPoint = points[0];
		var lastPoint = points[points.length-1];
		
		if (points.length < 3) {
			return points;
		}
		
		var index = -1;
		var dist = 0.;
		for (i in 1...points.length-1) {
			var cDist = perpendicularDistance(points[i], firstPoint, lastPoint);
			if (cDist > dist){
				dist = cDist;
				index = i;
			}
		}
		if (dist > epsilon){
			// iterate
			var l1 = points.slice(0, index + 1);
			var l2 = points.slice(index);
			var r1 = simplify(l1, epsilon);
			var r2 = simplify(l2, epsilon);
			// concat r2 to r1 minus the end/startpoint that will be the same
			var rs = r1.slice(0, r1.length - 1).concat(r2);
			return rs;
		} else {
			return [firstPoint, lastPoint];
		}
	}
	
	/**
	 * Works better than Karthaus version (which failed on a circle).
	 * 
	 * @see http://wonderfl.net/c/nOo3
	 */
	static public function perpendicularDistance(point:Point, point1:Point, point2:Point):Float
	{
		//Area = |(1/2)(x1y2 + x2y3 + x3y1 - x2y1 - x3y2 - x1y3)|   *Area of triangle
		//Base = v((x1-x2)²+(x1-x2)²)                               *Base of Triangle*
		//Area = .5*Base*H                                          *Solve for height
		//Height = Area/.5/Base

		var area:Float = Math.abs(.5 * (point1.x * point2.y + point2.x * point.y + point.x * point1.y - point2.x * point1.y - point.x * point2.y - point1.x * point.y));
		var bottom:Float = Math.sqrt(Math.pow(point1.x - point2.x, 2) + Math.pow(point1.y - point2.y, 2));
		var height:Float = area / bottom * 2;

		return height;
	}
		
	static public function findPerpendicularDistance(p:Point, p1:Point, p2:Point):Float {
		// if start and end point are on the same x the distance is the difference in X.
		var result:Float;
		var slope:Float;
		var intercept:Float;
		
		if (p1.x == p2.y) {
			result = Math.abs(p.x - p1.x);
		}else{
			slope = (p2.y - p1.y) / (p2.x - p1.x);
			intercept = p1.y - (slope * p1.x);
			result = Math.abs(slope * p.x - p.y + intercept) / Math.sqrt(Math.pow(slope, 2) + 1);
		}
	   
		return result;
	}		
}