package com.mindScriptAct.mvcExpressLive {
import com.bit101.components.PushButton;
import com.mindScriptAct.mvcExpressLive.contreller.setUp.InitProcessCommand;
import com.mindScriptAct.mvcExpressLive.messages.LiveMesasge;
import com.mindScriptAct.mvcExpressLive.model.LiveProxy;
import com.mindScriptAct.mvcExpressLive.view.LiveView;
import com.mindScriptAct.mvcExpressLive.view.LiveViewMediator;
import com.mindScriptAct.mvcExpressLive.view.guiTest.LiveGuiTest;
import com.mindScriptAct.mvcExpressLive.view.guiTest.LiveGuiTestMediator;

import flash.events.Event;

import mvcexpress.dlc.live.modules.ModuleCoreLive;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class LiveSampleModule extends ModuleCoreLive {

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

		var liveGuiTest:LiveGuiTest = new LiveGuiTest();
		main.addChild(liveGuiTest);
		mediatorMap.mediateWith(liveGuiTest, LiveGuiTestMediator);

		commandMap.execute(InitProcessCommand);

		var testButton1:PushButton = new PushButton(main, 600, 510, "stopSwuares", handleStopSquares);
		var testButton2:PushButton = new PushButton(main, 600, 530, "startSwuares", handleStartSquares);
	}

	private function handleStopSquares(event:Event):void {
		sendMessage(LiveMesasge.STOP_SQUARES);
	}

	private function handleStartSquares(event:Event):void {
		sendMessage(LiveMesasge.START_SQUARES);

	}

	override protected function onDispose():void {
	}

}
}