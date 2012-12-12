package com.mindScriptAct.mvcExpressLive {
import com.mindScriptAct.mvcExpressLive.contreller.setUp.InitProcessCommand;
import com.mindScriptAct.mvcExpressLive.model.LiveProxy;
import com.mindScriptAct.mvcExpressLive.view.LiveView;
import com.mindScriptAct.mvcExpressLive.view.LiveViewMediator;
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
	
		processMap.setStage(main.stage);
		
		
		proxyMap.map(new LiveProxy());
		
		
		
		
		var liveView:LiveView = new LiveView();
		main.addChild(liveView);
		mediatorMap.map(LiveView, LiveViewMediator);
		mediatorMap.mediate(liveView);
		
		
		
		
		
		commandMap.execute(InitProcessCommand);
	}
	
	override protected function onDispose():void {
	}

}
}