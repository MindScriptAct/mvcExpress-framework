package com.mindScriptAct.mvcExpressSpeedTest {
import com.gskinner.performance.MethodTest;
import com.gskinner.performance.PerformanceTest;
import com.gskinner.performance.TestSuite;
import com.mindScriptAct.mvcExpressSpeedTest.constants.TestNames;
import com.mindScriptAct.mvcExpressSpeedTest.controller.EmptyCommand;
import com.mindScriptAct.mvcExpressSpeedTest.controller.EmptyPooledCommand;
import com.mindScriptAct.mvcExpressSpeedTest.controller.GetParamCommand;
import com.mindScriptAct.mvcExpressSpeedTest.controller.GetParamPooledCommand;
import com.mindScriptAct.mvcExpressSpeedTest.controller.Inject10Command;
import com.mindScriptAct.mvcExpressSpeedTest.controller.Inject5Command;
import com.mindScriptAct.mvcExpressSpeedTest.controller.Inject6Command;
import com.mindScriptAct.mvcExpressSpeedTest.controller.TestNamedProxysCommand;
import com.mindScriptAct.mvcExpressSpeedTest.controller.TraceCommand;
import com.mindScriptAct.mvcExpressSpeedTest.controller.WithProxyCommand;
import com.mindScriptAct.mvcExpressSpeedTest.controller.WithProxyCommViews5Command;
import com.mindScriptAct.mvcExpressSpeedTest.controller.WithProxyCommViews5PooledCommand;
import com.mindScriptAct.mvcExpressSpeedTest.controller.WithProxyCommViewsCommand;
import com.mindScriptAct.mvcExpressSpeedTest.controller.WithProxyCommViewsPooledCommand;
import com.mindScriptAct.mvcExpressSpeedTest.controller.WithProxyPooledCommand;
import com.mindScriptAct.mvcExpressSpeedTest.model.BlankProxy;
import com.mindScriptAct.mvcExpressSpeedTest.model.INamedProxy;
import com.mindScriptAct.mvcExpressSpeedTest.model.NamedProxy;
import com.mindScriptAct.mvcExpressSpeedTest.module.SpeedTestModuleSprite;
import com.mindScriptAct.mvcExpressSpeedTest.notes.Note;
import com.mindScriptAct.mvcExpressSpeedTest.view.application.MvcExpressTestMediator;
import com.mindScriptAct.mvcExpressSpeedTest.view.testSprite.TestSprite;
import com.mindScriptAct.mvcExpressSpeedTest.view.testSprite.TestSpriteMediator;
import flash.events.Event;
import flash.system.Capabilities;
import flash.utils.getTimer;
import mvcexpress.modules.ModuleCore;
import mvcexpress.utils.checkClassStringConstants;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class AppModule extends ModuleCore {

	static public const SPEED_TEST_SCOPE:String = "speedTestScope";

	private var performanceTest:PerformanceTest;
	private var coreInitTime:int;

	public function AppModule() {
		super();
	}

	override protected function onInit():void {
		registerScope(AppModule.SPEED_TEST_SCOPE);
	}

	public function start(mvcExpressSpeedTest:MvcExpressSpeedTest):void {
		coreInitTime = getTimer() - mvcExpressSpeedTest.initTime;

		CONFIG::debug {
			checkClassStringConstants(Note);
		}

		trace("AppModule.startup");

		//commandMap.map(Note.TEST, Inject1Command);
		commandMap.map(Note.TEST_COMMAND_0, EmptyCommand);
		commandMap.map(Note.TEST_COMMAND_6, Inject6Command);
		commandMap.map(Note.TEST_COMMAND_5, Inject5Command);
		commandMap.map(Note.TEST_COMMAND_10, Inject10Command);

		commandMap.map(Note.CALL_COMMANDS_EMPTY, EmptyCommand);
		commandMap.map(Note.CALL_COMMANDS_GET_PARAMS, GetParamCommand);
		commandMap.map(Note.CALL_COMMANDS_WITH_MODEL, WithProxyCommand);
		commandMap.map(Note.CALL_COMMANDS_WITH_MODEL_COMM_VIEWS, WithProxyCommViewsCommand);
		commandMap.map(Note.CALL_COMMANDS_WITH_MODEL_COMM_VIEWS_5, WithProxyCommViews5Command);

		commandMap.map(Note.CALL_COMMANDS_POOLED_EMPTY, EmptyPooledCommand);
		commandMap.map(Note.CALL_COMMANDS_POOLED_GET_PARAMS, GetParamPooledCommand);
		commandMap.map(Note.CALL_COMMANDS_POOLED_WITH_MODEL, WithProxyPooledCommand);
		commandMap.map(Note.CALL_COMMANDS_POOLED_WITH_MODEL_COMM_VIEWS, WithProxyCommViewsPooledCommand);
		commandMap.map(Note.CALL_COMMANDS_POOLED_WITH_MODEL_COMM_VIEWS_5, WithProxyCommViews5PooledCommand);
		//
		proxyMap.map(new BlankProxy());
		//
		//
		mediatorMap.map(MvcExpressSpeedTest, MvcExpressTestMediator);
		mediatorMap.map(TestSprite, TestSpriteMediator);

		mediatorMap.mediate(mvcExpressSpeedTest);

		var speedModuleSplite:SpeedTestModuleSprite = new SpeedTestModuleSprite();
		mvcExpressSpeedTest.addChild(speedModuleSplite);

		//
		// start
		//super.startup();

		//messagingTest();

		//commandMapTest();
		//mediatorTest();

		//namedProxyTesting();

		// init testing
		prepareTests();

	}

	private function namedProxyTesting():void {
		proxyMap.map(new NamedProxy("first Named Proxy"), NamedProxy, "namedProxy_1");
		proxyMap.map(new NamedProxy("Second Named Proxy"), NamedProxy, "namedProxy_2");
		proxyMap.map(new NamedProxy("Proxy maped to interface."), INamedProxy);

		proxyMap.map(new NamedProxy());

		proxyMap.map(new NamedProxy(), INamedProxy, "namedSingletonInterface");

		commandMap.execute(TestNamedProxysCommand);

	}

	private function mediatorTest():void {
		sendMessage(Note.CREATE_TEST_VIEW, 1);
		sendMessage(Note.REMOVE_TEST_VIEW, 1);
		sendMessage(Note.REMOVE_TEST_VIEW, 1);
	}

	private function prepareTests():void {
		performanceTest = new PerformanceTest();

		performanceTest.queueSimpleTest(sendMessage, [Note.TEST_COMMAND_0], TestNames.COMMAND_EMPTY, 100, 10000);
		performanceTest.queueSimpleTest(sendMessage, [Note.TEST_COMMAND_5], TestNames.COMMAND_INJECT_5, 100, 10000);
		performanceTest.queueSimpleTest(sendMessage, [Note.TEST_COMMAND_10], TestNames.COMMAND_INJECT_10, 100, 10000);

		performanceTest.queueSimpleTest(sendMessage, [Note.CALL_COMMANDS_EMPTY], TestNames.COMMAND_EMPTY, 50, 10000);
		performanceTest.queueSimpleTest(sendMessage, [Note.CALL_COMMANDS_GET_PARAMS, "testData"], TestNames.COMMAND_PARAMS, 50, 10000);
		performanceTest.queueSimpleTest(sendMessage, [Note.CALL_COMMANDS_WITH_MODEL], TestNames.COMMAND_MODEL, 50, 10000);
		performanceTest.queueSimpleTest(sendMessage, [Note.CALL_COMMANDS_WITH_MODEL_COMM_VIEWS], TestNames.COMMAND_MODEL_AND_VIEW, 50, 10000);
		performanceTest.queueSimpleTest(sendMessage, [Note.CALL_COMMANDS_WITH_MODEL_COMM_VIEWS_5], TestNames.COMMAND_MODEL_AND_VIEW_5, 50, 10000);

		performanceTest.queueSimpleTest(sendMessage, [Note.CALL_COMMANDS_POOLED_EMPTY], TestNames.COMMAND_POOLED_EMPTY, 50, 10000);
		performanceTest.queueSimpleTest(sendMessage, [Note.CALL_COMMANDS_POOLED_GET_PARAMS, "testData"], TestNames.COMMAND_POOLED_PARAMS, 50, 10000);
		performanceTest.queueSimpleTest(sendMessage, [Note.CALL_COMMANDS_POOLED_WITH_MODEL], TestNames.COMMAND_POOLED_MODEL, 50, 10000);
		performanceTest.queueSimpleTest(sendMessage, [Note.CALL_COMMANDS_POOLED_WITH_MODEL_COMM_VIEWS], TestNames.COMMAND_POOLED_MODEL_AND_VIEW, 50, 10000);
		performanceTest.queueSimpleTest(sendMessage, [Note.CALL_COMMANDS_POOLED_WITH_MODEL_COMM_VIEWS_5], TestNames.COMMAND_POOLED_MODEL_AND_VIEW_5, 50, 10000);
		//
		performanceTest.queueSimpleTest(sendMessage, [Note.CREATE_TEST_VIEW, 1], TestNames.MEDIATOR_CREATE_1000, 2, 500);
		performanceTest.queueSimpleTest(sendMessage, [Note.REMOVE_TEST_VIEW, 1], TestNames.MEDIATOR_REMOVE_1000, 2, 500);
		performanceTest.queueSimpleTest(sendMessage, [Note.CREATE_TEST_VIEW, 1], TestNames.MEDIATOR_CREATE_2000, 4, 500);
		performanceTest.queueSimpleTest(sendMessage, [Note.REMOVE_TEST_VIEW, 1], TestNames.MEDIATOR_REMOVE_2000, 4, 500);
		performanceTest.queueSimpleTest(sendMessage, [Note.CREATE_TEST_VIEW, 1], TestNames.MEDIATOR_CREATE_5000, 10, 500);
		performanceTest.queueSimpleTest(sendMessage, [Note.REMOVE_TEST_VIEW, 1], TestNames.MEDIATOR_REMOVE_5000, 10, 500);

		performanceTest.queueSimpleTest(sendMessage, [Note.ACTIVATE_MEDIATOR], TestNames.MEDIATOR_COMMUNICATE_1, 100, 10000);

		performanceTest.queueTestSuite(new TestSuite([new MethodTest(sendMessage, [Note.COMMUNICATION_TEST, 1], TestNames.MEDIATOR_COMMUNICATE_100, 50, 1000)], "Communication test 100", null, spawn100Mediators));
		performanceTest.queueTestSuite(new TestSuite([new MethodTest(sendMessage, [Note.COMMUNICATION_TEST, 1], TestNames.MEDIATOR_COMMUNICATE_200, 50, 1000)], "Communication test 200", null, spawn100Mediators));
		performanceTest.queueTestSuite(new TestSuite([new MethodTest(sendMessage, [Note.COMMUNICATION_TEST, 1], TestNames.MEDIATOR_COMMUNICATE_500, 40, 1000)], "Communication test 500", null, spawn300Mediators));
		var ts:TestSuite = performanceTest.queueTestSuite(new TestSuite([new MethodTest(sendMessage, [Note.COMMUNICATION_TEST, 1], TestNames.MEDIATOR_COMMUNICATE_1000, 30, 1000)], "Communication test 1000", null, spawn500Mediators));
		ts.addEventListener(Event.COMPLETE, removeAllViews);

		performanceTest.queueTestSuite(new TestSuite([new MethodTest(scopeSendMessage, [Note.COMMUNICATION_TEST, 1], TestNames.SCOPED_MEDIATOR_COMMUNICATE_100, 50, 1000)], "Scoped communication test 100", null, spawn100ScopedMediators));
		performanceTest.queueTestSuite(new TestSuite([new MethodTest(scopeSendMessage, [Note.COMMUNICATION_TEST, 1], TestNames.SCOPED_MEDIATOR_COMMUNICATE_200, 50, 1000)], "scoped communication test 200", null, spawn100ScopedMediators));
		performanceTest.queueTestSuite(new TestSuite([new MethodTest(scopeSendMessage, [Note.COMMUNICATION_TEST, 1], TestNames.SCOPED_MEDIATOR_COMMUNICATE_500, 40, 1000)], "Scoped communication test 500", null, spawn300ScopedMediators));
		var ts2:TestSuite = performanceTest.queueTestSuite(new TestSuite([new MethodTest(scopeSendMessage, [Note.COMMUNICATION_TEST, 1], TestNames.SCOPED_MEDIATOR_COMMUNICATE_1000, 30, 1000)], "Scoped communication test 1000", null, spawn500ScopedMediators));
		ts2.addEventListener(Event.COMPLETE, removeAllScopedViews);

		//
		performanceTest.addEventListener(Event.COMPLETE, handleTestComplete);
		performanceTest.addEventListener(Event.CLOSE, handleTestClose);
		//
		sendMessage(Note.APPEND_LINE, "mvcExpress testing:       [" + (Capabilities.isDebugger ? "DEBUG" : "RELEASE") + " PLAYER. " + Capabilities.version + "]");
		sendMessage(Note.APPEND_LINE, TestNames.CORE_INIT + ":" + "\t" + coreInitTime);
	}

	private function scopeSendMessage(message:String, params:Object):void {
		sendScopeMessage(AppModule.SPEED_TEST_SCOPE, message, params);
	}

	//----------------------------------
	//     mediator creation
	//----------------------------------
	private function spawn100Mediators():void {
		for (var i:int = 0; i < 100; i++) {
			sendMessage(Note.CREATE_TEST_VIEW, 1);
		}
	}

	private function spawn300Mediators():void {
		for (var i:int = 0; i < 300; i++) {
			sendMessage(Note.CREATE_TEST_VIEW, 1);
		}
	}

	private function spawn500Mediators():void {
		for (var i:int = 0; i < 500; i++) {
			sendMessage(Note.CREATE_TEST_VIEW, 1);
		}
	}

	private function removeAllViews(event:Event):void {
		for (var i:int = 0; i < 1000; i++) {
			sendMessage(Note.REMOVE_TEST_VIEW, 1);
		}
	}

	//----------------------------------
	//     another module mediator creation
	//----------------------------------

	private function spawn100ScopedMediators():void {
		for (var i:int = 0; i < 100; i++) {
			sendScopeMessage(AppModule.SPEED_TEST_SCOPE, Note.CREATE_TEST_VIEW, 1);
		}
	}

	private function spawn300ScopedMediators():void {
		for (var i:int = 0; i < 300; i++) {
			sendScopeMessage(AppModule.SPEED_TEST_SCOPE, Note.CREATE_TEST_VIEW, 1);
		}
	}

	private function spawn500ScopedMediators():void {
		for (var i:int = 0; i < 500; i++) {
			sendScopeMessage(AppModule.SPEED_TEST_SCOPE, Note.CREATE_TEST_VIEW, 1);
		}
	}

	private function removeAllScopedViews(event:Event):void {
		for (var i:int = 0; i < 1000; i++) {
			sendScopeMessage(AppModule.SPEED_TEST_SCOPE, Note.REMOVE_TEST_VIEW, 1);
		}
	}

	//----------------------------------
	//     test handling
	//----------------------------------

	private function handleTestClose(event:Event):void {
		//trace( "RobotTestContext.handleTestClose > event : " + event );
		sendMessage(Note.APPEND_LINE, "ALL TESTS DONE!");
	}

	private function handleTestComplete(event:Event):void {
		//trace("RobotTestContext.handleTestComplete > event : " + event);
		if (performanceTest.currentTest) {
			sendMessage(Note.APPEND_LINE, performanceTest.currentTest.name + ":" + "\t" + (performanceTest.currentTest.time / performanceTest.currentTest.loops) + "\t" + performanceTest.currentTest.toString());
		}

	}

	public function commandMapTest():void {
		commandMap.map(Note.TEST, TraceCommand);

		sendMessage(Note.TEST, "text");
		//sendMessage(Note.TEST, new Sprite());
	}

	//private function messagingTest():void {
	//addCallback(Note.TEST, simpleTest1);
	//
	//sendMessage(Note.TEST);
	//
	//trace("-----");
	//addCallback(Note.TEST, simpleTest2);
	//
	//sendMessage(Note.TEST);
	//
	//trace("-----");
	//
	//addCallback(Note.TEST, simpleTest2);
	//
	//sendMessage(Note.TEST);
	//
	//trace("-----");
	//
	//removeCallback(Note.TEST, simpleTest2);
	//removeCallback(Note.TEST, simpleTest2);
	//removeCallback(Note.TEST, simpleTest1);
	//
	//sendMessage(Note.TEST);
	//
	//trace("-----");
	//
	//messenger.addCallback(Note.TEST, simpleTest1);
	//
	//messenger.addCallback(Note.TEST, simpleTest2);
	//
	//sendMessage(Note.TEST, null, "aaa");
	//sendMessage(Note.TEST, null);
	//trace("-----");
	//messenger.addCallback(Note.TEST, simpleTest2);
	//sendMessage(Note.TEST, null, "aaa");
	//trace("-----");
	//sendMessage(Note.TEST, null);
	//}

	//----------------------------------
	//
	//----------------------------------

}
}