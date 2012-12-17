// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.live {
import org.mvcexpress.core.namespace.mvcExpressLive;
import org.mvcexpress.core.taskTest.TastTestVO;
import org.mvcexpress.utils.ExpressAssert;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class Task {
	
	/**
	 * id of current fork.
	 * @private
	 * */
	mvcExpressLive var forkId:int = 0;
	
	/**
	 * all available forks.
	 * @private
	 * */
	mvcExpressLive var previous:Task;
	
	/**
	 * all available forks.
	 * @private
	 * */
	mvcExpressLive var forks:Vector.<Task>;
	
	/**
	 * process that handles the task.
	 * @private
	 */
	mvcExpressLive var process:Process;
	
	/**
	 * Simple object for testing.
	 */
	protected var assert:ExpressAssert = ExpressAssert.getInstance();
	
	/**
	 * Vector of all tests on this task.
	 * @private
	 * */
	CONFIG::debug
	mvcExpressLive var tests:Vector.<TastTestVO> = new Vector.<TastTestVO>();
	
	/**
	 * Runnable function. It will be executed everytime process runs.
	 * Must be ovveriden.
	 */
	public function run():void {
		// for override
	}
	
	/**
	 * Adds next task to existing one.
	 * If next task already exists - it will fail.
	 * Best function to be used while constructing your process.
	 * @param	task
	 */
	public function addTask(task:Task):void {
		use namespace mvcExpressLive;
		if (forks) {
			throw Error("Task already have next tasks defined. (addTask, addForms con be used only once. If you need to modify process - use process functions.) ");
		}
		forks = new Vector.<Task>(1);
		forks[0] = task;
		task.previous = this;
	}
	
	/**
	 * Adds one ore more task to existing one as fork options.
	 * If next tasks already exists - it will fail.
	 * Best function to be used while constructing your process.
	 * @param	... forkTasks
	 */
	public function forkTask(... forkTasks:Array):void {
		use namespace mvcExpressLive;
		if (forks) {
			throw Error("Task already have next tasks defined. (addTask, addForms con be used only once. If you need to modify process - use process functions.) ");
		}
		forks = new Vector.<Task>(forkTasks.length + 1);
		for (var i:int = 0; i < forkTasks.length; i++) {
			if (forkTasks[i] is Task) {
				forks[i] = forkTasks[i];
				forkTasks[i].previous = this;
			} else {
				throw Error("Task must fork only to another Tasks.");
			}
		}
	}
	
	public function insertTask(newTask:Task):void {
		use namespace mvcExpressLive;
		if (!this.forks) {
			this.forks = new Vector.<Task>(1);
			this.forks[0] = newTask;
			newTask.previous = this;
		} else {
			if (this.forks.length == 1) {
				newTask.addTask(this.forks[0]);
				this.forks[0].previous = newTask;
				//
				this.forks[0] = newTask;
				newTask.previous = this;
			} else {
				throw Error("This task must have exactly 1 fork. (" + this + ")");
			}
		}
	}
	
	public function remove():void {
		use namespace mvcExpressLive;
		if (this.previous) {
			if (this.forks.length == 0) {
				this.previous.replaceFork(this, null);
			} else if (this.forks.length == 1) {
				this.previous.replaceFork(this, this.forks[0]);
			} else {
				throw Error("You cant remove task that has many forks. Remove all but one fork first. (" + this + ")");
			}
			this.previous = null;
			this.forks = null;
		}
	}
	
	public function replace():void {
		throw Error("TODO");
	}
	
	public function replaceFork(oldTask:Task, newTask:Task):void {
		use namespace mvcExpressLive;
		for (var i:int = 0; i < forks.length; i++) {
			if (forks[i] == oldTask) {
				forks[i] = newTask;
				newTask.previous = this;
			}
		}
	}
	
	//----------------------------------
	//     message sending
	//----------------------------------
	protected function sendPostMessage(type:String, params:Object = null):void {
		use namespace mvcExpressLive;
		process.stackPostMessage(type, params);
	}
	
	//----------------------------------
	//     internal
	//----------------------------------
	
	mvcExpressLive function dispose():void {
		use namespace mvcExpressLive;
		forks = null;
		assert = null;
		CONFIG::debug {
			for (var i:int = 0; i < tests.length; i++) {
				tests[i].testFunction = null;
			}
			tests = null;
		}
	}

}
}