// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.live {
import org.mvcexpress.core.namespace.mvcExpressLive;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class Task {
	
	mvcExpressLive var forks:Vector.<Task>;
	
	mvcExpressLive var forkId:int = 0;
	
	public function run():void {
	
	}
	
	public function addTask(task:Task):void {
		use namespace mvcExpressLive;
		if (forks) {
			throw Error("Task already have next tasks defined. (addTask, addForms con be used only once. If you need to modify process - use process functions.) ");
		}
		forks = new Vector.<Task>(1);
		forks[0] = task;
	}
	
	public function forkTask(... forkTasks:Array):void {
		use namespace mvcExpressLive;
		if (forks) {
			throw Error("Task already have next tasks defined. (addTask, addForms con be used only once. If you need to modify process - use process functions.) ");
		}
		
		forks = new Vector.<Task>(forkTasks.length + 1);
		
		for (var i:int = 0; i < forkTasks.length; i++) {
			if (forkTasks[i] is Task) {
				forks[i] = forkTasks[i];
			} else {
				throw Error("Task must fork only to another Tasks.");
			}
		}
	
	}

}
}