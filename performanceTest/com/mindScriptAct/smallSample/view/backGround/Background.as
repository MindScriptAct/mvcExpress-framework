package com.mindScriptAct.smallSample.view.backGround {
import flash.display.Shape;
import flash.display.Sprite;

/**
 * COMMENT
 * @author rbanevicius
 */
public class Background extends Sprite {
	
	public function Background() {
		var rectangle:Shape = new Shape();
		rectangle.graphics.lineStyle(0.1, 0xFF0000);
		rectangle.graphics.beginFill(0x0000FF);
		rectangle.graphics.drawRect(0, 0, 500, 500);
		rectangle.graphics.endFill();
		this.addChild(rectangle);
	}

}
}