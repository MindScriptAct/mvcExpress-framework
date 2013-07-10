package com.mindScriptAct.mvcExpressVisualizer {
import com.bit101.components.Label;
import com.bit101.components.PushButton;
import com.mindScriptAct.modules.ModuleNames;
import com.mindScriptAct.modules.console.Console;
import com.mindScriptAct.mvcExpressVisualizer.controller.TestCommandA;
import com.mindScriptAct.mvcExpressVisualizer.controller.TestCommandB;
import com.mindScriptAct.mvcExpressVisualizer.controller.TestCommandBlank;
import com.mindScriptAct.mvcExpressVisualizer.messages.Message;
import com.mindScriptAct.mvcExpressVisualizer.model.ITestProxyB;
import com.mindScriptAct.mvcExpressVisualizer.model.TestProxyA;
import com.mindScriptAct.mvcExpressVisualizer.model.TestProxyB;
import com.mindScriptAct.mvcExpressVisualizer.model.TestProxyC;
import com.mindScriptAct.mvcExpressVisualizer.msg.DataMsg;
import com.mindScriptAct.mvcExpressVisualizer.msg.Msg;
import com.mindScriptAct.mvcExpressVisualizer.msg.ViewMsg;
import com.mindScriptAct.mvcExpressVisualizer.view.VisualLoggerTestModuleMediator;
import com.mindScriptAct.mvcExpressVisualizer.view.testA.TestViewA;
import com.mindScriptAct.mvcExpressVisualizer.view.testA.TestViewAMediator;
import com.mindScriptAct.mvcExpressVisualizer.view.testB.TestViewB;
import com.mindScriptAct.mvcExpressVisualizer.view.testB.TestViewBMediator;
import com.mindscriptact.mvcExpressLogger.MvcExpressLogger;

import flash.display.Shape;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Point;

import mvcexpress.MvcExpress;
import mvcexpress.utils.checkClassStringConstants;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class VisualLoggerTestModule extends ModuleSprite {
	private var testViewA1Button:PushButton;
	private var testViewA1:TestViewA;
	private var testViewA2Button:PushButton;
	private var testViewA2:TestViewA;
	private var testViewB1Button:PushButton;
	private var testViewB1:TestViewB;
	private var testViewB2Button:PushButton;
	private var testViewB2:TestViewB;
	private var testProxyCButton:PushButton;
	private var testProxyC:TestProxyC;
	private var testMessageB1Button:PushButton;
	private var testMessageB2Button:PushButton;
	private var testMessageB3Button:PushButton;

	public function VisualLoggerTestModule() {
		CONFIG::debug {
			MvcExpress.debugFunction = trace;
			//MvcExpress.debugFunction = myDebugFunction;
			checkClassStringConstants(Msg, DataMsg, ViewMsg);
		}
		MvcExpressLogger.init(this.stage, 600, 0, 900, 400, 1, true, MvcExpressLogger.VISUALIZER_TAB);
		super(ModuleNames.SHELL);
		//
		this.stage.scaleMode = StageScaleMode.NO_SCALE;
	}

	//private function myDebugFunction(traceObj:TraceObj):void {
	//if (traceObj.action == MvcTraceActions.MEDIATORMAP_MEDIATE) {
	//if (traceObj.mediatorClass == TestViewAMediator) {
	//trace( "TestViewAMediator mediates :" +  traceObj.viewObject);
	//}
	//}
	//}

	override protected function onInit():void {
		var moduleLabel:Label;
		var roundRectangle:Shape;
		//trace("ModularSampleShellModule.onInit");

		// shell module area
		roundRectangle = new Shape();
		roundRectangle.graphics.lineStyle(2, 0x000000);
		roundRectangle.graphics.beginFill(0xE1E1FF);
		roundRectangle.graphics.drawRoundRect(5, 5, 570, 590, 20);
		roundRectangle.graphics.endFill();
		this.addChild(roundRectangle);

		moduleLabel = new Label(this, 10, 5, "MODULE:shell");
		moduleLabel.textField.textColor = 0x000000;


		// set up controller
		commandMap.map(Message.TEST_COMMAND_B, TestCommandB);
		commandMap.map(Message.TEST_MEDIATOR_A_COMMAND, TestCommandA);
		commandMap.map(Message.TEST_MEDIATOR_B_COMMAND, TestCommandB);
		commandMap.map(Message.TEST_PROXY_TO_COMMAND, TestCommandBlank);
		commandMap.map(Message.TEST_COMMAND_TO_COMMAND, TestCommandBlank);

		// set up data
		proxyMap.map(new TestProxyA());
		proxyMap.map(new TestProxyB(), ITestProxyB, "BProxyName");

		// set-up view
		mediatorMap.map(VisualLoggerTestModule, VisualLoggerTestModuleMediator);
		mediatorMap.map(TestViewA, TestViewAMediator);
		mediatorMap.map(TestViewB, TestViewBMediator);

		// start
		mediatorMap.mediate(this);

		//
		testViewA1Button = new PushButton(this, 10, 500, "Add TestViewA 1", handleAddMediatorA1);
		testViewA2Button = new PushButton(this, 150, 500, "Add TestViewA 2", handleAddMediatorA2);

		testViewB1Button = new PushButton(this, 10, 530, "Add TestViewB 1", handleAddMediatorB1);
		testViewB2Button = new PushButton(this, 150, 530, "Add TestViewB 2", handleAddMediatorB2);

		testMessageB1Button = new PushButton(this, 300, 500, "Module:Execute CommandA", handleCommandA);
		testMessageB1Button.width = 170;
		testMessageB2Button = new PushButton(this, 300, 530, "Module: message to command", handleCommandB);
		testMessageB3Button = new PushButton(this, 300, 555, "Module: message to mediator", handleCommandC);
		testMessageB2Button.width = 170;
		testMessageB3Button.width = 170;

		testProxyCButton = new PushButton(this, 180, 570, "Add TestProxyC", handleAddProxyC);

		// console module area
		roundRectangle = new Shape();
		roundRectangle.graphics.lineStyle(2, 0x000000);
		roundRectangle.graphics.beginFill(0xE1E1FF);
		roundRectangle.graphics.drawRoundRect(600, 430, 380, 170, 20);
		roundRectangle.graphics.endFill();
		this.addChild(roundRectangle);

		moduleLabel = new Label(this, 600 + 10, 430 + 5, "MODULE:Console0");
		moduleLabel.textField.textColor = 0x000000;

		var console:Console = new Console();
		this.addChild(console);
		console.x = 600;
		console.y = 450;
	}


	private function handleAddProxyC(event:Event):void {
		if (testProxyC) {
			proxyMap.unmap(TestProxyC);
			testProxyC = null;
			testProxyCButton.label = "Add TestProxyC";
		} else {
			testProxyC = new TestProxyC();
			proxyMap.map(testProxyC);
			testProxyCButton.label = "Remove TestProxyC";
		}
	}

	private function handleAddMediatorA1(event:Event):void {
		if (testViewA1) {
			mediatorMap.unmediate(testViewA1);
			this.removeChild(testViewA1);
			testViewA1 = null;
			testViewA1Button.label = "Add TestViewA 1";
		} else {
			testViewA1 = new TestViewA();
			this.addChild(testViewA1);
			mediatorMap.mediate(testViewA1);
			testViewA1Button.label = "Remove TestViewA 1";
			testViewA1.x = 20;
			testViewA1.y = 20;
		}
	}

	private function handleAddMediatorA2(event:Event):void {
		if (testViewA2) {
			mediatorMap.unmediate(testViewA2);
			this.removeChild(testViewA2);
			testViewA2 = null;
			testViewA2Button.label = "Add TestViewA 2";
		} else {
			testViewA2 = new TestViewA();
			this.addChild(testViewA2);
			mediatorMap.mediate(testViewA2);
			testViewA2Button.label = "Remove TestViewA 2";
			testViewA2.x = 300;
			testViewA2.y = 20;
		}
	}

	private function handleAddMediatorB1(event:Event):void {
		if (testViewB1) {
			mediatorMap.unmediate(testViewB1);
			this.removeChild(testViewB1);
			testViewB1 = null;
			testViewB1Button.label = "Add TestViewB 1";

		} else {
			testViewB1 = new TestViewB();
			this.addChild(testViewB1);
			mediatorMap.mediate(testViewB1);
			testViewB1Button.label = "Remove TestViewB 1";
			testViewB1.x = 20;
			testViewB1.y = 200;
		}
	}

	private function handleAddMediatorB2(event:Event):void {
		if (testViewB2) {
			mediatorMap.unmediate(testViewB2);
			this.removeChild(testViewB2);
			testViewB2 = null;
			testViewB2Button.label = "Add TestViewB 2";
		} else {
			testViewB2 = new TestViewB();
			this.addChild(testViewB2);
			mediatorMap.mediate(testViewB2);
			testViewB2Button.label = "Remove TestViewB 2";
			testViewB2.x = 300;
			testViewB2.y = 200;
		}
	}

	private function handleCommandA(event:Event):void {
		commandMap.execute(TestCommandA, "test param A")
	}

	private function handleCommandB(event:Event):void {
		sendMessage(Message.TEST_COMMAND_B, new Point(10, 20));
	}

	private function handleCommandC(event:Event):void {
		sendMessage(Message.TEST_MODULE_TO_MEDIATORS_A);
	}

}
}