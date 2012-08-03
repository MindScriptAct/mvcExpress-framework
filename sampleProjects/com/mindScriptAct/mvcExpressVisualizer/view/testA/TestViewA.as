package com.mindScriptAct.mvcExpressVisualizer.view.testA {
	import com.bit101.components.PushButton;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	
/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TestViewA extends Sprite {
	
	public function TestViewA() {
		var rectangle:Shape = new Shape();
		rectangle.graphics.lineStyle(2, 0xFFFF00);
		rectangle.graphics.beginFill(0xCEFFCE);
		rectangle.graphics.drawRect(5, 5, 250, 150);
		rectangle.graphics.endFill();
		this.addChild(rectangle);
		
	}
	
}
}