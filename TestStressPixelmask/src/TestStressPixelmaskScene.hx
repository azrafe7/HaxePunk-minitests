package;

import com.haxepunk.graphics.Spritemap;
import com.haxepunk.masks.Imagemask;
import com.haxepunk.Scene;
import com.haxepunk.utils.BitmapDataPool;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.geom.ColorTransform;
import flash.system.System;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

using StringTools;

/**
 * ...
 * @author azrafe7
 */
class TestStressPixelmaskScene extends Scene
{

	var ALIEN:String = "assets/alien.png";
	var SHIP:String = "assets/ship.png";
	
	var nObjects:Int = 10;
	var objects:Array<Entity>;
	var player:Entity;
	
	var infoText:Text;
	var INFO:String = "collisions: |hits| (|ratio|)\n\n" + 
					  "[W/S]       num players: |players|\n" +
					  "[A/D]       alpha tolerance: |alpha|\n" +
					  "[ARROWS]    move\n" +
					  "[R]          random\n" +
					  "[SPACE]     toggle rotation";
					  
	var nCollisions:Int = 0;
	
	var alphaTolerance:Int = 1;
	var rotate:Bool = true;

	public function new() 
	{
		super();
	}
	
	override public function begin():Void {
		objects = [];
		
		var img:Image = new Image(SHIP);
		img.centerOrigin();
		
		player = new Entity(HXP.halfWidth, HXP.halfHeight, img, new Imagemask(img));
		player.centerOrigin();
		objects.push(player);
		
		player.type = "player";
		
		for (i in 1...nObjects) {
			addObject();
		}
		
		addList(objects);
		
		addGraphic(infoText = new Text(INFO, 5, 160));
		infoText.size = 8;
	}
	
	function addObject():Entity 
	{
		var bmd:BitmapData = HXP.getBitmap(ALIEN).clone();
		bmd.colorTransform(bmd.rect, new ColorTransform(1, 1, 1, .2 + Math.random() * .8));
		var sprite:Spritemap = new Spritemap(bmd, 16, 16);
		sprite.add("dance", HXP.frames(0, 2), 6 + Math.random() * 4);
		sprite.play("dance");
		sprite.centerOrigin();
		
		var e:Entity = new Entity(0, 0, sprite, new Imagemask(sprite));
		e.centerOrigin();
		objects.push(e);
		
		e.type = "alien";
		
		randomize(e);
		
		return e;
	}
	
	function randomize(e:Entity) {
		e.x = Math.random() * HXP.width;
		e.y = Math.random() * HXP.height;
		var img:Image = cast e.graphic;
		img.angle = Math.random() * 360;
		
		return e;
	}
	
	override public function update():Void 
	{
		super.update();
		
		var horzMove:Int = Input.check(Key.LEFT) ? -1 : Input.check(Key.RIGHT) ? 1 : 0;
		var vertMove:Int = Input.check(Key.UP) ? -1 : Input.check(Key.DOWN) ? 1 : 0;
		
		if (Input.pressed(Key.SPACE)) rotate = !rotate;
		
		if (Input.pressed(Key.R)) {
			for (obj in objects) if (obj != player) randomize(obj);
		}
		
		if (Input.check(Key.W)) nObjects++;
		if (Input.check(Key.S)) nObjects = Std.int(Math.max(nObjects - 1, 2));
		
		if (Input.check(Key.D)) alphaTolerance = Std.int(Math.min(alphaTolerance + 1, 255));
		if (Input.check(Key.A)) alphaTolerance = Std.int(Math.max(alphaTolerance - 1, 1));

		// add/remove objects
		if (nObjects != objects.length) {
			var len = objects.length;
			if (nObjects > len) add(addObject());
			else remove(objects.pop());
		}

		for (obj in objects) {
			var img:Image = cast obj.graphic;
			var mask:Imagemask = cast obj.mask;
			mask.threshold = alphaTolerance;

			if (rotate) {
				img.angle -= 1.5;
				mask.update();
			}
		}
		
		player.x += horzMove * 2;
		player.y += vertMove * 2;
		
		// pixel perfect check between all
		nCollisions = 0;
		for (i in 0...objects.length) {
			var obj1 = objects[i];
			var collides = false;
			for (j in 0...objects.length) {
				if (i == j) continue;
				
				var obj2 = objects[j];
				
				if (obj1.collideWith(obj2, obj1.x, obj1.y) != null) {
					collides = true;
					nCollisions++;
					break;
				}
			}
			var img1:Image = cast obj1.graphic;
			img1.color = collides ? 0xFF0000 : (obj1 == player ? 0x00FF00 : 0xFFFFFF);
		}

		infoText.text = INFO.replace("|players|", Std.string(nObjects))
			.replace("|alpha|", Std.string(alphaTolerance))
			.replace("|hits|", Std.string(nCollisions))
			.replace("|ratio|", Std.string(BitmapDataPool.hits/BitmapDataPool.requests).substr(0, 4));
	}
	
	override public function render():Void 
	{
		super.render();
	}
}
