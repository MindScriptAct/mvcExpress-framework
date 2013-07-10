package com.mindScriptAct.mediatorEventSpeedTest {
import com.mindScriptAct.mediatorEventSpeedTest.view.MediatorEventSpeedModuleMediator;
import mvcexpress.modules.ModuleSprite;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class MediatorEventSpeedModule extends ModuleSprite {

	public function MediatorEventSpeedModule() {

	}

	override protected function onInit():void {
		trace( "MediatorEventSpeedModule.onInit" );

		mediatorMap.map(MediatorEventSpeedModule, MediatorEventSpeedModuleMediator);

		mediatorMap.mediate(this);

	}
}
}