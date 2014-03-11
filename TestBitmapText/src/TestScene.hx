package;

import com.haxepunk.graphics.BitmapText;
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
class TestScene extends Scene
{

	public var text:BitmapText;
	
	public function new() 
	{
		super();
	}
	
	override public function begin():Void {
		
		text = new BitmapText("this | ! ", 0, 0, 0, 0, {font:"assets/new_super_mario-littera.fnt"});
		addGraphic(text, 0, 0, 10);
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
