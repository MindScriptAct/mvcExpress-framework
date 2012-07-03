package com.mindScriptAct.modularSample.modules.console {
import com.mindScriptAct.modularSample.modules.console.controller.HandleInputCommand;
import com.mindScriptAct.modularSample.modules.console.model.ConsoleLogProxy;
import com.mindScriptAct.modularSample.modules.console.msg.ConsoleDataMsg;
import com.mindScriptAct.modularSample.modules.console.msg.ConsoleMsg;
import com.mindScriptAct.modularSample.modules.console.msg.ConsoleViewMsg;
import com.mindScriptAct.modularSample.modules.console.view.ConsoleMediator;
import org.mvcexpress.core.ModuleCore;
import org.mvcexpress.utils.checkClassStringConstants;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ConsoleModule extends ModuleCore {
	
	public function ConsoleModule() {
		super();
	}
	
	override protected function onInit():void {
		trace("ConsoleModule.onStartUp");
		
		CONFIG::debug {
			checkClassStringConstants(ConsoleMsg, ConsoleDataMsg, ConsoleViewMsg);
		}
		
		commandMap.map(ConsoleViewMsg.INPUT_MESSAGE, HandleInputCommand);
		
		proxyMap.map(new ConsoleLogProxy());
		
		mediatorMap.map(Console, ConsoleMediator);
	
	}
	
	public function start(console:Console):void {
		mediatorMap.mediate(console);
	}
}
}