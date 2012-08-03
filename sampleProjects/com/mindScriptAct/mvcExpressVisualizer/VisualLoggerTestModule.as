package com.mindScriptAct.mvcExpressVisualizer {
import com.bit101.components.PushButton;
import com.mindScriptAct.modules.console.Console;
import com.mindScriptAct.modules.ModuleNames;
import com.mindscriptact.mvcExpressLogger.MvcExpressLogger;
import com.mindScriptAct.mvcExpressVisualizer.model.ITestProxyB;
import com.mindScriptAct.mvcExpressVisualizer.model.TestProxyA;
import com.mindScriptAct.mvcExpressVisualizer.model.TestProxyB;
import com.mindScriptAct.mvcExpressVisualizer.model.TestProxyC;
import com.mindScriptAct.mvcExpressVisualizer.msg.DataMsg;
import com.mindScriptAct.mvcExpressVisualizer.msg.Msg;
import com.mindScriptAct.mvcExpressVisualizer.msg.ViewMsg;
import com.mindScriptAct.mvcExpressVisualizer.view.testA.TestViewA;
import com.mindScriptAct.mvcExpressVisualizer.view.testA.TestViewAMediator;
import com.mindScriptAct.mvcExpressVisualizer.view.testB.TestViewB;
import com.mindScriptAct.mvcExpressVisualizer.view.testB.TestViewBMediator;
import com.mindScriptAct.mvcExpressVisualizer.view.VisualLoggerTestModuleMediator;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import org.mvcexpress.modules.ModuleSprite;
import org.mvcexpress.utils.checkClassStringConstants;

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
	
	public function VisualLoggerTestModule() {
		CONFIG::debug {
			checkClassStringConstants(Msg, DataMsg, ViewMsg);
			MvcExpressLogger.init(this.stage, 600, 0, 900, 400, 1, true);
		}
		super(ModuleNames.SHELL);
		//
		this.stage.align = StageAlign.TOP_LEFT;
		this.stage.scaleMode = StageScaleMode.NO_SCALE;
	}
	
	override protected function onInit():void {
		trace("ModularSampleShellModule.onInit");
		
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
		
		testProxyCButton = new PushButton(this, 180, 570, "Add TestProxyC", handleAddProxyC);
		
		
		var console:Console = new Console();
		this.addChild(console);
		console.x = 500;
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
			testViewB1.y = 250;
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
			testViewB2.y = 250;
		}
	}

}
}