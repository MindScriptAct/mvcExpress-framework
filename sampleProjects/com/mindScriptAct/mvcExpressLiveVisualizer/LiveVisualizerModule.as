package com.mindScriptAct.mvcExpressLiveVisualizer {
import com.mindScriptAct.mvcExpressLiveVisualizer.controller.AddTestProxyCommand;
import com.mindScriptAct.mvcExpressLiveVisualizer.controller.InitVizualizerProcessCommand;
import com.mindScriptAct.mvcExpressLiveVisualizer.controller.RemoveTestProxyCommand;
import com.mindScriptAct.mvcExpressLiveVisualizer.messages.VizualizerMessage;
import com.mindScriptAct.mvcExpressLiveVisualizer.view.ColorControlMediator;
import com.mindScriptAct.mvcExpressLiveVisualizer.view.ColorControls;
import com.mindScriptAct.mvcExpressLiveVisualizer.view.LiveVisualizerMediator;
import com.mindScriptAct.mvcExpressLiveVisualizer.view.test.TestColorRectangle;
import com.mindScriptAct.mvcExpressLiveVisualizer.view.test.TestColorRectangleMediator;
import org.mvcexpress.modules.ModuleCore;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class LiveVisualizerModule extends ModuleCore {
	
	override protected function onInit():void {
		trace("LiveVisualizerModule.onInit");
	
	}
	
	public function start(main:LiveVisualizer):void {
		trace("LiveVisualizerModule.start > main : " + main);
		
		processMap.setStage(main.stage);
		
		commandMap.map(VizualizerMessage.ADD_PROXY, AddTestProxyCommand);
		commandMap.map(VizualizerMessage.REMOVE_PROXY, RemoveTestProxyCommand);
		
		
		mediatorMap.map(LiveVisualizer, LiveVisualizerMediator);
		mediatorMap.map(ColorControls, ColorControlMediator);
		mediatorMap.map(TestColorRectangle, TestColorRectangleMediator);
		
		mediatorMap.mediate(main);
		
		commandMap.execute(InitVizualizerProcessCommand);
	}
	
	override protected function onDispose():void {
	}

}
}