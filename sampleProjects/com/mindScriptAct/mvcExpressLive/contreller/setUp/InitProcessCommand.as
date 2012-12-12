package com.mindScriptAct.mvcExpressLive.contreller.setUp {

import com.mindScriptAct.mvcExpressLive.processes.frameProc.tasks.ATask;
import com.mindScriptAct.mvcExpressLive.processes.frameProc.tasks.BTask;
import com.mindScriptAct.mvcExpressLive.processes.frameProc.tasks.C1Task;
import com.mindScriptAct.mvcExpressLive.processes.frameProc.tasks.C2Task;
import com.mindScriptAct.mvcExpressLive.processes.frameProc.TestProcess;
import flash.utils.getTimer;
import org.mvcexpress.core.namespace.mvcExpressLive;
import org.mvcexpress.live.Process;
import org.mvcexpress.live.Task;
import org.mvcexpress.mvc.Command;

/**
 * TODO:CLASS COMMENT
 * @author rBanevicius
 */
public class InitProcessCommand extends Command {
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	public function execute(blank:Object):void {
		
		var process:Process = processMap.initTimerProcess(TestProcess);
		
		var aTask:Task = process.mapTask(ATask);
		var bTask:Task = process.mapTask(BTask);
		var c1Task:Task = process.mapTask(C1Task);
		var c2Task:Task = process.mapTask(C2Task);
		
		process.addHeadTask(aTask);
		aTask.addTask(bTask);
		bTask.forkTask(c1Task, c2Task);
		
		processMap.startProcess(TestProcess);
		processMap.stopProcess(TestProcess);
		processMap.startProcess(TestProcess);
		
		
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