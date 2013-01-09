package com.mindScriptAct.mvcExpressLiveVisualizer.engine {
	import com.mindScriptAct.mvcExpressLiveVisualizer.messages.VizualizerMessage;
	import org.mvcexpress.live.Process;
	import org.mvcexpress.live.Task;
	
	
/**
 * COMMENT
 * @author rBanevicius
 */
public class VisualizerProcess extends Process {
	
	
	override protected function onRegister():void {
		
		addHandler(VizualizerMessage.ADD, handleAddTask);
		addHandler(VizualizerMessage.REMOVE, handleRemoveTask);
	}
	
	private function handleRemoveTask(taskClass:Class):void {
		addTask(taskClass);
	}
	
	private function handleAddTask(taskClass:Class):void {
		removeTask(taskClass);
	}
	
	override protected function onRemove():void {
	}
	
}
}