package com.mindScriptAct.mvcExpressLive {
import com.mindscriptact.mvcExpressLogger.MvcExpressLogger;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.utils.setTimeout;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class LiveSample extends Sprite {
	
	private var appModule:LiveSampleModule;
	
	public function LiveSample():void {
		
		if (stage) {
			init();
		} else {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
	
	private function init(event:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		//
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// vm warm up:
		setTimeout(start, 300);
	}
	
	private function start():void {
		
		MvcExpressLogger.init(this.stage, 600, 0, 900, 500, 0.9, true, MvcExpressLogger.VISUALIZER_TAB);
		
		////////////////////////////
		// Inits framework.
		////////////////////////////
		appModule = new LiveSampleModule();
		////////////////////////////
		// start our application.
		////////////////////////////
		appModule.start(this);
	}

}
}