package com.mindScriptAct.mvcExpressLiveVisualizer.engine {
import flash.display.Shape;
import org.mvcexpress.live.Task;

/**
 * COMMENT
 * @author rBanevicius
 */
public class BlueTask extends Task {
	
	[Inject(name="testview_BLUE")]
	public var testRectangle:Shape;
	
	override public function run():void {
		testRectangle.rotation += 20;
	}

}
}