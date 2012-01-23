package com.mindScriptAct.pureLegsTest {
import com.gskinner.performance.MethodTest;
import com.gskinner.performance.PerformanceTest;
import com.gskinner.performance.TestSuite;
import com.mindScriptAct.pureLegsTest.constants.TestNames;
import com.mindScriptAct.pureLegsTest.controller.EmptyCommand;
import com.mindScriptAct.pureLegsTest.controller.GetParamCommand;
import com.mindScriptAct.pureLegsTest.controller.Inject10Command;
import com.mindScriptAct.pureLegsTest.controller.Inject5Command;
import com.mindScriptAct.pureLegsTest.controller.Inject6Command;
import com.mindScriptAct.pureLegsTest.controller.TestNamedModelsCommand;
import com.mindScriptAct.pureLegsTest.controller.TraceCommand;
import com.mindScriptAct.pureLegsTest.controller.WithModelCommand;
import com.mindScriptAct.pureLegsTest.controller.WithModelCommViewsCommand;
import com.mindScriptAct.pureLegsTest.model.BlankModel;
import com.mindScriptAct.pureLegsTest.model.INamedModel;
import com.mindScriptAct.pureLegsTest.model.NamedModel;
import com.mindScriptAct.pureLegsTest.notes.Note;
import com.mindScriptAct.pureLegsTest.view.application.PureLegsTestMediator;
import com.mindScriptAct.pureLegsTest.view.testSprite.TestSprite;
import com.mindScriptAct.pureLegsTest.view.testSprite.TestSpriteMediator;
import flash.display.Sprite;
import flash.events.Event;
import flash.system.Capabilities;
import flash.utils.getTimer;
import org.pureLegs.base.CoreModule;

/**
 * COMMENT
 * @author rbanevicius
 */
public class AppModule extends CoreModule {
	public var view:Sprite;
	private var performanceTest:PerformanceTest;
	private var coreInitTime:int;
	
	public function AppModule(view:Sprite){
		this.view = view;
		super();
	}
	
	override public function startup():void {
		trace("AppModule.startup");
		
		coreInitTime = getTimer() - (view as PureLegsTesting).initTime;
		
		//commandMap.map(Note.TEST, Inject1Command);
		commandMap.map(Note.TEST_COMMAND_0, EmptyCommand);
		commandMap.map(Note.TEST_COMMAND_6, Inject6Command);
		commandMap.map(Note.TEST_COMMAND_5, Inject5Command);
		commandMap.map(Note.TEST_COMMAND_10, Inject10Command);
		
		commandMap.map(Note.CALL_COMMANDS_EMPTY, EmptyCommand);
		commandMap.map(Note.CALL_COMMANDS_GET_PARAMS, GetParamCommand);
		commandMap.map(Note.CALL_COMMANDS_WITH_MODEL, WithModelCommand);
		commandMap.map(Note.CALL_COMMANDS_WITH_MODEL_COMM_VIEWS, WithModelCommViewsCommand);
		
		//
		modelMap.mapClass(BlankModel);
		//
		//
		mediatorMap.mapMediator(PureLegsTesting, PureLegsTestMediator);
		mediatorMap.mapMediator(TestSprite, TestSpriteMediator);
		
		mediatorMap.mediate(view);
		//
		// start
		//super.startup();
		
		//messagingTest();
		
		//commandMapTest();
		//mediatorTest();
		
		//namedModelTesting();
		
		// init testing
		prepareTests();
	
	}
	
	private function namedModelTesting():void {
		modelMap.mapObject(new NamedModel("first Named Model"), NamedModel, "namedModel_1");
		modelMap.mapObject(new NamedModel("Second Named Model"), NamedModel, "namedModel_2");
		modelMap.mapObject(new NamedModel("Model maped to interface."), INamedModel);
		
		modelMap.mapClass(NamedModel);
		
		modelMap.mapClass(NamedModel, INamedModel, "namedSingletonInterface");
		
		commandMap.execute(TestNamedModelsCommand);
	}
	
	private function mediatorTest():void {
		sendMessage(Note.CREATE_TEST_VIEW, 1);
		sendMessage(Note.REMOVE_TEST_VIEW, 1);
		sendMessage(Note.REMOVE_TEST_VIEW, 1);
	}
	
	private function prepareTests():void {
		performanceTest = new PerformanceTest();
		//performanceTest.queueSimpleTest(sendMessage, [Note.TEST_COMMAND_0], TestNames.COMMAND_EMPTY, 100, 1000);
		//performanceTest.queueSimpleTest(sendMessage, [Note.TEST_COMMAND_5], TestNames.COMMAND_INJECT_5, 100, 1000);
		//performanceTest.queueSimpleTest(sendMessage, [Note.TEST_COMMAND_10], TestNames.COMMAND_INJECT_10, 100, 1000);
		
		performanceTest.queueSimpleTest(sendMessage, [Note.CALL_COMMANDS_EMPTY], TestNames.COMMAND_EMPTY, 50, 10000);
		performanceTest.queueSimpleTest(sendMessage, [Note.CALL_COMMANDS_GET_PARAMS, "testData"], TestNames.COMMAND_PARAMS, 50, 10000);
		performanceTest.queueSimpleTest(sendMessage, [Note.CALL_COMMANDS_WITH_MODEL], TestNames.COMMAND_MODEL, 50, 10000);
		performanceTest.queueSimpleTest(sendMessage, [Note.CALL_COMMANDS_WITH_MODEL_COMM_VIEWS], TestNames.COMMAND_MODEL_AND_VIEW, 50, 10000);
		
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
		performanceTest.queueTestSuite(new TestSuite([new MethodTest(sendMessage, [Note.COMMUNICATION_TEST, 1], TestNames.MEDIATOR_COMMUNICATE_1000, 30, 1000)], "Communication test 1000", null, spawn500Mediators));
		
		performanceTest.addEventListener(Event.COMPLETE, handleTestComplete);
		performanceTest.addEventListener(Event.CLOSE, handleTestClose);
		
		sendMessage(Note.APPEND_LINE, "PureLegs testing:       [" + (Capabilities.isDebugger ? "DEBUG" : "RELEASE") + " PLAYER. " + Capabilities.version + "]");
		sendMessage(Note.APPEND_LINE, TestNames.CORE_INIT + ":" + "\t" + coreInitTime);
	}
	
	private function spawn100Mediators():void {
		for (var i:int = 0; i < 100; i++){
			sendMessage(Note.CREATE_TEST_VIEW, 1);
		}
	}
	
	private function spawn300Mediators():void {
		for (var i:int = 0; i < 300; i++){
			sendMessage(Note.CREATE_TEST_VIEW, 1);
		}
	}
	
	private function spawn500Mediators():void {
		for (var i:int = 0; i < 500; i++){
			sendMessage(Note.CREATE_TEST_VIEW, 1);
		}
	}
	
	private function handleTestClose(event:Event):void {
		//trace( "RobotTestContext.handleTestClose > event : " + event );
		for (var i:int = 0; i < 1000; i++){
			sendMessage(Note.REMOVE_TEST_VIEW, 1);
		}
		sendMessage(Note.APPEND_LINE, "ALL TESTS DONE!");
	}
	
	private function handleTestComplete(event:Event):void {
		//trace("RobotTestContext.handleTestComplete > event : " + event);
		if (performanceTest.currentTest){
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
	
	private function simpleTest1(params:Object):void {
		trace("AppModule.simpleTest1");
	}
	
	public function simpleTest2(params:Object):void {
		trace("AppModule.simpleTest2");
	}

}
}