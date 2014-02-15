package;

import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Masklist;
import com.haxepunk.masks.Polygon;
import com.haxepunk.Scene;
import com.haxepunk.utils.Draw;
import com.mindrocks.delaunay.Voronoi;
import com.mindrocks.geom.LineSegment;
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
	
	public var BUNNY:String = "assets/pirate.png";
	
	
	public var bunnyBMD:BitmapData;
	public var bunnyImage:Image;
	public var bunnyEntity:Entity;
	
	public var poly:Array<Point>;
	public var simplifiedPoly:Array<Point>;
	public var triangulatedPoly:Array<com.touchmypixel.geom.Triangle>;
	
	public var MarchingSquaresText:Text;
	public var RDPText:Text;
	public var DelaunayText:Text;
	public var DecompositionText:Text;
	
	public function new() 
	{
		super();
	}
	
	override public function begin():Void {
		
		bunnyBMD = HXP.getBitmap(BUNNY);
		//bunnyBMD = new BitmapData(60, 80); // test with a rectangle
		bunnyImage = new Image(bunnyBMD);
		
		bunnyEntity = addGraphic(bunnyImage, 0, 5, 60);
		
		
		// Marching Squares
		
		var alphaThreshold:Int = 1;
		var marchingSquares = new MarchingSquares(bunnyBMD, alphaThreshold);
		marchingSquaresBMD = bunnyBMD.clone();
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
		
		simplifiedPoly = MarchingSquares.simplify(simplifiedPoly, 1.5);
		trace(simplifiedPoly.length);
		
		
		// Delauney triangulation (convex poly)
		
		var voronoi:Voronoi = new Voronoi(simplifiedPoly, null, bunnyBMD.rect);
		invertedBMD = bunnyBMD.clone();
		invertedBMD.threshold(invertedBMD, invertedBMD.rect, new Point(), "<", alphaThreshold << 24, 0xFFFFFFFF); 
		invertedBMD.threshold(bunnyBMD, bunnyBMD.rect, new Point(), ">=", alphaThreshold << 24, 0); 
		segments = voronoi.delaunayTriangulation();
		
		
		// Convex decomposition
		//triangulatedPoly = Triangulator.triangulate(simplifiedPoly);
		
		var vec2array:Array<Vec2> = [];
		for (p in simplifiedPoly) vec2array.push(Vec2.fromPoint(p));
		var geomPoly:GeomPoly = new GeomPoly(vec2array);
		
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
		
		addGraphic(MarchingSquaresText = new Text(poly.length + "\npts", bunnyEntity.x + bunnyImage.width + bunnyImage.width / 2, bunnyEntity.y - 30, 0, 0, { size:8, align:TextFormatAlignType.CENTER } ));
		addGraphic(RDPText = new Text(simplifiedPoly.length + "\npts", bunnyEntity.x + bunnyImage.width * 2 + bunnyImage.width / 2, bunnyEntity.y - 30, 0, 0, { size:8, align:TextFormatAlignType.CENTER } ));
		addGraphic(DelaunayText = new Text(segments.length/3 + "\ntris", bunnyEntity.x + bunnyImage.width * 3 + bunnyImage.width / 2, bunnyEntity.y - 30, 0, 0, { size:8, align:TextFormatAlignType.CENTER } ));
		addGraphic(DecompositionText = new Text(decomposedPolys.length + "\npolys", bunnyEntity.x + bunnyImage.width * 4 + bunnyImage.width / 2, bunnyEntity.y - 30, 0, 0, { size:8, align:TextFormatAlignType.CENTER } ));

		
		// Mask & Cursor
		
		bunnyEntity.mask = new Masklist(decomposedPolys);
		bunnyImage.angle = 0;
		for (poly in decomposedPolys) {
			poly.angle = bunnyImage.angle;
		}
		bunnyEntity.setHitbox(bunnyBMD.width, bunnyBMD.height);
		
		cursor = addGraphic(Image.createCircle(5, 0x00FF00));
		cursor.setHitbox(10, 10);
		
	}
	
	override public function update():Void 
	{
		super.update();

		cursor.x = Input.mouseX;
		cursor.y = Input.mouseY;
		
		if (bunnyEntity.collideWith(cursor, bunnyEntity.x, bunnyEntity.y) != null) bunnyImage.color = 0xFF0000;
		else bunnyImage.color = 0xFFFFFF;
	}
	
	override public function render():Void 
	{
		super.render();

		var x = bunnyEntity.x + bunnyImage.width;
		var y = bunnyEntity.y;
		
		var mtx:Matrix = new Matrix(1, 0, 0, 1, x, y);
		HXP.buffer.draw(marchingSquaresBMD, mtx);
		
		x += bunnyImage.width;
		for (i in 1...simplifiedPoly.length) {
			var p1 = simplifiedPoly[i - 1];
			var p2 = simplifiedPoly[i];
			
			Draw.linePlus(Std.int(p1.x + x), Std.int(p1.y + y), Std.int(p2.x + x), Std.int(p2.y + y), 0xFF0000, .9);
			Draw.circlePlus(Std.int(p1.x + x), Std.int(p1.y + y), 1, 0xFF0000, .9, false);
		}
		
		x += bunnyImage.width;
		for (segment in segments) {
			var p1 = segment.p0;
			var p2 = segment.p1;
			
			Draw.linePlus(Std.int(p1.x + x), Std.int(p1.y + y), Std.int(p2.x + x), Std.int(p2.y + y), 0xFF0000, .9);
		}

		x += bunnyImage.width;
		for (poly in decomposedPolys) {
			for (i in 1...poly.points.length + 1) {
				var p1 = poly.points[i - 1];
				var p2 = poly.points[i % poly.points.length];
				
				Draw.linePlus(Std.int(p1.x + x), Std.int(p1.y + y), Std.int(p2.x + x), Std.int(p2.y + y), 0xFF0000, .9);
			}
		}
		
		//HXP.buffer.draw(invertedBMD);
	}
}
