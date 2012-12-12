// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.live {
import flash.events.Event;
import org.mvcexpress.core.namespace.mvcExpressLive;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class Process {
	
	private var head:Task;
	
	public function Process() {
	
	}
	
	public function addHeadTask(headTask:Task):void {
		if (head) {
			throw Error("Head is already added.");
		}
		// TODO: check if task is mapped.
		
		head = headTask;
	}
	
	public function mapTask(taskClass:Class):Task {
		
		// TODO: check for class type. (taskClass must be or subclass Task class.)
		
		// TODO: check for dublications. (task must be unique)
		
		var task:Task = new taskClass();
		return task;
	}
	
	mvcExpressLive function runProcess(event:Event = null):void {
		//trace("Process.runProcess > event : " + event);
		use namespace mvcExpressLive;
		
		var current:Task = head;
		while (current) {
			current.run();
			if (current.forks) {
				current = current.forks[current.forkId]
				current.forkId = 0;
			} else {
				break;
			}
		}
	}

}
}