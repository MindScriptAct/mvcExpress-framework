package com.mindScriptAct.mvcExpressSpeedTest.module {
import com.mindScriptAct.mvcExpressSpeedTest.AppModule;
import com.mindScriptAct.mvcExpressSpeedTest.model.BlankProxy;
import com.mindScriptAct.mvcExpressSpeedTest.view.testSprite.TestSprite;
import org.mvcexpress.modules.ModuleSprite;

/**
 * COMMENT : todo
 * @author rBanevicius
 */
public class SpeedTestModuleSprite extends ModuleSprite {
	
	static public const NAME:String = "SpeedTestModuleSprite";
	
	public function SpeedTestModuleSprite() {
		super(SpeedTestModuleSprite.NAME);
	}
	
	override protected function onInit():void {
		
		registerScope(AppModule.SPEED_TEST_SCOPE);
		
		proxyMap.map(new BlankProxy());
		
		mediatorMap.map(TestSprite, ModuleTestSpriteMediator);
		
		mediatorMap.mediateWith(this, SpeedTestModuleSpriteMediator);
	}
	
	override protected function onDispose():void {
	
	}

}
}