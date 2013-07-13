package com.mindScriptAct.mvcExpressLiveVisualizer.engine {
import com.mindScriptAct.mvcExpressLiveVisualizer.model.TestColorVO;

import flash.display.Shape;

import mvcexpress.dlc.live.Task;

/**
 * COMMENT
 * @author rBanevicius
 */
public class GreenTask extends Task {

	[Inject(name="testview_GREEN")]
	public var testRectangle:Shape;

	[Inject(name="testdata_GREEN")]
	public var testData:TestColorVO;

	[Inject(name="testdata_ALL")]
	public var outData:TestColorVO;

	override public function run():void {
		testRectangle.rotation += 10;
	}

}
}