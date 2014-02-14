package;

import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Polygon;
import com.haxepunk.Scene;
import com.haxepunk.utils.Draw;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.system.System;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.World;
import MarchingSquares;

/**
 * ...
 * @author azrafe7
 */
class TestScene extends Scene
{
	var cursor:Entity;
	
	public var BUNNY:String = "assets/pirate.png";
	
	
	public var bunnyBMD:BitmapData;
	public var bunnyImage:Image;
	public var bunnyEntity:Entity;
	
	public var poly:Array<Point>;
	public var simplifiedPoly:Array<Point>;
	
	public var marchingSquaresText:Text;
	public var RDPText:Text;
	
	public function new() 
	{
		super();
	}
	
	override public function begin():Void {
		
		bunnyBMD = HXP.getBitmap(BUNNY);
		//bunnyBMD = new BitmapData(60, 80); // test with a rectangle
		bunnyImage = new Image(bunnyBMD);
		
		bunnyEntity = addGraphic(bunnyImage, 0, 30, 60);
		
		var marchingSquares = new MarchingSquares(bunnyBMD, 1);
		
		poly = marchingSquares.march();
		
		trace(poly.length);
		
		simplifiedPoly = new Array<Point>();
		for (p in poly) simplifiedPoly.push(new Point(p.x, p.y));
		
		simplifiedPoly = MarchingSquares.simplify(simplifiedPoly, 1.5);
		trace(simplifiedPoly.length);
		
		bunnyEntity.mask = new Polygon(simplifiedPoly);
		
		/*
		cursor = addGraphic(Image.createCircle(5, 0x00FF00));
		cursor.setHitbox(10, 10);
		*/
		
		addGraphic(marchingSquaresText = new Text(poly.length + "\npts", bunnyEntity.x + bunnyImage.width + bunnyImage.width / 2, bunnyEntity.y - 30, 0, 0, { size:8, align:TextFormatAlignType.CENTER } ));
		addGraphic(RDPText = new Text(simplifiedPoly.length + "\npts", bunnyEntity.x + bunnyImage.width * 2 + bunnyImage.width / 2, bunnyEntity.y - 30, 0, 0, { size:8, align:TextFormatAlignType.CENTER } ));
	}
	
	override public function update():Void 
	{
		super.update();
		/*
		cursor.x = Input.mouseX;
		cursor.y = Input.mouseY;
		
		if (bunnyEntity.collideWith(cursor, bunnyEntity.x, bunnyEntity.y) != null) bunnyImage.color = 0xFF0000;
		else bunnyImage.color = 0xFFFFFF;
		*/
	}
	
	override public function render():Void 
	{
		super.render();

		var x = bunnyEntity.x + bunnyImage.width;
		var y = bunnyEntity.y;
		
		for (i in 1...poly.length) {
			var p1 = poly[i - 1];
			var p2 = poly[i];
			
			Draw.linePlus(Std.int(p1.x + x), Std.int(p1.y + y), Std.int(p2.x + x), Std.int(p2.y + y), 0xFF0000, .9);
		}
		
		x += bunnyImage.width;
		for (i in 1...simplifiedPoly.length) {
			var p1 = simplifiedPoly[i - 1];
			var p2 = simplifiedPoly[i];
			
			Draw.linePlus(Std.int(p1.x + x), Std.int(p1.y + y), Std.int(p2.x + x), Std.int(p2.y + y), 0xFF0000, .9);
			Draw.circlePlus(Std.int(p1.x + x), Std.int(p1.y + y), 1, 0xFF0000, .9, false);
		}
	}
}
