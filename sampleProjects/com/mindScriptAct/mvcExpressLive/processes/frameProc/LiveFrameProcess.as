package com.mindScriptAct.mvcExpressLive.processes.frameProc {
import com.mindScriptAct.mvcExpressLive.processes.frameProc.tasks.XTask;
import org.mvcexpress.live.Process;
import org.mvcexpress.live.Task;

/**
 * COMMENT
 * @author rBanevicius
 */
public class LiveFrameProcess extends Process {
	
	override public function onRegister():void {
		
		var xTask:Task = this.mapTask(XTask);
		this.addHeadTask(xTask);
	}

}
}