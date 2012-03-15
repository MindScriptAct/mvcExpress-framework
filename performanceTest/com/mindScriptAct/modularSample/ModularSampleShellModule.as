package com.mindScriptAct.modularSample {
import com.mindScriptAct.modularSample.view.ModularSampleMediator;
import org.mvcexpress.core.ModuleCore;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ModularSampleShellModule extends ModuleCore {
	
	override protected function onInit():void {
		trace( "ModularSampleShellModule.onInit" );
		
		mediatorMap.map(ModularSample, ModularSampleMediator);
	}
	
	public function start(modularSample:ModularSample):void {
		
		mediatorMap.mediate(modularSample);
	
		//commandMap.execute();
	
		//sendMessage(Msg.ADD_CONSOLE);
	}

}
}