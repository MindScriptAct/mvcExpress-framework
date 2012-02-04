package com.mindScriptAct.smallSample {
import com.mindScriptAct.smallSample.controller.setUp.SetUpMeditorsCommand;
import com.mindScriptAct.smallSample.controller.setUp.SetUpModelsCommand;
import com.mindScriptAct.smallSample.controller.TestCommand;
import flash.geom.Matrix;
import flash.geom.Point;
import org.mvcexpress.core.ModuleCore;

/**
 * COMMENT
 * @author rbanevicius
 */
public class SmallSampleModule extends ModuleCore {
	
	public function SmallSampleModule() {
		super();
	}
	
	override protected function onInit():void {
		trace("SmallSampleModule.onStartUp");
		
		// set up view
		
		commandMap.execute(SetUpModelsCommand);
		
		commandMap.execute(SetUpMeditorsCommand);
		
		commandMap.map("doMatrix", TestCommand);
		sendMessage("doMatrix", new Matrix(1, 2, 3, 4, 5, 6));
	
		// start mediating stage object.
	
	}
	
	public function start(smallSampleMain:SmallSampleMain):void {
		mediatorMap.mediate(smallSampleMain);
		sendMessage("moveBg", new Point(100, 10));
	}
}
}