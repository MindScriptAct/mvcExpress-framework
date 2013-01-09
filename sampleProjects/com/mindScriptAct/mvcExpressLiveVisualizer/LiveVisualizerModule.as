package com.mindScriptAct.mvcExpressLiveVisualizer {
import com.mindScriptAct.mvcExpressLiveVisualizer.controller.InitVizualizerProcessCommand;
import com.mindScriptAct.mvcExpressLiveVisualizer.view.ColorControlMediator;
import com.mindScriptAct.mvcExpressLiveVisualizer.view.ColorControls;
import com.mindScriptAct.mvcExpressLiveVisualizer.view.LiveVisualizerMediator;
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
		
		
		
		mediatorMap.map(LiveVisualizer, LiveVisualizerMediator);
		mediatorMap.map(ColorControls, ColorControlMediator);
		
		mediatorMap.mediate(main);
		
		
		commandMap.execute(InitVizualizerProcessCommand);
		
		//
		//proxyMap.map(new LiveProxy());
		//
		//var liveView:LiveView = new LiveView();
		//main.addChild(liveView);
		//mediatorMap.map(LiveView, LiveViewMediator);
		//mediatorMap.mediate(liveView);
		//
		//var liveGuiTest:LiveGuiTest = new LiveGuiTest();
		//main.addChild(liveGuiTest);
		//mediatorMap.mediateWith(liveGuiTest, LiveGuiTestMediator);
		//
		//commandMap.execute(InitProcessCommand);
		//
		//var testButton1:PushButton = new PushButton(main, 600, 510, "stopSwuares", handleStopSquares);
		//var testButton2:PushButton = new PushButton(main, 600, 530, "startSwuares", handleStartSquares);
	}
	
	//private function handleStopSquares(event:Event):void {
	//sendMessage(LiveMesasge.STOP_SQUARES);
	//}
	//
	//private function handleStartSquares(event:Event):void {
	//sendMessage(LiveMesasge.START_SQUARES);
	//
	//}
	
	override protected function onDispose():void {
	}

}
}