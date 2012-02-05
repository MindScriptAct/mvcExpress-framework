package com.mindScriptAct.modularSample.modules.console {
import com.mindScriptAct.modularSample.modules.console.controller.HandleInputCommand;
import com.mindScriptAct.modularSample.modules.console.model.ConsoleLogProxy;
import com.mindScriptAct.modularSample.modules.console.msg.ConsoleViewMsg;
import com.mindScriptAct.modularSample.modules.console.view.ConsoleMediator;
import org.mvcexpress.core.ModuleCore;

/**
 * COMMENT
 * @author rbanevicius
 */
public class ConsoleModule extends ModuleCore {
	
	public function ConsoleModule() {
		super();
	}
	
	override protected function onInit():void {
		trace("ConsoleModule.onStartUp");
		
		commandMap.map(ConsoleViewMsg.INPUT_MESSAGE, HandleInputCommand);
		
		proxyMap.mapClass(ConsoleLogProxy);
		
		mediatorMap.map(Console, ConsoleMediator);
	
	}
	
	public function start(console:Console):void {
		mediatorMap.mediate(console);
	}
}
}