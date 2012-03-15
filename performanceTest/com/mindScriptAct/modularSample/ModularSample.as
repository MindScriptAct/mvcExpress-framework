package com.mindScriptAct.modularSample {
import flash.display.Sprite;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ModularSample extends Sprite {
	private var coreModule:ModularSampleShellModule;
	
	public function ModularSample() {
		coreModule = new ModularSampleShellModule();
		coreModule.start(this);
	}

}
}