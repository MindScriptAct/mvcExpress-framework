package {
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

import noiseandheat.flexunit.visuallistener.VisualListener;

import org.flexunit.internals.TraceListener;
import org.flexunit.runner.FlexUnitCore;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class MvcExpressTestRunner extends Sprite {
	private var listener:VisualListener;

	static public var stage:Stage;

	public function MvcExpressTestRunner() {

		MvcExpressTestRunner.stage = this.stage;

		var core:FlexUnitCore = new FlexUnitCore();

		this.stage.align = StageAlign.TOP_LEFT;
		this.stage.scaleMode = StageScaleMode.NO_SCALE;

		/**If you don't need graphical test results, comment out the line below and the MXML declaring the TestRunnerBase. **/
		//core.addListener(new UIListener(uiListener));
		//core.addListener(new CIListener());

		/**If you would like to see text output in verbose mode, umcomment either of the follow listeners **/
		core.addListener(new TraceListener());
		//core.addListener( TextListener.getDefaultTextListener( LogEventLevel.DEBUG ) ); - For Flex Projects

		listener = new VisualListener(this.stage.stageWidth, this.stage.stageHeight);
		addChild(listener);
		core.addListener(listener);
		core.run(AllTestSuites);
	}

}
}