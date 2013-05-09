package com.mindScriptAct.moduleAutoinitTest {
import flash.display.Sprite;

/**
 * COMMENT
 * @author ...
 */
public class ModuleAutoInitTest extends Sprite {
	
	public function ModuleAutoInitTest() {
		var autoInitFalseModule:AutoInitFalseModule = new AutoInitFalseModule();
		autoInitFalseModule.start();
	}

}
}