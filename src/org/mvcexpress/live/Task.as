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
	
	pureLegsCore var prev:Task;
	pureLegsCore var next:Task;
	
	private var injectPointRegistry:Dictionary = new Dictionary();
	
	pureLegsCore var _isEnabled:Boolean = true;
	
	pureLegsCore var _missingDependencyCount:int = 0;
	
	/**
	 * Simple object for testing.
	 */
	protected var assert:ExpressAssert = ExpressAssert.getInstance();
	
	/**
	 * Vector of all tests on this task.
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
	//    
	//----------------------------------
	
	/**
	 * Returs count of missing dependencies.
	 */
	public function get missingDependencyCount():int {
		use namespace pureLegsCore;
		return _missingDependencyCount;
	}
	
	/**
	 * Returns if task is disabled by user.
	 */
	public function get isDisabled():Boolean {
		use namespace pureLegsCore;
		return _isEnabled as Boolean;
	}
	
	//----------------------------------
	//     message sending
	//----------------------------------
	
	/**
	 * Sends message right now.
	 * @param	type
	 * @param	params
	 */
	protected function sendInstantMessage(type:String, params:Object = null):void {
		use namespace pureLegsCore;
		process.sendInstantMessage(type, params);
	}
	
	/**
	 * Stacks message to be sent after current task is done.
	 * @param	type
	 * @param	params
	 */
	protected function sendPostMessage(type:String, params:Object = null):void {
		use namespace pureLegsCore;
		process.stackPostMessage(type, params);
	}
	
	/**
	 * Stacks message to be sent after all tasks are done of current process run.
	 * @param	type
	 * @param	params
	 */
	protected function sendFinalMessage(type:String, params:Object = null):void {
		use namespace pureLegsCore;
		process.stackFinalMessage(type, params);
	}
	
	//----------------------------------
	//     internal
	//----------------------------------
	
	pureLegsCore function setInjectPoint(injectName:String, varName:String):void {
		injectPointRegistry[injectName] = varName;
	}
	
	pureLegsCore function getInjectPoint(injectName:String):String {
		return injectPointRegistry[injectName];
	}
	
	pureLegsCore function getMissingInjects():Vector.<String> {
		var retVal:Vector.<String> = new Vector.<String>();
		for (var name:String in injectPointRegistry) {
			if (this[injectPointRegistry[name]] == null) {
				retVal.push(name);
			}
		}
		return retVal;
	}	
	
	pureLegsCore function setNotCached():void {
		use namespace pureLegsCore;
		process.isCached = false;
	}
	
	pureLegsCore function dispose():void {
		use namespace pureLegsCore;
		prev = null;
		next = null;
		assert = null;
		injectPointRegistry = null;
		CONFIG::debug {
			for (var i:int = 0; i < tests.length; i++) {
				tests[i].testFunction = null;
			}
			tests = null;
		}
	}

}
}