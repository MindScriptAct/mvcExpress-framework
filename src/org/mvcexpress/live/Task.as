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
	mvcExpressLive var forks:Vector.<Task>;
	
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
			} else {
				throw Error("Task must fork only to another Tasks.");
			}
		}
	}
	
	public function insertTask():void {
		// TODO
	}
	
	public function remove():void {
		// TODO
	}
	
	public function replace():void {
		// TODO
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