package com.mindScriptAct.modularSample {
import com.mindScriptAct.modularSample.modules.console.msg.ConsoleViewMsg;
import com.mindScriptAct.modularSample.msg.DataMsg;
import com.mindScriptAct.modularSample.msg.Msg;
import com.mindScriptAct.modularSample.msg.ViewMsg;
import com.mindScriptAct.modularSample.view.ModularSampleMediator;
import flash.utils.setTimeout;
import org.mvcexpress.core.ModuleCore;
import org.mvcexpress.utils.checkClassStringConstants;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ModularSampleShellModule extends ModuleCore {
	
	override protected function onInit():void {
		trace("ModularSampleShellModule.onInit");
		
		CONFIG::debug {
			checkClassStringConstants(Msg, DataMsg, ViewMsg);
		}
		
		mediatorMap.map(ModularSample, ModularSampleMediator);
	}
	
	public function start(modularSample:ModularSample):void {
		
		mediatorMap.mediate(modularSample);
		
		//commandMap.execute();
	}
	
	
	private function handleMainMsgTest(params:Object):void {
		trace("ModularSampleShellModule.handleMainMsgTest > params : " + params);
	
	}

}
}