package com.mindScriptAct.mvcExpressLive.view {
import flash.display.Sprite;

/**
 * COMMENT
 * @author rBanevicius
 */
public class LiveViewTest extends Sprite {
	
	public function LiveViewTest() {
		this.graphics.lineStyle(0.1, 0xFF0000);
		this.graphics.beginFill(0x0000FF);
		this.graphics.drawRect(0, 0, 100, 100);
		this.graphics.endFill();
	}

}
}