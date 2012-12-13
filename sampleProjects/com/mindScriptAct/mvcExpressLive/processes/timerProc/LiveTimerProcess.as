package com.mindScriptAct.mvcExpressLive.processes.timerProc {
import com.mindScriptAct.mvcExpressLive.processes.timerProc.tasks.ATask;
import com.mindScriptAct.mvcExpressLive.processes.timerProc.tasks.BTask;
import com.mindScriptAct.mvcExpressLive.processes.timerProc.tasks.C1Task;
import com.mindScriptAct.mvcExpressLive.processes.timerProc.tasks.C2Task;
import com.mindScriptAct.mvcExpressLive.processes.timerProc.tasks.D1Task;
import org.mvcexpress.live.Process;
import org.mvcexpress.live.Task;

/**
 * COMMENT
 * @author rBanevicius
 */
public class LiveTimerProcess extends Process {
	
	override public function onRegister():void {
		
		var aTask:Task = this.mapTask(ATask);
		var bTask:Task = this.mapTask(BTask);
		var c1Task:Task = this.mapTask(C1Task);
		var c2Task:Task = this.mapTask(C2Task);
		var d1Task:Task = this.mapTask(D1Task);
		
		
		this.addHeadTask(aTask);
		aTask.addTask(bTask);
		bTask.forkTask(c1Task, c2Task);
		c1Task.addTask(d1Task);
	
		// TODO : add message handler functionality.
		//addHandler();
	}

}
}