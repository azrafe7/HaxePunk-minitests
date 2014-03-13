package;

import com.haxepunk.Graphic;
import com.haxepunk.graphics.atlas.AtlasData;
import com.haxepunk.graphics.atlas.BitmapFontAtlas;
import com.haxepunk.graphics.BitmapText;
import com.haxepunk.graphics.Image;
import com.haxepunk.Scene;
import com.haxepunk.utils.Draw;
import flash.display.BitmapData;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.system.System;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.World;
import openfl.Assets;
import openfl.display.Tilesheet;

/**
 * ...
 * @author azrafe7
 */
class TestScene extends Scene
{

	public var text:BitmapText;
	public var normText:Text;
	
	var MARIO:String = "assets/new_super_mario-littera.fnt";
	var ALAGARD:String = "assets/alagard-bmfont.fnt";
	var DEFAULT:String = "assets/04b.fnt";
	var ROUND_PIXELIZER:String = "assets/round_font-pixelizer.png";
	
	public function new() 
	{
		super();
	}
	
	@:access(com.haxepunk.graphics.atlas)
	@:access(openfl.display.Tilesheet)
	override public function begin():Void {
		normText = new Text("phis | ! \nt", 0, 0, 0, 0, { size: 8 } );
		//text = new BitmapText("this | ! ", 0, 0, 0, 0, { font:MARIO, format:XML/*, color:0x0FF000*/} );
		//text = new BitmapText("phis | ! \nt", 0, 0, 0, 0, { font:ROUND_PIXELIZER, format:PIXELIZER, color:0xFFFFFF00 } );
		text = new BitmapText("phis | \t! \nt" + BitmapFontAtlas._DEFAULT_GLYPHS, 0, 30, 0, 0, { color:0xFFFF0000 } );
		//text.color = 0xFF0000;
		//text.size = 8;
		
		trace(text.lineSpacing, text.charSpacing, text.height);
		
		addGraphic(normText, 0, 100, 10);
		addGraphic(text, 0, 0, 10);
		
		/*
		var bmd = new BitmapData(800, 26, true, 0);
		Draw.setTarget(bmd);
		var x = 0;
		var y = 2;
		var t = new Text("", 0, 0, 0, 0, { size:8 });
		for (i in 0...BitmapFontAtlas._DEFAULT_GLYPHS.length) {
			var ch = BitmapFontAtlas._DEFAULT_GLYPHS.charAt(i);
			t.text = ch;
			
			Draw.rect(x+1, y+2, t.textWidth-3, 8, 0xFF202020);
			t.color = 0;
			for (j in -1...2) {
				for (k in -1...2) {
					t.render(bmd, new Point(x+j, y+k), HXP.zero);
				}
			}
			t.color = 0xFFFFFF;
			t.render(bmd, new Point(x, y), HXP.zero);
			x += t.textWidth-2;
			if (ch == "O") {
				y += 9;
				x = 0;
			}
		}
		//bmd.applyFilter(bmd, bmd.rect, HXP.zero, new GlowFilter(0, 1, 2, 2, 4));
		addGraphic(new Image(bmd), 0, 10, 200);
		*/
	}
	
	override public function update():Void 
	{
		super.update();
	}
	
	override public function render():Void 
	{
		super.render();
	}
}
