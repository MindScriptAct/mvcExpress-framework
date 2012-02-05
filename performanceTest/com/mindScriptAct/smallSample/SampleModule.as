package com.mindScriptAct.smallSample {
import com.mindScriptAct.smallSample.controller.setup.SetupCommandsCommand;
import com.mindScriptAct.smallSample.controller.setup.SetupMeditorsCommand;
import com.mindScriptAct.smallSample.controller.setup.SetupProxiesCommand;
import com.mindScriptAct.smallSample.controller.TestCommand;
import flash.geom.Matrix;
import flash.geom.Point;
import org.mvcexpress.core.ModuleCore;

/**
 * COMMENT
 * @author rbanevicius
 */
public class SampleModule extends ModuleCore {
	
	public function SampleModule() {
		super();
	}
	
	override protected function onInit():void {
		trace("SmallSampleModule.onStartUp");
		
		// set up view
		
		commandMap.execute(SetupCommandsCommand);
		
		commandMap.execute(SetupProxiesCommand);
		
		commandMap.execute(SetupMeditorsCommand);
		
		commandMap.map("doMatrix", TestCommand);
		sendMessage("doMatrix", new Matrix(1, 2, 3, 4, 5, 6));
	
		// start mediating stage object.
	
	}
	
	public function start(smallSampleMain:SampleMain):void {
		mediatorMap.mediate(smallSampleMain);
		sendMessage("moveBg", new Point(100, 10));
	}
}
}