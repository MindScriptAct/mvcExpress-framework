package com.mindScriptAct.mvcExpressLiveVisualizer.engine {
import com.mindScriptAct.mvcExpressLiveVisualizer.model.TestColorVO;

import flash.display.Shape;

import mvcexpress.dlc.live.Task;

/**
 * COMMENT
 * @author rBanevicius
 */
public class ResetColorTask extends Task {

	[Inject(name="testdata_ALL")]
	public var outData:TestColorVO;

	[Inject(name="testViewReset")]
	public var testView:Shape;

	override public function run():void {
		testView.rotation += 10;
	}

}
}