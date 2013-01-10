package com.mindScriptAct.mvcExpressLiveVisualizer.engine {
import flash.display.Shape;
import org.mvcexpress.live.Task;

/**
 * COMMENT
 * @author rBanevicius
 */
public class AlphaTask extends Task {
	
	[Inject(name="testview_ALPHA")]
	public var testRectangle:Shape;
	
	override public function run():void {
		testRectangle.rotation += 20;
	}

}
}