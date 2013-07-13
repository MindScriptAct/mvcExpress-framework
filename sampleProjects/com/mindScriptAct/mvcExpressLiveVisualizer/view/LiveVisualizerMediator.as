package com.mindScriptAct.mvcExpressLiveVisualizer.view {
import com.bit101.components.PushButton;
import com.mindScriptAct.mvcExpressLiveVisualizer.LiveVisualizer;
import com.mindScriptAct.mvcExpressLiveVisualizer.constants.ColorIds;
import com.mindScriptAct.mvcExpressLiveVisualizer.constants.ProvideIds;
import com.mindScriptAct.mvcExpressLiveVisualizer.engine.AlphaTask;
import com.mindScriptAct.mvcExpressLiveVisualizer.engine.BlueTask;
import com.mindScriptAct.mvcExpressLiveVisualizer.engine.GreenTask;
import com.mindScriptAct.mvcExpressLiveVisualizer.engine.RedTask;
import com.mindScriptAct.mvcExpressLiveVisualizer.messages.VizualizerMessage;
import com.mindScriptAct.mvcExpressLiveVisualizer.view.test.TestColorRectangle;

import flash.display.Shape;
import flash.events.Event;
import flash.utils.Dictionary;

import mvcexpress.dlc.live.mvc.MediatorLive;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class LiveVisualizerMediator extends MediatorLive {

	[Inject]
	public var view:LiveVisualizer;

	static public const ADD_PROXY:String = "add Proxy";
	static public const REMOVE_PROXY:String = "remove Proxy";

	static public const ADD_RESET_TASK:String = "add Reset Task";
	static public const REMOVE_RESET_TASK:String = "remove Reset Task";

	private var testMediators:Dictionary = new Dictionary();
	private var addTestProxy:PushButton;
	private var resetColorTaskButton:PushButton;

	//[Inject]
	//public var myProxy:MyProxy;

	override protected function onRegister():void {

		var resetTestShape:Shape = new Shape();
		resetTestShape.graphics.lineStyle(3, 0x000000);
		resetTestShape.graphics.moveTo(0, -25);
		resetTestShape.graphics.lineTo(0, 25);
		view.addChild(resetTestShape);
		resetTestShape.x = 500;
		resetTestShape.y = 25;


		provide(resetTestShape, ProvideIds.TESTVIEW_RESET);


		resetColorTaskButton = new PushButton(view, 50, 15, ADD_RESET_TASK, handleAddResetTask);

		var redColorControls:ColorControls = new ColorControls(ColorIds.RED, RedTask, null);
		redColorControls.y = 50;

		var greenColorControls:ColorControls = new ColorControls(ColorIds.GREEN, GreenTask, null);
		greenColorControls.y = 100;

		var blueColorControls:ColorControls = new ColorControls(ColorIds.BLUE, BlueTask, null);
		blueColorControls.y = 150;

		var alphaColorControls:ColorControls = new ColorControls(ColorIds.ALPHA, AlphaTask, BlueTask);
		alphaColorControls.y = 200;

		view.addChild(redColorControls);
		view.addChild(greenColorControls);
		view.addChild(blueColorControls);
		view.addChild(alphaColorControls);

		mediatorMap.mediate(redColorControls);
		mediatorMap.mediate(greenColorControls);
		mediatorMap.mediate(blueColorControls);
		mediatorMap.mediate(alphaColorControls);

		var clearAll:PushButton = new PushButton(view, 100, 500, "Remove all.", handleRemoveAll);

		addTestProxy = new PushButton(view, 250, 500, ADD_PROXY, handleAddProxy);

		addHandler(VizualizerMessage.ADD_MEDIATOR, handleAddMediator);
		addHandler(VizualizerMessage.REMOVE_MEDIATOR, handleRemoveMediator);

	}

	private function handleAddResetTask(event:Event):void {
		if (resetColorTaskButton.label == REMOVE_RESET_TASK) {
			resetColorTaskButton.label = ADD_RESET_TASK;
			sendMessage(VizualizerMessage.REMOVE_RESET_TASK);
		} else {
			resetColorTaskButton.label = REMOVE_RESET_TASK;
			sendMessage(VizualizerMessage.ADD_RESET_TASK);
		}
	}

	private function handleAddProxy(event:Event):void {
		if (addTestProxy.label == REMOVE_PROXY) {
			addTestProxy.label = ADD_PROXY;
			sendMessage(VizualizerMessage.REMOVE_PROXY);
		} else {
			addTestProxy.label = REMOVE_PROXY;
			sendMessage(VizualizerMessage.ADD_PROXY, ColorIds.ALL);
		}
	}

	private function handleAddMediator(colorId:String):void {
		var testRectangle:TestColorRectangle = new TestColorRectangle(colorId);

		view.addChild(testRectangle);
		mediatorMap.mediate(testRectangle);

		testMediators[colorId] = testRectangle;

	}

	private function handleRemoveMediator(colorId:String):void {
		view.removeChild(testMediators[colorId]);
		mediatorMap.unmediate(testMediators[colorId]);
		delete testMediators[colorId];
	}

	private function handleRemoveAll(event:Event):void {
		resetColorTaskButton.label = ADD_RESET_TASK;
		sendMessage(VizualizerMessage.REMOVE_ALL);
	}

	override protected function onRemove():void {

	}

}
}