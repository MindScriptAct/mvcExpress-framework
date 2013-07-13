package com.mindScriptAct.mvcExpressLiveVisualizer.engine {
import com.mindScriptAct.mvcExpressLiveVisualizer.model.TestColorVO;

import flash.display.Shape;

import mvcexpress.dlc.live.Task;

/**
 * COMMENT
 * @author rBanevicius
 */
public class AlphaTask extends Task {

	[Inject(name="testview_ALPHA")]
	public var testRectangle:Shape;

	[Inject(name="testdata_ALPHA")]
	public var testData:TestColorVO;

	[Inject(name="testdata_ALL")]
	public var outData:TestColorVO;

	override public function run():void {
		testRectangle.rotation += 10;
	}

}
}