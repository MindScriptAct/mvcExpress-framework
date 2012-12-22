package com.mindScriptAct.mvcExpressLive.processes.frameProc {
import com.mindScriptAct.mvcExpressLive.processes.frameProc.tasks.XTask;
import org.mvcexpress.live.Process;
import org.mvcexpress.live.Task;

/**
 * COMMENT
 * @author rBanevicius
 */
public class LiveFrameProcess extends Process {
	
	override protected function onRegister():void {
		this.addTask(XTask);
	}

}
}