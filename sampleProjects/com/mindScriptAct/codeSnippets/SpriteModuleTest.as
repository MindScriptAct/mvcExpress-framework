package com.mindScriptAct.codeSnippets {
import com.mindScriptAct.codeSnippets.controller.ManyInjectsCommand;
import com.mindScriptAct.codeSnippets.controller.params.ComplexParams;
import com.mindScriptAct.codeSnippets.controller.SampleCommand;
import com.mindScriptAct.codeSnippets.messages.DataMsg;
import com.mindScriptAct.codeSnippets.messages.Msg;
import com.mindScriptAct.codeSnippets.messages.ViewMsg;
import com.mindScriptAct.codeSnippets.model.ISampleEmptyProxy;
import com.mindScriptAct.codeSnippets.model.ISampleProxy;
import com.mindScriptAct.codeSnippets.model.SampleEmptyProxy;
import com.mindScriptAct.codeSnippets.model.SampleProxy;
import com.mindScriptAct.codeSnippets.view.keyboard.KeyboardMediator;
import com.mindScriptAct.codeSnippets.view.MainAppMediator;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.utils.Proxy;
import flash.utils.setTimeout;
import org.mvcexpress.modules.ModuleSprite;
import org.mvcexpress.MvcExpress;
import org.mvcexpress.utils.checkClassStringConstants;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class SpriteModuleTest extends ModuleSprite {
	
	public function SpriteModuleTest() {
		trace("SpriteModuleTest.SpriteModuleTest");
		
		//
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		//
		
	}
	
	override protected function onInit():void {
		
		CONFIG::debug {
			
			MvcExpress.debugFunction = trace;
			
			checkClassStringConstants(Msg, DataMsg, ViewMsg);
		}
		
		////////////////////////////
		// Proxy
		// - can be maped as already constucted object or class. Class will be automaticaly instantiated.
		// - proxies are mapet to injectClass+name. if dublication occure error is thrown.
		// - order is important if one proxy uses enother proxy.
		////////////////////////////
		
		proxyMap.map(new SampleEmptyProxy("Simple proxy"));
		proxyMap.map(new SampleEmptyProxy("Interfaced proxy"), ISampleEmptyProxy);
		proxyMap.map(new SampleEmptyProxy("Named proxy"), SampleEmptyProxy, "namedSampleProxy");
		proxyMap.map(new SampleEmptyProxy("Named and interfaced proxy"), ISampleEmptyProxy, "namedSampleInterfacedProxy");
		
		var sameSampleProxy:SampleProxy = new SampleProxy()
		
		proxyMap.unmap(SampleEmptyProxy);
		
		proxyMap.map(sameSampleProxy);
		proxyMap.map(sameSampleProxy, ISampleProxy);
		proxyMap.map(sameSampleProxy, SampleProxy, "testType");
		proxyMap.map(sameSampleProxy, ISampleProxy, "interfaceProxy");
		
		////////////////////////////
		// View
		// - view classes are maped to mediator classes 1 to 1.
		////////////////////////////
		
		mediatorMap.map(SpriteModuleTest, MainAppMediator);
		
		// bad maping... (throws error.)
		//mediatorMap.map(Sprite, Sprite);
		
		// bad execute test...
		//var badCommand:SampleEmptyCommand = new SampleEmptyCommand();
		//badCommand.execute(null);
		
		////////////////////////////
		// controller
		////////////////////////////
		commandMap.map(Msg.TEST, SampleCommand);
		//commandMap.unmap(Msg.TEST, SampleCommand);
		
		commandMap.execute(SampleCommand);
		commandMap.execute(SampleCommand, "single execute parameter");
		commandMap.execute(SampleCommand, new ComplexParams("complex execute parameters"));
		
		
		
		// command with many injects
		commandMap.execute(ManyInjectsCommand);
		
		////////////////////////////
		// comunication
		////////////////////////////
		sendMessage(Msg.TEST);
		sendMessage(Msg.TEST, "single message parameter");
		sendMessage(Msg.TEST, new ComplexParams("complex message parameters"));
		
		////////////////////////////
		// start application...
		// - mediate mainView object 
		// AND
		// - execute commands OR send messages if needed.
		////////////////////////////
		
		mediatorMap.mediate(this);
		//mediatorMap.unmediate(mvcExpressSnippets);
		
		//mediatorMap.mediateWith(this.stage, KeyboardMediator);
	}

}
}