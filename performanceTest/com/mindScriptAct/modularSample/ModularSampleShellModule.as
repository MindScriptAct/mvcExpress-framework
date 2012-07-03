package com.mindScriptAct.modularSample {
import com.mindScriptAct.modularSample.modules.console.msg.ConsoleDataMsg;
import com.mindScriptAct.modularSample.modules.console.msg.ConsoleViewMsg;
import com.mindScriptAct.modularSample.msg.Msg;
import com.mindScriptAct.modularSample.view.ModularSampleMediator;
import flash.utils.setTimeout;
import org.mvcexpress.core.ModuleCore;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ModularSampleShellModule extends ModuleCore {
	
	override protected function onInit():void {
		trace("ModularSampleShellModule.onInit");
		
		mediatorMap.map(ModularSample, ModularSampleMediator);
	}
	
	public function start(modularSample:ModularSample):void {
		
		mediatorMap.mediate(modularSample);
		
		//commandMap.execute();
		
		//sendMessage(Msg.ADD_CONSOLE);
		
		addHandler(ConsoleViewMsg.EMPTY_MESSAGE, handleMainMsgTest);
		
		setTimeout(handleRemover, 10000);
	}
	
	private function handleRemover():void {
		trace("enough of empty message tracing...... ");
		removeHandler(ConsoleViewMsg.EMPTY_MESSAGE, handleMainMsgTest);
	}
	
	private function handleMainMsgTest(params:Object):void {
		trace("ModularSampleShellModule.handleMainMsgTest > params : " + params);
	
	}

}
}