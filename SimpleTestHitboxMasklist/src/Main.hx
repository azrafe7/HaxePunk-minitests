import com.haxepunk.*;
import com.haxepunk.graphics.*;
import com.haxepunk.HXP;
import com.haxepunk.masks.Circle;
import com.haxepunk.masks.Hitbox;
import com.haxepunk.masks.Masklist;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.system.System;


class TestWorld extends World {
    public function new():Void {
        super();
		
		var h = new Hitbox(30, 50, 10, 10);
		
		var h1 = new Hitbox(30, 50, 10, 10);
		var h2 = new Hitbox(60, 20, 20, 80);
		var c = new Circle(30, 0, 0);
		
		addMask(new Masklist([h2, h1/*, c*/]), "masklist", 50, 50);
		addMask(h, "hitbox", 50, 200);
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
		//HXP.screen.scale = 2;
		HXP.console.enable();
		HXP.world = new TestWorld();
    }

    static function main():Void {
        flash.Lib.current.addChild(new Main());
    }
}