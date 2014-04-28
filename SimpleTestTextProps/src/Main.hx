import com.haxepunk.*;
import com.haxepunk.Engine;
import com.haxepunk.graphics.*;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.filters.GlowFilter;
import flash.system.System;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

@:access(com.haxepunk.graphics.Text)
class TestScene extends Scene {
	
	private var text:Text;
	
    public function new():Void {
        super();
		
		addGraphic(text = new Text("testing com.haxepunk.graphics.Text\nget/setTextProperty"), 0, HXP.halfWidth, HXP.halfHeight);
		text.centerOrigin();
		text.align = TextFormatAlign.CENTER;
	
		
		// change these to test
		// ...some props you can play with: color, align, size, alpha, angle, displayAsPassword, flipped, filters, etc...
		// some don't work with Neko but are fine with CPP
		var propName = "angle";
		var newValue:Null<Dynamic> = 15;
		
		// f.e. this doesn't work on Neko but works on CPP
		text.setTextProperty("background", true);
		text.setTextProperty("backgroundColor", 0xFFFF0000);
		
		
		trace("BEFORE");
		
		trace('getTextProperty($propName): ' + text.getTextProperty(propName));
		
		trace(propName + " in TextField  ?", Reflect.hasField(text._field, propName), Reflect.getProperty(text._field, propName));
		trace(propName + " in TextFormat ?", Reflect.hasField(text._format, propName), Reflect.getProperty(text._format, propName));
		trace(propName + " in Text       ?", Reflect.hasField(text, propName), Reflect.getProperty(text, propName));

		if (newValue != null) {
			trace("AFTER");
			
			var propFound = text.setTextProperty(propName, newValue);
			
			trace('setTextProperty($propName, $newValue): ' + text.getTextProperty(propName) + "      propFound: " + propFound);
			
			trace(propName + " in TextField  ?", Reflect.hasField(text._field, propName), Reflect.getProperty(text._field, propName));
			trace(propName + " in TextFormat ?", Reflect.hasField(text._format, propName), Reflect.getProperty(text._format, propName));
			trace(propName + " in Text       ?", Reflect.hasField(text, propName), Reflect.getProperty(text, propName));
		}
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