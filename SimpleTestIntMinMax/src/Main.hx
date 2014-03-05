import com.haxepunk.*;
import com.haxepunk.graphics.*;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.system.System;


class TestWorld extends World {
    public function new():Void {
        super();
		
		trace("maxint    : " + HXP.INT_MAX_VALUE);
		trace("minint    : " + HXP.INT_MIN_VALUE);
		trace("maxint + 1: " + (HXP.INT_MAX_VALUE + 1));
		
		var seed = HXP.INT_MAX_VALUE;
		HXP.randomSeed = seed;
		
		var expectedRnds:Array<Int> = [2147466840, 1865008398, 524833574];
		var rnd:Int;
		
		trace("random");
		trace(rnd = Std.int(HXP.random * HXP.INT_MAX_VALUE), eq(rnd, expectedRnds[0]));
		trace(rnd = Std.int(HXP.random * HXP.INT_MAX_VALUE), eq(rnd, expectedRnds[1]));
		trace(rnd = Std.int(HXP.random * HXP.INT_MAX_VALUE), eq(rnd, expectedRnds[2]));
		
		HXP.randomSeed = seed;
		
		trace("reset seed");
		trace(rnd = Std.int(HXP.random * HXP.INT_MAX_VALUE), eq(rnd, expectedRnds[0]));
		trace(rnd = Std.int(HXP.random * HXP.INT_MAX_VALUE), eq(rnd, expectedRnds[1]));
		trace(rnd = Std.int(HXP.random * HXP.INT_MAX_VALUE), eq(rnd, expectedRnds[2]));
    }
	
	public static function eq(a:Int, b:Int):Bool 
	{
		if (a != b) throw "Error: " + a + " != " + b;
		return a == b;
	}
	
	override public function update():Void 
	{
		if (Input.check(Key.ESCAPE)) quit();
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
		HXP.world = new TestWorld();
    }

    static function main():Void {
        flash.Lib.current.addChild(new Main());
    }
}