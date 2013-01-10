package com.mindScriptAct.mvcExpressLiveVisualizer.engine {
import com.mindScriptAct.mvcExpressLiveVisualizer.messages.VizualizerMessage;
import com.mindScriptAct.mvcExpressLiveVisualizer.view.ColorControls;
import org.mvcexpress.live.Process;
import org.mvcexpress.live.Task;

/**
 * COMMENT
 * @author rBanevicius
 */
public class VisualizerProcess extends Process {
	
	override protected function onRegister():void {
		
		addHandler(VizualizerMessage.ADD, handleAddTask);
		addHandler(VizualizerMessage.ADD_AFTER, handleAddAfterTask);
		addHandler(VizualizerMessage.REMOVE, handleRemoveTask);
	}
	
	private function handleAddAfterTask(task:ColorControls):void {
		addTaskAfter(task.taskClass, task.afterTaskClass);
	}
	
	private function handleRemoveTask(task:ColorControls):void {
		addTask(task.taskClass);
	}
	
	private function handleAddTask(task:ColorControls):void {
		removeTask(task.taskClass);
	}
	
	override protected function onRemove():void {
	}

}
}