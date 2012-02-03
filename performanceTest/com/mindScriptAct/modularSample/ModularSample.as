package com.mindScriptAct.modularSample {
import flash.display.Sprite;

/**
 * COMMENT
 * @author rbanevicius
 */
public class ModularSample extends Sprite {
	private var coreModule:ModularSampleShellModule;
	
	public function ModularSample() {
		coreModule = new ModularSampleShellModule(this);
	}

}
}