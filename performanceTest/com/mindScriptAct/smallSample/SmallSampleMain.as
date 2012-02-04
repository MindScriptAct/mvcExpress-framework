package com.mindScriptAct.smallSample {
	import flash.display.Sprite;
	
	
/**
 * COMMENT
 * @author rbanevicius
 */
public class SmallSampleMain extends Sprite {
	
	public function SmallSampleMain() {
		var sampleModule:SmallSampleModule = new SmallSampleModule();
		sampleModule.start(this);
	}
	
}
}