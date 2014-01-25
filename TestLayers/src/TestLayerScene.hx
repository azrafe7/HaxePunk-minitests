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
class TestLayerScene extends Scene
{

	public var images:Array<Text>;
	public var entities:Array<Entity>;
	public static inline var N:Int = 4;
	
	public function new() 
	{
		super();
	}
	
	@:access(com.haxepunk.graphics.Text)
	override public function begin():Void {
		
		HXP.log("SPACE - random layers | lower layer values should render on top");
		
		entities = new Array<Entity>();
		images = new Array<Text>();
		for (i in 0...N) {
			images[i] = new Text("layer xxx");
			images[i]._field.background = true;
			images[i]._field.backgroundColor = HXP.rand(0xFFFFFF);
			images[i].alpha = .85;
			entities[i] = new Entity(20 + 10 * i, 20 + 10 * i, images[i]);
			entities[i].layer = -i * 10;
			images[i].text = "Layer " + entities[i].layer;
			
		#if (cpp || neko)
			images[i].scale = 4;
		#end
		}
		
		addList(entities);
	}
	
	override public function update():Void 
	{
		super.update();
		
		// shuffle layers
		if (Input.pressed(Key.SPACE)) {
			for (i in 0...N) {
				var newLayer:Int = HXP.rand(N+1) - N * 2;
				entities[i].layer = newLayer;
				images[i].text = "Layer " + newLayer;
			}
			
			var s:String = "";
			for (i in _renderFirst.keys()) s += i + ", ";
			trace(s);
		}
	}
	
	override public function render():Void 
	{
		super.render();
	}
}
