package com.mindScriptAct.codeSnippets {
import com.gskinner.performance.PerformanceTest;
import com.mindScriptAct.codeSnippets.controller.params.ComplexParams;
import com.mindScriptAct.codeSnippets.controller.SampleCommand;
import com.mindScriptAct.codeSnippets.messages.Msg;
import com.mindScriptAct.codeSnippets.model.ISampleEmptyProxy;
import com.mindScriptAct.codeSnippets.model.ISampleProxy;
import com.mindScriptAct.codeSnippets.model.SampleEmptyProxy;
import com.mindScriptAct.codeSnippets.model.SampleProxy;
import com.mindScriptAct.codeSnippets.view.keyboard.KeyboardMediator;
import com.mindScriptAct.codeSnippets.view.SampleAppMediator;
import flash.display.Sprite;
import org.mvcexpress.core.ModuleCore;

/**
 * COMMENT
 * @author rbanevicius
 */
public class SnippetAppModule extends ModuleCore {
	private var performanceTest:PerformanceTest;
	private var coreInitTime:int;
	
	////////////////////////////
	// Module constructor.
	// It initiates the framewokr.
	// in most cases you will not use change it, 
	// You could just delete it and let superClass handle construction.
	////////////////////////////
	public function SnippetAppModule() {
		super();
	}
	
	////////////////////////////
	// Function called then framework is started and ready for work.
	////////////////////////////
	override protected function onInit():void {
		trace("SampleAppModule.onStartup");
		
		////////////////////////////
		// Proxy
		// - can be maped as already constucted object or class. Class will be automaticaly instantiated.
		// - proxies are mapet to injectClass+name. if dublication occure error is thrown.
		// - order is important if one proxy uses enother proxy.
		////////////////////////////
		
		proxyMap.mapObject(new SampleEmptyProxy("Simple proxy"));
		proxyMap.mapObject(new SampleEmptyProxy("Interfaced proxy"), ISampleEmptyProxy);
		proxyMap.mapObject(new SampleEmptyProxy("Named proxy"), SampleEmptyProxy, "namedSampleProxy");
		proxyMap.mapObject(new SampleEmptyProxy("Named and interfaced proxy"), ISampleEmptyProxy, "namedSampleInterfacedProxy");
		
		proxyMap.mapClass(SampleProxy);
		proxyMap.mapClass(SampleProxy, ISampleProxy);
		proxyMap.mapClass(SampleProxy, SampleProxy, "testType");
		proxyMap.mapClass(SampleProxy, ISampleProxy, "interfaceProxy");
		
		////////////////////////////
		// View
		// - view classes are maped to mediator classes 1 to 1.
		////////////////////////////
		
		mediatorMap.map(MvcExpressSnippets, SampleAppMediator);
		
		////////////////////////////
		// controller
		////////////////////////////
		commandMap.map(Msg.TEST, SampleCommand);
		//commandMap.unmap(Msg.TEST, SampleCommand);
		
		commandMap.execute(SampleCommand);
		commandMap.execute(SampleCommand, "single execute parameter");
		commandMap.execute(SampleCommand, new ComplexParams("complex execute parameters"));
		
		////////////////////////////
		// comunication
		////////////////////////////
		sendMessage(Msg.TEST);
		sendMessage(Msg.TEST, "single message parameter");
		sendMessage(Msg.TEST, new ComplexParams("complex message parameters"));
	
	}
	
	public function start(mvcExpressSnippets:MvcExpressSnippets):void {
		////////////////////////////
		// start application...
		// - mediate mainView object 
		// AND
		// - execute commands OR send messages if needed.
		////////////////////////////
		
		mediatorMap.mediate(mvcExpressSnippets);
		//mediatorMap.unmediate(mvcExpressSnippets);
		
		
		mediatorMap.mediateWith(mvcExpressSnippets.stage, KeyboardMediator);
		
	}
	
	////////////////////////////
	// called just before module is disposed to put your clean-up code here.
	// Main module don't need this function as it is never shutDown.
	////////////////////////////
	override protected function onDispose():void {
		// dispose module
	}

}
}