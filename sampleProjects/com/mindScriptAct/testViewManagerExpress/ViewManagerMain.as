package com.mindScriptAct.testViewManagerExpress {
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

/**
 * COMMENT
 * @author Deril
 */
public class ViewManagerMain extends Sprite {
	private var module:ViewMenagerMainModule;
	
	public function ViewManagerMain() {
		if (stage)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	
	}
	
	private function init(event:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		//
		
		// vm warm up:
		//setTimeout(start, 2000);
		start();
	}
	
	private function start():void {
		
		module = new ViewMenagerMainModule();
		module.start(this);
	}

}
}