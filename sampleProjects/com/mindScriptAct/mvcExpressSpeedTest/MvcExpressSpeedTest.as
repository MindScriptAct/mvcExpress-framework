package com.mindScriptAct.mvcExpressSpeedTest {
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.utils.getTimer;
import flash.utils.setTimeout;

/**
 * ...
 * @author Deril (raima156@yahoo.com)
 */
public class MvcExpressSpeedTest extends Sprite {
	
	public var initTime:int;
	
	private var context:AppModule;
	
	public function MvcExpressSpeedTest():void {
		if (stage)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(event:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		//
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		//
		
		// vm warm up:
		//setTimeout(start, 2000);
		start();
	}
	
	private function start():void {
		this.initTime = getTimer();
		
		context = new AppModule();
		context.start(this);
	}

}

}