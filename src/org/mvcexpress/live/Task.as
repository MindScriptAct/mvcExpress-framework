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
	
	//----------------------------------
	//     message sending
	//----------------------------------
	
	/**
	 * Sends message right now.
	 * @param	type
	 * @param	params
	 */
	protected function sendInstantMessage(type:String, params:Object = null):void {
		use namespace mvcExpressLive;
		process.sendInstantMessage(type, params);
	}
	
	/**
	 * Stacks message to be sent after current task is done.
	 * @param	type
	 * @param	params
	 */
	protected function sendPostMessage(type:String, params:Object = null):void {
		use namespace mvcExpressLive;
		process.stackPostMessage(type, params);
	}
	
	/**
	 * Stacks message to be sent after all tasks are done of current process run.
	 * @param	type
	 * @param	params
	 */
	protected function sendFinalMessage(type:String, params:Object = null):void {
		use namespace mvcExpressLive;
		process.stackFinalMessage(type, params);
	}
	
	//----------------------------------
	//     internal
	//----------------------------------
	
	mvcExpressLive function dispose():void {
		use namespace mvcExpressLive;
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