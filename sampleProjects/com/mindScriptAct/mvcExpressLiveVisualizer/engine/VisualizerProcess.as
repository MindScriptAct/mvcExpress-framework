package com.mindScriptAct.mvcExpressLiveVisualizer.engine {
import com.mindScriptAct.mvcExpressLiveVisualizer.messages.VizualizerMessage;
import com.mindScriptAct.mvcExpressLiveVisualizer.model.ProcessInjectProxy;
import com.mindScriptAct.mvcExpressLiveVisualizer.view.ColorControls;

import mvcexpress.dlc.live.Process;

/**
 * COMMENT
 * @author rBanevicius
 */
public class VisualizerProcess extends Process {

	[Inject]
	public var processInject:ProcessInjectProxy;


	override protected function onRegister():void {

		trace(processInject.testData);

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
		if (hasTask(task.taskClass)) {
			enableTask(task.taskClass);
		}
	}

	private function handleDisableTask(task:ColorControls):void {
		if (hasTask(task.taskClass)) {
			disableTask(task.taskClass);
		}
	}

	override protected function onRemove():void {
	}

}
}