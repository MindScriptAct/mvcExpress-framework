package com.mindScriptAct.mvcExpressVisualizer.view.testB {
	import flash.display.Shape;
	import flash.display.Sprite;
	
	
/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TestViewB extends Sprite {
	
	public function TestViewB() {
		var rectangle:Shape = new Shape();
		rectangle.graphics.lineStyle(0.1, 0xFF0000);
		rectangle.graphics.beginFill(0x00FF40);
		rectangle.graphics.drawRect(0, 0, 100, 100);
		rectangle.graphics.endFill();
		this.addChild(rectangle);
	}
	
}
}