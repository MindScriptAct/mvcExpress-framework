package com.mindScriptAct.mvcExpressLiveVisualizer.controller {
import com.mindScriptAct.mvcExpressLiveVisualizer.engine.VisualizerProcess;
import org.mvcexpress.mvc.Command;
	
/**
 * TODO:CLASS COMMENT
 * @author rBanevicius
 */
public class InitVizualizerProcessCommand extends Command{
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	public function execute(blank:Object):void{
		
		processMap.mapTimerProcess(VisualizerProcess);
		
		
		processMap.startProcess(VisualizerProcess);
	}
	
}
}