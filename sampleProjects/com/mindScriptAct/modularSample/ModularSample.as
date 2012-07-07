package com.mindScriptAct.modularSample {
import com.mindScriptAct.modularSample.msg.DataMsg;
import com.mindScriptAct.modularSample.msg.Msg;
import com.mindScriptAct.modularSample.msg.ViewMsg;
import com.mindScriptAct.modularSample.view.ModularSampleMediator;
import org.mvcexpress.core.ModuleSprite;
import org.mvcexpress.utils.checkClassStringConstants;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ModularSample extends ModuleSprite {
	
	
	public function ModularSample() {
		super("shell");
	}
	
	override protected function onInit():void {
		trace("ModularSampleShellModule.onInit");
		
		CONFIG::debug {
			checkClassStringConstants(Msg, DataMsg, ViewMsg);
		}
		
		mediatorMap.map(ModularSample, ModularSampleMediator);
		
		mediatorMap.mediate(this);
	}

}
}