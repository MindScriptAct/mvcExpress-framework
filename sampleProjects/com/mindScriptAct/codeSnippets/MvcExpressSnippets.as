package com.mindScriptAct.codeSnippets {
import com.mindscriptact.mvcExpressLogger.MvcExpressLogger;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.utils.getTimer;
import flash.utils.setTimeout;

/**
 * ...
 * @author Deril (http://www.mindscriptact.com/)
 */
public class MvcExpressSnippets extends Sprite {
	
	private var appModule:SnippetAppModule;
	
	public function MvcExpressSnippets():void {
		MvcExpressLogger.init(this.stage, 0, 0, 900, 500, 0.9, true, MvcExpressLogger.VISUALIZER_TAB);
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
		setTimeout(start, 300);
	}
	
	private function start():void {
		
		CONFIG::debug {
			MvcExpressLogger.init(this.stage, 0, 0, 800);
		}
		
		////////////////////////////
		// Inits framework.
		////////////////////////////
		appModule = new SnippetAppModule();
		////////////////////////////
		// start our application.
		////////////////////////////
		appModule.start(this);
	}

}

}