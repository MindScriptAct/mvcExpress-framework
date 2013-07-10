package com.mindScriptAct.mvcExpressVisualizer.view.testB {
import com.bit101.components.Label;

import flash.display.Shape;
import flash.display.Sprite;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TestViewB extends Sprite {

	public function TestViewB() {
		var rectangle:Shape = new Shape();
		rectangle.graphics.lineStyle(2, 0x00FF00);
		rectangle.graphics.beginFill(0xCEFFCE);
		rectangle.graphics.drawRect(5, 5, 250, 150);
		rectangle.graphics.endFill();
		this.addChild(rectangle);

		var viewLabel:Label = new Label(this, 10, 5, "VIEW:" + this + " (name:" + this.name + ")");
		viewLabel.textField.textColor = 0x000000;
	}

}
}