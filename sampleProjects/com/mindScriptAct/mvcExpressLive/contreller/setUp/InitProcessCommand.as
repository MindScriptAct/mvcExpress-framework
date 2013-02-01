package com.mindScriptAct.mvcExpressLive.contreller.setUp {

import com.mindScriptAct.mvcExpressLive.processes.frameProc.LiveFrameProcess;
import com.mindScriptAct.mvcExpressLive.processes.timerProc.LiveTimerProcess;
import org.mvcexpress.mvc.Command;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class InitProcessCommand extends Command {
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	public function execute(blank:Object):void {
		
		processMap.mapTimerProcess(LiveTimerProcess, 500);
		processMap.startProcess(LiveTimerProcess);
		
		processMap.mapFrameProcess(LiveFrameProcess, 100);
		processMap.startProcess(LiveFrameProcess);
	
		//var frameProcess:Process = processMap.initFrameProcess(TestProcess, 100);
		//
	
		//frameProcess.addHeadTask(bTask);
		//
		//processMap.startProcess(TestProcess);
	
		// Small speed test.
		//var aTask:Task = process.mapTask(ATask);
		//process.addHeadTask(aTask);
		//
		//var lastTask:Task = aTask;
		//for (var i:int = 0; i < 100; i++) {
		//var bTask:Task = process.mapTask(BTask);
		//lastTask.addTask(bTask);
		//lastTask = bTask;
		//}
		//
		//use namespace mvcExpressLive;
		//
		///*---------->*/var testTime_1:int = getTimer();
		///*->*/var testCount_1:int = 10000;
		///*->*/for (var j:int = 0; j < testCount_1; j++) {
		//process.runProcess();
		///*->*/}
		///*->*/var testResult_1:int = getTimer() - testTime_1;
		///*---------->*/trace("Test done", "\tTotal time:", testResult_1, "\tavr time:", testResult_1 / testCount_1,"\t[*"+testCount_1+"]", "\tRuns per 1ms:", 1 / (testResult_1 / testCount_1));
	
	}

}
}