import com.haxepunk.*;
import com.haxepunk.debug.Console.TraceCapture;
import com.haxepunk.Entity;
import com.haxepunk.graphics.*;
import com.haxepunk.HXP;
import com.haxepunk.masks.Circle;
import com.haxepunk.masks.Hitbox;
import com.haxepunk.masks.Masklist;
import com.haxepunk.masks.Polygon;
import com.haxepunk.math.Projection;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.geom.Point;
import flash.system.System;

@:access(com.haxepunk.masks)
class TestWorld extends World {
	
	var e:Entity;
	var masksType:Array<String> = ["masklist", "hitbox", "polylist", "poly"];
	
	var h1:Hitbox;
	var h2:Hitbox;
	
    public function new():Void {
        super();
		
		var h = new Hitbox(30, 50, 10, 10);
		
		h1 = new Hitbox(30, 50, 30, 00);
		h2 = new Hitbox(60, 20, 20, 100);
		var c = new Circle(30, -10, 0);
		
		var m1 = addMask(new Masklist([h2, h1/*, c*/]), "masklist", 50, 50);
		addMask(h, "hitbox", 50, 200);
		
		
		var p1_points = [new Point(20, 20), new Point(60, 10), new Point(50, 50)];
		var p1 = new Polygon(p1_points);
		var p2_points = [new Point(40, 60), new Point(80, 80), new Point(30, 80)];
		var p2 = new Polygon(p2_points);
		addMask(new Masklist([p1, p2]), "polylist", 280, 50);
		
		//addMask(new Polygon(p1_points), "poly", 200, 200);
		
		var p:Polygon;
		e = addMask(p = Polygon.createPolygon(3, 50), "interactive", 300, 300);
		//p.angle = 45;
		
		
		//e = addMask(new Hitbox(50, 80), "interactive", 300, 300);
		//e = addMask(new Circle(25), "interactive", 300, 300);
		
		var hb = new Hitbox(50, 150, 50, 120);
		//addMask(hb, "out", 0, 0);
		trace(hb.collideHitbox(h1));
		trace(hb.collideHitbox(h2));
		trace(hb.collideHitbox(h));
    }
	
	function printProj(h:Hitbox) {
		var horzProj:Projection = new Projection();
		h.project(Polygon.horizontal, horzProj);
		trace(horzProj);
		var vertProj:Projection = new Projection();
		h.project(Polygon.vertical, vertProj);
		trace(vertProj);
	}
	
	override public function update():Void 
	{
		if (Input.check(Key.ESCAPE)) quit();
		
		if (Input.check(Key.P)) printProj(h1);
		
		var horzMove = Input.check(Key.LEFT) ? -1 : Input.check(Key.RIGHT) ? 1 : 0;
		var vertMove = Input.check(Key.UP) ? -1 : Input.check(Key.DOWN) ? 1 : 0;
		e.x += horzMove * 2;
		e.y += vertMove * 2;
		
		var hit:Entity = e.collideTypes(masksType, e.x, e.y);
		if (hit != null) {
			trace("HIT: " + hit.type);
		}
	}
	
	public function quit():Void 
	{
	#if (flash || html5)
		System.exit(1);
	#else
		Sys.exit(1);
	#end
	}
}


class Main extends Engine {
    public function new():Void {
        super(800, 600, 60, false);
		//HXP.screen.scale = 2;
		HXP.console.enable(TraceCapture.No);
		HXP.world = new TestWorld();
    }

    static function main():Void {
        flash.Lib.current.addChild(new Main());
    }
}