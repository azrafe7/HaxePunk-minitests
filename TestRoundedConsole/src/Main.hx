package ;

import flash.display.BitmapData;
import flash.events.KeyboardEvent;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.system.System;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFormatAlign;
import flash.utils.ByteArray;
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.Utf8;
import com.haxepunk.debug.Console;
import com.haxepunk.Engine;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.ParticleType;
import com.haxepunk.graphics.PreRotation;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.TiledImage;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.masks.Grid;
import com.haxepunk.masks.Pixelmask;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Data;
import com.haxepunk.utils.Draw;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import openfl.Assets;
import openfl.display.FPS;


/**
 * ...
 * @author azrafe7
 */
class Main extends Engine
{
	
    public function new() {
		// modify project.xml to change dimensions and affect the console (watch out for bg color too in there)
        super();
    }
	
    override public function init():Void {
        super.init();
		HXP.screen.scale = 1;	// bug: if you set this to 2 you'll get the "open the console..." text in the bottom-right corner!
        HXP.console.enable(TraceCapture.No);
		
		HXP.scene = new TestConsoleScene();
	}
		
	override public function update():Void 
	{
		super.update();
		
		// ESC to exit
		if (Input.pressed(Key.ESCAPE)) {
		#if web
			System.exit(0);
		#else
			Sys.exit(0);
		#end
		}
		
		// R to reset the world
		if (Input.pressed(Key.R)) {
			HXP.scene.removeAll();
			var sceneClass = Type.getClass(HXP.scene);
			HXP.scene = Type.createInstance(sceneClass, []);
		}	
		
	}
	
	override public function render():Void 
	{
		super.render();
		
	}
}
