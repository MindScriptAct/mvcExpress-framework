package com.mindScriptAct.mvcExpressLiveVisualizer.controller {
import com.mindScriptAct.mvcExpressLiveVisualizer.engine.VisualizerProcess;

import mvcexpress.dlc.live.mvc.CommandLive;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class InitVizualizerProcessCommand extends CommandLive {

	//[Inject]
	//public var myProxy:MyProxy;

	public function execute(blank:Object):void {

		processMap.mapTimerProcess(VisualizerProcess, 100);

		processMap.startProcess(VisualizerProcess);


	}

}
}