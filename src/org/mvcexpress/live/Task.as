// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.live {
import flash.utils.Dictionary;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.taskTest.TaskTestVO;
import org.mvcexpress.utils.ExpressAssert;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class Task {
	
	/**
	 * process that handles the task.
	 * @private
	 */
	pureLegsCore var process:Process;
	
	// previous process in linked list
	pureLegsCore var prev:Task;
	// next process in linked list
	pureLegsCore var next:Task;
	
	// stores inject point variable names by inject object names.
	private var injectPointRegistry:Dictionary = new Dictionary(); /* of Strnig by String */
	
	// stores info if task is disabled by user. 
	pureLegsCore var _isEnabled:Boolean = true;
	
	// stores how much injections this task is missing.
	pureLegsCore var _missingDependencyCount:int; // = 0;
	
	// to covers _isEnabled and _missingDependencyCount
	pureLegsCore var _isRunning:Boolean = true;
	
	/**
	 * Simple object for assert testing.
	 */
	protected var assert:ExpressAssert = ExpressAssert.getInstance();
	
	/**
	 * Vector of all tests for this task.
	 * @private
	 * */
	CONFIG::debug
	pureLegsCore var tests:Vector.<TaskTestVO> = new Vector.<TaskTestVO>();
	
	/**
	 * Runnable function. It will be executed everytime process runs.
	 * Must be ovveriden.
	 */
	public function run():void {
		// for override
	}
	
	//----------------------------------
	//    task state.
	//----------------------------------
	
	/**
	 * Returs count of missing dependencies.
	 */
	public function get missingDependencyCount():int {
		use namespace pureLegsCore;
		return _missingDependencyCount;
	}
	
	/**
	 * Returns if task is manualy disabled by process.
	 */
	public function get isDisabled():Boolean {
		use namespace pureLegsCore;
		return _isEnabled as Boolean;
	}
	
	/**
	 * Returns if tast is running. (not disabled and has all proxies injected.).
	 */
	public function get isRunning():Boolean {
		use namespace pureLegsCore;
		return _isRunning;
	}
	
	//----------------------------------
	//     message sending
	//----------------------------------
	
	/**
	 * Sends message right now.
	 * @param	type	type of the message for Commands or Mediator's handle function to react to.
	 * @param	params	Object that will be passed to Command execute() function or to handle functions.
	 */
	protected function sendInstantMessage(type:String, params:Object = null):void {
		use namespace pureLegsCore;
		process.sendInstantMessage(type, params);
	}
	
	/**
	 * Stacks message to be sent after current task is done.
	 * @param	type	type of the message for Commands or Mediator's handle function to react to.
	 * @param	params	Object that will be passed to Command execute() function or to handle functions.
	 */
	protected function sendPostMessage(type:String, params:Object = null):void {
		use namespace pureLegsCore;
		process.stackPostMessage(type, params);
	}
	
	/**
	 * Stacks message to be sent after all tasks are done of current process run.
	 * @param	type	type of the message for Commands or Mediator's handle function to react to.
	 * @param	params	Object that will be passed to Command execute() function or to handle functions.
	 */
	protected function sendFinalMessage(type:String, params:Object = null):void {
		use namespace pureLegsCore;
		process.stackFinalMessage(type, params);
	}
	
	//----------------------------------
	//     internal
	//----------------------------------
	
	// set all inject points. (variable name + inject name). done once then task is initiated.
	pureLegsCore function setInjectPoint(injectName:String, varName:String):void {
		injectPointRegistry[injectName] = varName;
	}
	
	// used to get inject points then object are provided. (and check inject status)
	pureLegsCore function getInjectPoint(injectName:String):String {
		return injectPointRegistry[injectName];
	}
	
	// for debuging
	pureLegsCore function getMissingInjects():Vector.<String> {
		var retVal:Vector.<String> = new Vector.<String>();
		for (var name:String in injectPointRegistry) {
			if (this[injectPointRegistry[name]] == null) {
				retVal[retVal.length] = name;
			}
		}
		return retVal;
	}
	
	// function for this task to force process to clear task cache
	pureLegsCore function setNotCached():void {
		use namespace pureLegsCore;
		process.needCashNext = true;
	}
	
	// dispose task
	pureLegsCore function dispose():void {
		use namespace pureLegsCore;
		process = null;
		prev = null;
		next = null;
		assert = null;
		injectPointRegistry = null;
		CONFIG::debug {
			var taskCount:int = tests.length;
			for (var i:int = 0; i < taskCount; i++) {
				tests[i].testFunction = null;
			}
			tests = null;
		}
	}

}
}