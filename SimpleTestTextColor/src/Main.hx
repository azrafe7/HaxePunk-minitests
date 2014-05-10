import com.haxepunk.*;
import com.haxepunk.graphics.*;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.display.BitmapData;
import flash.system.System;


class TestScene extends Scene {
    public function new():Void {
        super();
    }
	
	override public function begin()
	{
		super.begin();

		var textColor = 0xaf1480;
		var bmd = new BitmapData(40, 40, false, textColor);
		var text1 = new Text("text one", 70, 30, 0, 0, { color: textColor});
		var text2 = new Text("text two", 70, 50, 0, 0);
		text2.color = textColor;
		text2.text = "new text two";
		var richText = new Text("", 70, 90);
		richText.addStyle("colored", { color: textColor });
		richText.addStyle("big", { size: richText.size * 2, bold: true } );
		richText.richText = "<big>rich</big> <colored>text</colored>";
		
		addGraphic(text1);
		addGraphic(text2);
		addGraphic(richText);
		addGraphic(new Image(bmd), 0, 20, 30);
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
        super(640, 480, 60, false);
		HXP.console.enable();
		HXP.world = new TestScene();
    }

    static function main():Void {
        flash.Lib.current.addChild(new Main());
    }
}