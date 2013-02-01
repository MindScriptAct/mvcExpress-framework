package com.mindScriptAct.modularSample {
import com.mindScriptAct.modularSample.constants.ScopeNames;
import com.mindScriptAct.modularSample.msg.DataMsg;
import com.mindScriptAct.modularSample.msg.Msg;
import com.mindScriptAct.modularSample.msg.ViewMsg;
import com.mindScriptAct.modularSample.view.ModularSampleMediator;
import com.mindScriptAct.modules.ModuleNames;
import com.mindscriptact.mvcExpressLogger.MvcExpressLogger;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import org.mvcexpress.modules.ModuleSprite;
import org.mvcexpress.utils.checkClassStringConstants;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ModularSample extends ModuleSprite {
	
	public function ModularSample() {
		CONFIG::debug {
			checkClassStringConstants(Msg, DataMsg, ViewMsg);
			MvcExpressLogger.init(this.stage, 700, 0, 800, 400, 1, true);
		}
		super(ModuleNames.SHELL);
		//
		this.stage.align = StageAlign.TOP_LEFT;
		this.stage.scaleMode = StageScaleMode.NO_SCALE;
	
	}
	
	override protected function onInit():void {
		trace("ModularSampleShellModule.onInit");
		
		registerScope(ScopeNames.FIRST_SCOPE);
		registerScope(ScopeNames.EVEN_SCOPE);
		registerScope(ScopeNames.ALL_SCORE);
		
		
		mediatorMap.map(ModularSample, ModularSampleMediator);
		
		mediatorMap.mediate(this);
	
	}

}
}