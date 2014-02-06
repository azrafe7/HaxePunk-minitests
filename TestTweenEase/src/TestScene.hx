package;

import com.haxepunk.graphics.Image;
import com.haxepunk.Scene;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;
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
	public var tween:VarTween;
	public var easeArray:Array<EaseFunction>;
	public var idx:Int = 0;
	public var image:Image;
	
	override public function begin():Void {
		image = Image.createRect(30, 30);
		addGraphic(image, -10, 20, 60);
		tween = new VarTween(onComplete);
		addTween(tween);
		
		easeArray = [null, Ease.backIn, Ease.backInOut, Ease.backOut, Ease.bounceIn, Ease.bounceInOut, Ease.bounceOut, Ease.circIn,
					Ease.circInOut, Ease.circOut, Ease.cubeIn, Ease.cubeInOut, Ease.cubeOut, Ease.expoIn, Ease.expoInOut,
					Ease.expoOut, Ease.quadIn, Ease.quadInOut, Ease.quadOut, Ease.quartIn, Ease.quartInOut, Ease.quartOut,
					Ease.quintIn, Ease.quintInOut, Ease.quintOut, Ease.sineIn, Ease.sineInOut, Ease.sineOut];
					
		onComplete(null);
	}
	
	private function onComplete(_)
	{
		trace(idx);
		idx = (idx + 1) % easeArray.length;
		image.x = 20;
		tween.tween(image, "x", 200, 1, easeArray[idx]);
	}
}
