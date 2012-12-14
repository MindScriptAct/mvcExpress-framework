package com.mindScriptAct.mvcExpressLive.processes.timerProc {
import com.mindScriptAct.mvcExpressLive.messages.LiveMesasge;
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
	
	private var aTask:Task;
	private var bTask:Task;
	private var c1Task:Task;
	private var c2Task:Task;
	private var d1Task:Task;
	
	override public function onRegister():void {
		
		aTask = this.mapTask(ATask);
		bTask = this.mapTask(BTask);
		c1Task = this.mapTask(C1Task);
		c2Task = this.mapTask(C2Task);
		d1Task = this.mapTask(D1Task);
		
		this.addHeadTask(aTask);
		aTask.addTask(bTask);
		//bTask.forkTask(c1Task, c2Task);
		bTask.addTask(c1Task);
		c1Task.addTask(d1Task);
		
		addHandler(LiveMesasge.STOP_SQUARES, handleStopSquares);
		addHandler(LiveMesasge.START_SQUARES, handleStartSquares);
	}
	
	private function handleStartSquares(blank:Object):void {
		trace("LiveTimerProcess.handleStartSquares > blank : " + blank);
		aTask.insertTask(bTask);
		bTask.insertTask(c1Task);
	}
	
	private function handleStopSquares(blank:Object):void {
		trace("LiveTimerProcess.handleStopSquares > blank : " + blank);
		bTask.remove();
		c1Task.remove();
	}

}
}