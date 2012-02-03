package com.mindScriptAct.modularSample.modules.console {
import com.mindScriptAct.modularSample.modules.console.controller.HandleInputCommand;
import com.mindScriptAct.modularSample.modules.console.model.ConsoleLogModel;
import com.mindScriptAct.modularSample.modules.console.msg.ConsoleViewMsg;
import com.mindScriptAct.modularSample.modules.console.view.ConsoleMediator;
import org.mvcexpress.core.ModuleCore;

/**
 * COMMENT
 * @author rbanevicius
 */
public class ConsoleModule extends ModuleCore {
	private var consoleMain:Console;
	
	public function ConsoleModule(consoleMain:Console) {
		this.consoleMain = consoleMain;
		super();
	}
	
	override protected function onStartUp():void {
		trace("ConsoleModule.onStartUp");
		
		commandMap.map(ConsoleViewMsg.INPUT_MESSAGE, HandleInputCommand);
		
		modelMap.mapClass(ConsoleLogModel);
		
		mediatorMap.map(Console, ConsoleMediator);
		
		mediatorMap.mediate(consoleMain);
	
	}
}
}