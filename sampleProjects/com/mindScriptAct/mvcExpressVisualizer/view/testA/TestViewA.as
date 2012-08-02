package com.mindScriptAct.mvcExpressVisualizer.view.testA {
	import flash.display.Shape;
	import flash.display.Sprite;
	
	
/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TestViewA extends Sprite {
	
	public function TestViewA() {
		var rectangle:Shape = new Shape();
		rectangle.graphics.lineStyle(0.1, 0xFF0000);
		rectangle.graphics.beginFill(0x0000FF);
		rectangle.graphics.drawRect(0, 0, 100, 100);
		rectangle.graphics.endFill();
		this.addChild(rectangle);
	}
	
}
}