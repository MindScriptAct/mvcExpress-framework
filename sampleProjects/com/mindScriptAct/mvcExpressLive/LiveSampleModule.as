package com.mindScriptAct.mvcExpressLive {
import com.mindScriptAct.mvcExpressLive.contreller.setUp.InitProcessCommand;
import org.mvcexpress.modules.ModuleCore;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class LiveSampleModule extends ModuleCore {
	
	override protected function onInit():void {
		trace("LiveSampleModule.onInit");
	
	}
	
	public function start(main:LiveSample):void {
		trace("LiveSampleModule.start > main : " + main);
	
		
		commandMap.execute(InitProcessCommand);
	}
	
	override protected function onDispose():void {
	}

}
}