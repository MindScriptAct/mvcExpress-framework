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
		

	
		addHandler(VizualizerMessage.ADD_RESET_TASK, handleAddResetTask);
		addHandler(VizualizerMessage.REMOVE_RESET_TASK, handleRemoveResetTask);
		
		addHandler(VizualizerMessage.ADD, handleAddTask);
		addHandler(VizualizerMessage.ADD_AFTER, handleAddAfterTask);
		addHandler(VizualizerMessage.REMOVE, handleRemoveTask);
		addHandler(VizualizerMessage.REMOVE_ALL, handleRemoveAllTask);
		
		addHandler(VizualizerMessage.ENABLE, handleEnableTask);
		addHandler(VizualizerMessage.DISABLE, handleDisableTask);
	}
	
	private function handleAddResetTask(blank:Object):void {
		addFirstTask(ResetColorTask);
	}
	
	private function handleRemoveResetTask(blank:Object):void {
		removeTask(ResetColorTask);
	}
	
	private function handleAddTask(task:ColorControls):void {
		removeTask(task.taskClass);
	}
	
	private function handleAddAfterTask(task:ColorControls):void {
		addTaskAfter(task.taskClass, task.afterTaskClass);
	}
	
	private function handleRemoveTask(task:ColorControls):void {
		addTask(task.taskClass);
	}
	
	private function handleRemoveAllTask(blank:Object):void {
		removeAllTasks();
	}
	
	private function handleEnableTask(task:ColorControls):void {
		enableTask(task.taskClass);
	}
	
	private function handleDisableTask(task:ColorControls):void {
		disableTask(task.taskClass);
	}
	
	override protected function onRemove():void {
	}

}
}