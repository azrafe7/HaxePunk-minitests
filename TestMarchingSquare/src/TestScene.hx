package;

import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Masklist;
import com.haxepunk.masks.Polygon;
import com.haxepunk.Scene;
import com.haxepunk.utils.Draw;
import com.nodename.delaunay.Voronoi;
import com.nodename.geom.LineSegment;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.system.System;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.World;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;
import nape.geom.Vec2;

import MarchingSquares;
import com.touchmypixel.geom.Triangulator;


/**
 * ...
 * @author azrafe7
 */
class TestScene extends Scene
{
	var cursor:Entity;
	var segments:Array<LineSegment>;
	var invertedBMD:BitmapData;
	var marchingSquaresBMD:flash.display.BitmapData;
	var decomposedList:GeomPolyList;
	var decomposedPolys:Array<Polygon>;
	
	public var BMD:String = "assets/pirate_small.png";
	public var OBSTACLE:String = "assets/obstacle.png";
	
	
	public var bmd:BitmapData;
	public var image:Image;
	public var entity:Entity;
	
	public var poly:Array<Point>;
	public var simplifiedPoly:Array<Point>;
	public var triangulatedPoly:Array<com.touchmypixel.geom.Triangle>;
	public var convexPolys:Array<com.touchmypixel.geom.Polygon>;
	
	public var MarchingSquaresText:Text;
	public var RDPText:Text;
	public var DelaunayText:Text;
	public var DecompositionText:Text;
	public var TrianglesText:Text;
	public var ConvexText:Text;
	
	public function new() 
	{
		super();
	}
	
	override public function begin():Void {
		
		bmd = HXP.getBitmap(BMD);
		//bmd = new BitmapData(60, 60); // test with a rectangle
		//bmd = HXP.getBitmap(OBSTACLE); // test with a circle
		image = new Image(bmd);
		
		entity = addGraphic(image, 0, 5, 70);
		
		
		// Marching Squares
		
		var alphaThreshold:Int = 1;
		var marchingSquares = new MarchingSquares(bmd, alphaThreshold);
		marchingSquaresBMD = bmd.clone();
		marchingSquaresBMD.fillRect(marchingSquaresBMD.rect, 0);
		//var marchingSquaresImage:Image = new Image

		poly = marchingSquares.march();
		for (i in 1...poly.length) {
			var p1 = poly[i - 1];
			var p2 = poly[i];
			
			Draw.setTarget(marchingSquaresBMD);
			Draw.linePlus(Std.int(p1.x), Std.int(p1.y), Std.int(p2.x), Std.int(p2.y), 0xFF0000, .9);
		}
		
		trace(poly.length);
		
		
		// Ramer-Douglas-Peucker
		
		simplifiedPoly = new Array<Point>();
		for (p in poly) simplifiedPoly.push(new Point(p.x, p.y));
		
		simplifiedPoly = RamerDouglasPeucker.simplify(simplifiedPoly, 1.5);
		simplifiedPoly = RamerDouglasPeucker.simplify(simplifiedPoly, 1.5);
		trace(simplifiedPoly.length);
		
		
		// Delauney triangulation (convex poly)
		
		var voronoi:Voronoi = new Voronoi(simplifiedPoly, null, bmd.rect);
		invertedBMD = bmd.clone();
		invertedBMD.threshold(invertedBMD, invertedBMD.rect, new Point(), "<", alphaThreshold << 24, 0xFFFFFFFF); 
		invertedBMD.threshold(bmd, bmd.rect, new Point(), ">=", alphaThreshold << 24, 0); 
		segments = voronoi.delaunayTriangulation();
		
		
		// Convex decomposition
		triangulatedPoly = Triangulator.triangulate(simplifiedPoly);
		convexPolys = Triangulator.polygonizeTriangles(triangulatedPoly);
		
		var vec2array:Array<Vec2> = [];
		for (p in simplifiedPoly) vec2array.push(Vec2.fromPoint(p));
		var geomPoly:GeomPoly = new GeomPoly(vec2array);
		trace("ccw:" + !geomPoly.isClockwise());
		
		decomposedList = geomPoly.convexDecomposition();
		
		decomposedPolys = new Array<Polygon>();
		
		for (poly in decomposedList) {
			var points:Array<Point> = new Array<Point>();
			for (p in poly) {
				points.push(new Point(p.x, p.y));
			}
			decomposedPolys.push(new Polygon(points));
		}

		
		// Texts
		
		addGraphic(MarchingSquaresText = new Text("msquares\n" + poly.length + "\npts", entity.x + image.width + image.width / 2, entity.y - 30, 0, 0, { size:8, align:TextFormatAlignType.CENTER } ));
		addGraphic(RDPText = new Text("rdp\n" + simplifiedPoly.length + "\npts", entity.x + image.width * 2 + image.width / 2, entity.y - 30, 0, 0, { size:8, align:TextFormatAlignType.CENTER } ));
		addGraphic(DelaunayText = new Text("delaunay\n" + voronoi.circles().length + "\ntris", entity.x + image.width * 3 + image.width / 2, entity.y - 30, 0, 0, { size:8, align:TextFormatAlignType.CENTER } ));
		addGraphic(DecompositionText = new Text("nape\n" + decomposedPolys.length + "\npolys", entity.x + image.width * 4 + image.width / 2, entity.y - 30, 0, 0, { size:8, align:TextFormatAlignType.CENTER } ));
		addGraphic(TrianglesText = new Text("box2d\n" + triangulatedPoly.length + "\ntris", entity.x + image.width * 5 + image.width / 2, entity.y - 30, 0, 0, { size:8, align:TextFormatAlignType.CENTER } ));
		addGraphic(ConvexText = new Text("box2d\n" + convexPolys.length + "\npolys", entity.x + image.width * 6 + image.width / 2, entity.y - 30, 0, 0, { size:8, align:TextFormatAlignType.CENTER } ));

		
		// Mask & Cursor
		
		entity.mask = new Masklist(decomposedPolys);
		image.angle = 0;
		for (poly in decomposedPolys) {
			poly.angle = image.angle;
		}
		entity.setHitbox(bmd.width, bmd.height);
		
		cursor = addGraphic(Image.createCircle(5, 0x00FF00));
		cursor.setHitbox(10, 10);
		
	}
	
	override public function update():Void 
	{
		super.update();

		cursor.x = Input.mouseX;
		cursor.y = Input.mouseY;
		
		if (entity.collideWith(cursor, entity.x, entity.y) != null) image.color = 0xFF0000;
		else image.color = 0xFFFFFF;
	}
	
	override public function render():Void 
	{
		super.render();

		var x = entity.x + image.width;
		var y = entity.y;
		
		var mtx:Matrix = new Matrix(1, 0, 0, 1, x, y);
		HXP.buffer.draw(marchingSquaresBMD, mtx);
		
		x += image.width;
		for (i in 1...simplifiedPoly.length) {
			var p1 = simplifiedPoly[i - 1];
			var p2 = simplifiedPoly[i];
			
			Draw.linePlus(Std.int(p1.x + x), Std.int(p1.y + y), Std.int(p2.x + x), Std.int(p2.y + y), 0xFF0000, .9);
			Draw.circlePlus(Std.int(p1.x + x), Std.int(p1.y + y), 1, 0xFF0000, .9, false);
		}
		
		x += image.width;
		for (segment in segments) {
			var p1 = segment.p0;
			var p2 = segment.p1;
			
			Draw.linePlus(Std.int(p1.x + x), Std.int(p1.y + y), Std.int(p2.x + x), Std.int(p2.y + y), 0xFF0000, .9);
		}

		x += image.width;
		for (poly in decomposedPolys) {
			for (i in 1...poly.points.length + 1) {
				var p1 = poly.points[i - 1];
				var p2 = poly.points[i % poly.points.length];
				
				Draw.linePlus(Std.int(p1.x + x), Std.int(p1.y + y), Std.int(p2.x + x), Std.int(p2.y + y), 0xFF0000, .9);
			}
		}
		
		x += image.width;
		for (tri in triangulatedPoly) {
			for (i in 1...tri.pointList.length + 1) {
				var p1 = tri.pointList[i - 1];
				var p2 = tri.pointList[i % tri.pointList.length];
				
				Draw.linePlus(Std.int(p1.x + x), Std.int(p1.y + y), Std.int(p2.x + x), Std.int(p2.y + y), 0xFF0000, .9);
			}
		}
		
		x += image.width;
		for (poly in convexPolys) {
			for (i in 1...poly.pointList.length + 1) {
				var p1 = poly.pointList[i - 1];
				var p2 = poly.pointList[i % poly.pointList.length];
				
				Draw.linePlus(Std.int(p1.x + x), Std.int(p1.y + y), Std.int(p2.x + x), Std.int(p2.y + y), 0xFF0000, .9);
			}
		}
		//HXP.buffer.draw(invertedBMD);
	}
}
