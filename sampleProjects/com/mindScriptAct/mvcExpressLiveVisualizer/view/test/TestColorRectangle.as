package com.mindScriptAct.mvcExpressLiveVisualizer.view.test {
import com.mindScriptAct.mvcExpressLiveVisualizer.constants.ColorIds;
import flash.display.Shape;
import flash.display.Sprite;

/**
 * COMMENT
 * @author rBanevicius
 */
public class TestColorRectangle extends Sprite {
	
	public var testRectangle:Shape;
	public var colorId:String;
	
	public function TestColorRectangle(colorId:String) {
		this.colorId = colorId;
		
		testRectangle = new Shape();
		testRectangle.graphics.lineStyle(0.1, 0x000000);
		switch (colorId) {
			case ColorIds.RED: 
				testRectangle.y = 50 - 25;
				testRectangle.graphics.beginFill(0xFF0000);
				break;
			case ColorIds.GREEN: 
				testRectangle.y = 100 - 25;
				testRectangle.graphics.beginFill(0x00FF00);
				break;
			case ColorIds.BLUE: 
				testRectangle.y = 150 - 25;
				testRectangle.graphics.beginFill(0x0000FF);
				break;
			case ColorIds.ALPHA: 
				testRectangle.y = 200 - 25;
				testRectangle.graphics.beginFill(0xFFFFFF);
				break;
			default: 
		}
		
		testRectangle.x = 500;
		
		testRectangle.graphics.drawRect(-5, -25, 10, 50);
		testRectangle.graphics.endFill();
		this.addChild(testRectangle);
	
	}

}
}