package com.mindScriptAct.mediatorEventSpeedTest {
import com.mindScriptAct.mediatorEventSpeedTest.view.MediatorEventSpeedModuleMediator;
import org.mvcexpress.core.ModuleSprite;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
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