package com.mindScriptAct.mvcExpressSpeedTest.view.testSprite {
import flash.display.Sprite;
import flash.events.MouseEvent;

/**
 * ...
 * @author Deril (raima156@yahoo.com)
 */
public class TestSprite extends Sprite {
	public var uniqueId:int;
	
	public function TestSprite(uniqueId:int){
		this.uniqueId = uniqueId;
		
		this.graphics.lineStyle(2, 0xFF0000);
		this.graphics.beginFill(0xFFFF00);
		this.graphics.drawRect(0, 0, 10, 10);
		this.graphics.endFill();
		
	}
	
}
}