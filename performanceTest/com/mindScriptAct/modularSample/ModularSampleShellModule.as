package com.mindScriptAct.modularSample {
import com.mindScriptAct.modularSample.view.ModularSampleMediator;
import org.mvcexpress.core.ModuleCore;

/**
 * COMMENT
 * @author rbanevicius
 */
public class ModularSampleShellModule extends ModuleCore {
	private var moduleSample:ModularSample;
	
	public function ModularSampleShellModule(moduleSample:ModularSample) {
		this.moduleSample = moduleSample;
		super();
	
	}
	
	override protected function onStartUp():void {
		trace("ModularSampleCore.startup");
		
		mediatorMap.map(ModularSample, ModularSampleMediator);
		
		mediatorMap.mediate(moduleSample);
	
		//commandMap.execute();
	
		//sendMessage(Msg.ADD_CONSOLE);
	
	}

}
}