import com.haxepunk.*;
import com.haxepunk.Engine;
import com.haxepunk.graphics.*;
import com.haxepunk.graphics.atlas.AtlasRegion;
import com.haxepunk.graphics.TiledImage;
import com.haxepunk.HXP;
import com.haxepunk.RenderMode;
import com.haxepunk.utils.Draw;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.geom.Point;
import flash.system.System;


@:access(com.haxepunk.graphics.TiledImage)
@:access(com.haxepunk.graphics.atlas.AtlasRegion)
class TestWorld extends World {
	
	var tiledImage:TiledImage;
	var w:Int;
	var h:Int;
	
    public function new():Void {
        super();
    }
	
	override public function begin():Void
	{
		w = 100;
		h = 150;
		tiledImage = new TiledImage("assets/tiles.png", w, h);
		//tiledImage.flipped = true;
		addGraphic(tiledImage, 0, 50, 50);
		
		addGraphic(new Text("TiledImage"), 0, 50, 20);
		addGraphic(new Text("source"), 0, 300, 20);
		
		trace(w, h, tiledImage.width, tiledImage.height);
		trace(tiledImage._width);
	}
	
	override public function update():Void 
	{
		super.update();
		if (Input.check(Key.ESCAPE)) quit();
	}
	
	override public function render():Void 
	{
		super.render();
		Draw.rect(50, 50, w, h, 0xFF0000, .2);
		if (!tiledImage.blit) {
			tiledImage._region.draw(300, 50, 0);
		} else {
			HXP.buffer.copyPixels(tiledImage._texture, tiledImage._texture.rect, new Point(300, 50));
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
        super(640, 480, 60, false, RenderMode.HARDWARE);
		HXP.console.enable();
		HXP.world = new TestWorld();
    }

    static function main():Void {
        flash.Lib.current.addChild(new Main());
    }
}