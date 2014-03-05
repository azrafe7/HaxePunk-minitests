import com.haxepunk.*;
import com.haxepunk.graphics.*;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.system.System;


class TestScene extends Scene {
    public function new():Void {
        super();
    }
	
	override public function update():Void 
	{
		super.update();
		
		if (Input.check(Key.ESCAPE)) quit();
	}
	
	override public function render():Void 
	{
		super.render();
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
		HXP.console.enable();
		HXP.world = new TestScene();
    }

    static function main():Void {
        flash.Lib.current.addChild(new Main());
    }
}