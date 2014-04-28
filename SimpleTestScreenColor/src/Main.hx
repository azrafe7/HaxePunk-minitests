import com.haxepunk.*;
import com.haxepunk.Engine;
import com.haxepunk.graphics.*;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.RenderMode;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.system.System;


class TestScene extends Scene {
    public function new():Void {
        super();
		
		var text:Text;
		addGraphic(text = new Text("press SPACE to change screen color"), 0, HXP.halfWidth, HXP.halfHeight);
		text.centerOrigin();
    }
	
	override public function update():Void 
	{
		super.update();
		
		if (Input.check(Key.ESCAPE)) quit();
		
		if (Input.pressed(Key.SPACE) || Input.mousePressed) HXP.screen.color = HXP.rand(0xFFFFFF);
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
        super(640, 480, 60, false);
		HXP.console.enable();
		HXP.world = new TestScene();
    }

    static function main():Void {
        flash.Lib.current.addChild(new Main());
    }
}