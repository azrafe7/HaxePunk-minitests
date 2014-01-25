package;

import com.haxepunk.Scene;
import flash.system.System;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.World;

/**
 * ...
 * @author azrafe7
 */
class TestConsoleScene extends Scene
{
	var text:Text;
	
	public function new() 
	{
		super();
	}
	
	override public function begin():Void {
		for (i in 0...40) HXP.log(i + ". writing some nonsense to test console log scroll");
		
		text = new Text("open the console with ~");
		text.centerOrigin();
		addGraphic(text, 0, HXP.halfWidth, HXP.halfHeight);
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
