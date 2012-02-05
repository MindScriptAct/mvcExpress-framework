package com.mindScriptAct.smallSample {
	import flash.display.Sprite;
	
	
/**
 * COMMENT
 * @author rbanevicius
 */
public class SampleMain extends Sprite {
	
	public function SampleMain() {
		var sampleModule:SampleModule = new SampleModule();
		sampleModule.start(this);
	}
	
}
}