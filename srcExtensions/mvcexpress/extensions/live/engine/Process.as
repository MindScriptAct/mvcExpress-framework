// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.live.engine {
import flash.events.Event;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer;

import mvcexpress.MvcExpress;
import mvcexpress.core.messenger.HandlerVO;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.live.core.ProcessMapLive;
import mvcexpress.extensions.live.taskTests.TaskTestVO;
import mvcexpress.extensions.live.traceObjects.MvcTraceActionsLive;
import mvcexpress.extensions.live.traceObjects.TraceProcess_sendMessage;
import mvcexpress.extensions.live.traceObjects.process.TraceProcess_addFirstTask;
import mvcexpress.extensions.live.traceObjects.process.TraceProcess_addHandler;
import mvcexpress.extensions.live.traceObjects.process.TraceProcess_addTask;
import mvcexpress.extensions.live.traceObjects.process.TraceProcess_addTaskAfter;
import mvcexpress.extensions.live.traceObjects.process.TraceProcess_disableTask;
import mvcexpress.extensions.live.traceObjects.process.TraceProcess_enableTask;
import mvcexpress.extensions.live.traceObjects.process.TraceProcess_removeAllTasks;
import mvcexpress.extensions.live.traceObjects.process.TraceProcess_removeTask;
import mvcexpress.utils.checkClassSuperclass;

/**
 * Process is timer or enterFrame based engine. It executes sequence of tasks.
 * Can handle framework messages.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version live.1.0.beta2
 */
public class Process {

	// indicates frame based process
	static public const FRAME_PROCESS:int = 0;
	// indicates timer based process
	static public const TIMER_PROCESS:int = 1;

	// name of the module this process is working for.
	private var moduleName:String

	/** used internally for process management
	 * @private */
	pureLegsCore var processMap:ProcessMapLive;

	/** used internally for communication
	 * @private */
	pureLegsCore var messenger:Messenger;

	/** Stores class QualifiedClassName by class */
	static private var qualifiedClassNameRegistry:Dictionary = new Dictionary(); //* of String by Class*/

	/** @private */
	pureLegsCore var processType:int;
	/** @private */
	pureLegsCore var processId:String;
	/** @private */
	pureLegsCore var totalFrameSkip:int; // = 0;
	/** @private */
	pureLegsCore var currentFrameSkip:int; // = 0;

	// all process tasks.
	private var taskRegistry:Dictionary = new Dictionary();

	// first task in linked list
	private var head:Task;
	// last task in linked list
	private var tail:Task;

	// indicates if task cash should be used.
	private var isCached:Boolean; // = false;

	/** will reset cash with next run. (with every task add/remove or injection provide/unprovide or task enable/disable.)
	 * @private */
	pureLegsCore var needCashNext:Boolean; // = false;

	// cash of running tasks.
	private var processCache:Vector.<Task> = new Vector.<Task>();

	/** all added message handlers. */
	private var handlerVoRegistry:Vector.<HandlerVO> = new Vector.<HandlerVO>();

	// constants sent after curent task is done running.
	private var postMessageTypes:Vector.<String> = new Vector.<String>();
	private var postMessageParams:Vector.<Object> = new Vector.<Object>();

	// constants sent after all tasks are done running.
	private var finalMessageTypes:Vector.<String> = new Vector.<String>();
	private var finalMessageParams:Vector.<Object> = new Vector.<Object>();

	/** indicates if process is running.
	 * @private */
	pureLegsCore var _isRunning:Boolean; // = false;

	//
	private var processTimer:ProcessTimerVO = new ProcessTimerVO();

	CONFIG::debug
	private var debugProcessTimer:ProcessTimerVO = new ProcessTimerVO();

	// Allows Process to be constructed. (removed from release build to save some performance.)
	/** @private */
	CONFIG::debug
	static pureLegsCore var canConstruct:Boolean; // = false;

	public function Process() {
		CONFIG::debug {
			use namespace pureLegsCore;

			if (!canConstruct) {
				throw Error("Process:" + this + " can be constructed only by framework. If you want to use it - map it with 'processMap'");
			}
		}
	}

	//----------------------------------
	//     life cicle
	//----------------------------------

	/**
	 * Is executed then process is mapped.
	 */
	protected function onRegister():void {
		// for overide
	}

	/**
	 * Is executed then process is removed.
	 */
	protected function onRemove():void {
		// for overide
	}

	/**
	 * Is process running or not.
	 */
	public function get isRunning():Boolean {
		use namespace pureLegsCore;

		return _isRunning as Boolean;
	}

	//----------------------------------
	//     Process managment
	//----------------------------------

	/**
	 * Start process. All enabled tasks will be run() every process tick.
	 * If task has missing injections - they will be skipped.
	 */
	public function startProcess():void {
		use namespace pureLegsCore;

		processTimer.timerLast = getTimer();
		processMap.startProcessObject(this);
	}

	/**
	 * Stop process. Process tasks will not be run().
	 */
	public function stopProcess():void {
		use namespace pureLegsCore;

		processMap.stopProcessObject(this);
	}

	//----------------------------------
	//     message handlers
	//----------------------------------

	/**
	 * adds handle function to be called then message of given type is sent.
	 * @param    type    message type for handle function to react to.
	 * @param    handler    function that will be called then needed message is sent. this function must expect one parameter. (you can set your custom type for this param object, or leave it as Object)
	 */
	protected function addHandler(type:String, handler:Function):void {
		use namespace pureLegsCore;

		CONFIG::debug {
			if (handler.length < 1) {
				throw Error("Every message handler function needs at least one parameter. You are trying to add handler function from " + getQualifiedClassName(this) + " for message type:" + type);
			}
			if (!Boolean(type) || type == "null" || type == "undefined") {
				throw Error("Message type:[" + type + "] can not be empty or 'null'.(You are trying to add message handler in: " + this + ")");
			}

			use namespace pureLegsCore;

			MvcExpress.debug(new TraceProcess_addHandler(moduleName, this, type, handler));

			handlerVoRegistry[handlerVoRegistry.length] = messenger.addHandler(type, handler, getQualifiedClassName(this));
			return;
		}
		handlerVoRegistry[handlerVoRegistry.length] = messenger.addHandler(type, handler);
	}

	/**
	 * Removes handle function from message of given type.
	 * Then process is removed all message handlers are automatically removed.
	 * @param    type    message type that was set for handle function to react to.
	 * @param    handler    function that was set to react to message.
	 */
	protected function removeHandler(type:String, handler:Function):void {
		use namespace pureLegsCore;

		messenger.removeHandler(type, handler);
	}

	/**
	 * Remove all handle functions created by this mediator, internal module handlers AND scoped handlers.
	 * Automatically called then mediator is removed(unmediated) by framework.
	 * (You don't have to put it in mediators onRemove() function.)
	 */
	protected function removeAllHandlers():void {
		use namespace pureLegsCore;

		while (handlerVoRegistry.length) {
			handlerVoRegistry.pop().handler = null;
		}
	}

	//----------------------------------
	//     task managment
	//----------------------------------

	/**
	 * Add task at the end of run queue.
	 * @param    taskClass    Task class to indentify your task
	 * @param    name        optional name for the task if you need more then one instance of same task class.
	 */
	protected function addTask(taskClass:Class, name:String = ""):void {
		use namespace pureLegsCore;

		// mark process as not cached.
		needCashNext = true;

		// get task id
		var className:String = qualifiedClassNameRegistry[taskClass];
		if (!className) {
			className = getQualifiedClassName(taskClass);
			qualifiedClassNameRegistry[taskClass] = className
		}
		var taskId:String = className + name;

		//get task, initiate it if needed.
		var task:Task = taskRegistry[taskId];
		if (task == null) {
			task = initTask(taskClass, taskId);

			// log the action
			CONFIG::debug {
				use namespace pureLegsCore;

				MvcExpress.debug(new TraceProcess_addTask(MvcTraceActionsLive.PROCESS_ADDTASK, moduleName, taskClass, name));
			}

			// add task to list
			if (head) {
				tail.next = task;
				task.prev = tail;
				tail = task;
			} else {
				head = task;
				tail = task;
			}
		} else {
			// log the action
			CONFIG::debug {
				MvcExpress.debug(new TraceProcess_addTask(MvcTraceActionsLive.PROCESS_ADDTASK, moduleName, taskClass, name, true));
			}
		}
	}

	/**
	 * Add task at start of run queue.
	 * @param    taskClass    Task class to indentify your task
	 * @param    name        optional name for the task if you need more then one instance of same task class.
	 */
	protected function addFirstTask(taskClass:Class, name:String = ""):void {
		use namespace pureLegsCore;

		// mark process as not cached.
		needCashNext = true;

		// get task id
		var className:String = qualifiedClassNameRegistry[taskClass];
		if (!className) {
			className = getQualifiedClassName(taskClass);
			qualifiedClassNameRegistry[taskClass] = className
		}
		var taskId:String = className + name;

		//get task, initiate it if needed.
		var task:Task = taskRegistry[taskId];
		if (task == null) {
			task = initTask(taskClass, taskId);

			// log the action
			CONFIG::debug {
				use namespace pureLegsCore;

				MvcExpress.debug(new TraceProcess_addFirstTask(MvcTraceActionsLive.PROCESS_ADDFIRSTTASK, moduleName, taskClass, name));
			}

			// add task to list
			if (head) {
				head.prev = task;
				task.next = head;
				head = task;
			} else {
				head = task;
				tail = task;
			}
		} else {
			// log the action
			CONFIG::debug {
				MvcExpress.debug(new TraceProcess_addFirstTask(MvcTraceActionsLive.PROCESS_ADDFIRSTTASK, moduleName, taskClass, name, true));
			}
		}
	}

	/**
	 * Add task after anether task
	 * @param    taskClass        Task class to indentify your task
	 * @param    afterTaskClass    Task class to add another task after
	 * @param    name            optional name for the task if you need more then one instance of same task class.
	 * @param    afterName        optional name for task, to add another task after
	 */
	protected function addTaskAfter(taskClass:Class, afterTaskClass:Class, name:String = "", afterName:String = ""):void {
		use namespace pureLegsCore;

		// mark process as not cached.
		needCashNext = true;

		// after task id
		var afterClassName:String = qualifiedClassNameRegistry[afterTaskClass];
		if (!afterClassName) {
			afterClassName = getQualifiedClassName(afterTaskClass);
			qualifiedClassNameRegistry[afterTaskClass] = afterClassName
		}
		var afterTaskId:String = afterClassName + afterName;

		// get after task
		var afterTask:Task = taskRegistry[afterTaskId];
		if (afterTask != null) {

			// get task id
			var className:String = qualifiedClassNameRegistry[taskClass];
			if (!className) {
				className = getQualifiedClassName(taskClass);
				qualifiedClassNameRegistry[taskClass] = className
			}
			var taskId:String = className + name;

			//
			var task:Task = taskRegistry[taskId];
			if (task == null) {
				task = initTask(taskClass, taskId);

				// log the action
				CONFIG::debug {
					use namespace pureLegsCore;

					MvcExpress.debug(new TraceProcess_addTaskAfter(MvcTraceActionsLive.PROCESS_ADDTASKAFTER, moduleName, taskClass, name));
				}

				task.prev = afterTask;
				task.next = afterTask.next;

				if (afterTask.next) {
					afterTask.next.prev = task
				} else {
					// last element
					tail = task;
				}
				afterTask.next = task;

			} else {
				// log the action
				CONFIG::debug {
					MvcExpress.debug(new TraceProcess_addTaskAfter(MvcTraceActionsLive.PROCESS_ADDTASKAFTER, moduleName, taskClass, name, true));
				}
			}
		} else {
			throw Error("Task with id:" + afterTaskId + " you are trying to add another task after, is not added to process yet. ");
		}
	}

	/**
	 * Removes the task from queue.
	 * @param    taskClass    Task class to indentify your task
	 * @param    name        optional name for the task if you need more then one instance of same task class.
	 */
	protected function removeTask(taskClass:Class, name:String = ""):void {
		use namespace pureLegsCore;

		// mark process as not cached.
		needCashNext = true;

		var className:String = qualifiedClassNameRegistry[taskClass];
		if (!className) {
			className = getQualifiedClassName(taskClass);
			qualifiedClassNameRegistry[taskClass] = className
		}
		var taskId:String = className + name;

		var task:Task = taskRegistry[taskId];

		// log the action
		CONFIG::debug {
			use namespace pureLegsCore;

			MvcExpress.debug(new TraceProcess_removeTask(MvcTraceActionsLive.PROCESS_REMOVETASK, moduleName, taskClass, name));
		}

		if (task != null) {

			processMap.removeTask(task, taskClass);

			if (task.prev) {
				task.prev.next = task.next;
			} else {
				// the first
				head = task.next;
			}
			if (task.next) {
				task.next.prev = task.prev;
			} else {
				// the last
				tail = task.prev;
			}
			delete taskRegistry[taskId];
		}
	}

	/**
	 * Removes all tasks for curent queue
	 */
	protected function removeAllTasks():void {
		use namespace pureLegsCore;

		// mark process as not cached.
		needCashNext = true;

		// log the action
		CONFIG::debug {
			use namespace pureLegsCore;

			MvcExpress.debug(new TraceProcess_removeAllTasks(MvcTraceActionsLive.PROCESS_REMOVEALLTASKS, moduleName));
		}

		processMap.removeAllTasks();

		for each (var item:Task in taskRegistry) {
			item.dispose();
		}

		taskRegistry = new Dictionary();
		head = null;
		tail = null;
	}

	//----------------------------------
	//     enable/disable task
	//----------------------------------

	/**
	 * Enable task to be run in the queue.            <br>
	 * Then task is adde it is automaticaly enabled.
	 * @param    taskClass    Task class to indentify your task
	 * @param    name        optional name for the task if you need more then one instance of same task class.
	 */
	protected function enableTask(taskClass:Class, name:String = ""):void {
		use namespace pureLegsCore;

		// mark process as not cached.
		needCashNext = true;

		var className:String = qualifiedClassNameRegistry[taskClass];
		if (!className) {
			className = getQualifiedClassName(taskClass);
			qualifiedClassNameRegistry[taskClass] = className
		}
		var taskId:String = className + name;

		// log the action
		CONFIG::debug {
			use namespace pureLegsCore;

			MvcExpress.debug(new TraceProcess_enableTask(MvcTraceActionsLive.PROCESS_ENABLETASK, moduleName, taskClass, name));
		}

		var task:Task = taskRegistry[taskId];
		if (task) {
			task._isEnabled = true;
			task._isRunning = (task._missingDependencyCount == 0);
		} else {
			throw Error("Task you are trying to enable is not added to process. (taskClass:" + taskClass + " name:" + name + ")");
		}
	}

	/**
	 * Disable task from running.    <br>
	 * Task will not be removed, it can be enabled to be run again.
	 * @param    taskClass    Task class to indentify your task
	 * @param    name        optional name for the task if you need more then one instance of same task class.
	 */
	protected function disableTask(taskClass:Class, name:String = ""):void {
		use namespace pureLegsCore;

		// mark process as not cached.
		needCashNext = true;

		var className:String = qualifiedClassNameRegistry[taskClass];
		if (!className) {
			className = getQualifiedClassName(taskClass);
			qualifiedClassNameRegistry[taskClass] = className
		}
		var taskId:String = className + name;

		// log the action
		CONFIG::debug {
			use namespace pureLegsCore;

			MvcExpress.debug(new TraceProcess_disableTask(MvcTraceActionsLive.PROCESS_DISABLETASK, moduleName, taskClass, name));
		}

		var task:Task = taskRegistry[taskId];
		if (task) {
			task._isEnabled = false;
			task._isRunning = false;
		} else {
			throw Error("Task you are trying to enable is not added to process. (taskClass:" + taskClass + " name:" + name + ")");
		}
	}

	//----------------------------------
	//     debug
	//----------------------------------

	/**
	 * Checks if task is added.
	 * @param    taskClass    Task class to indentify your task
	 * @param    name        optional name for the task if you need more then one instance of same task class.
	 * @return    true if task is added.
	 */
	public function hasTask(taskClass:Class, name:String = ""):Boolean {
		use namespace pureLegsCore;

		// mark process as not cached.
		needCashNext = true;

		var className:String = qualifiedClassNameRegistry[taskClass];
		if (!className) {
			className = getQualifiedClassName(taskClass);
			qualifiedClassNameRegistry[taskClass] = className
		}
		var taskId:String = className + name;

		// log the action
		CONFIG::debug {
			use namespace pureLegsCore;

			MvcExpress.debug(new TraceProcess_disableTask(MvcTraceActionsLive.PROCESS_DISABLETASK, moduleName, taskClass, name));
		}

		return taskRegistry[taskId] != null;
	}


	/**
	 * Returs string with all curent tasks for debugging.
	 * @return    String of all tasks.
	 */
	public function listTasks():String {
		use namespace pureLegsCore;

		var retVal:String = "TASKS:\n";
		var currentListTask:Task = head;
		while (currentListTask) {

			retVal += "\t"

			if (!currentListTask._isRunning) {
				retVal += "|\t";
			}

			retVal += currentListTask;

			if (!currentListTask._isEnabled) {
				retVal += "   (DISABLED)";
			}

			if (currentListTask._missingDependencyCount > 0) {
				var missingInjectNames:String = "";
				var missingInjects:Vector.<String> = currentListTask.getMissingInjects();
				var missingInjectCount:int = missingInjects.length;
				for (var i:int = 0; i < missingInjectCount; i++) {
					if (missingInjectNames != "") {
						missingInjectNames += ", "
					}
					missingInjectNames += missingInjects[i];
				}
				retVal += "   (" + currentListTask._missingDependencyCount + " MISSING DEPENDENCIES:" + missingInjectNames + ")";
			}

			retVal += "\n";

			currentListTask = currentListTask.next;
		}

		return retVal;
	}

	//----------------------------------
	//     internal
	//----------------------------------

	/** sets name of curent module.
	 * @private */
	pureLegsCore function setModuleName($moduleName:String):void {
		moduleName = $moduleName;
	}

	/** runs all enabled tasks in process.
	 * @private */
	pureLegsCore function runProcess(event:Event = null):void {
		var task:Task;

		var moduleName:String;
		var params:Object;
		var type:String;

		// handle time
		processTimer.timerLast = processTimer.timerCurrent;
		processTimer.timerCurrent = getTimer();
		processTimer.ms = processTimer.timerCurrent - processTimer.timerLast;
		processTimer.sec = processTimer.ms / 1000;

		// set debug object, to make sure they are not changed.
		CONFIG::debug {
			debugProcessTimer.timerLast = processTimer.timerLast;
			debugProcessTimer.timerCurrent = processTimer.timerCurrent;
			debugProcessTimer.ms = processTimer.ms;
			debugProcessTimer.sec = processTimer.sec;
		}


		use namespace pureLegsCore;

		CONFIG::debug {
			var testRuns:Vector.<TaskTestVO> = new Vector.<TaskTestVO>();
		}

		if (needCashNext) {
			isCached = false;
			needCashNext = false;
		}

		if (isCached) {
			// take first cashed item.
			var taskIndex:int = 0;
			var cacheLength:int = processCache.length;
			if (cacheLength > 0) {
				task = processCache[taskIndex];
			}
		} else {
			var doFindTask:Boolean = true;
			task = head;
			while (doFindTask && task) {
				if (task._isRunning) {
					doFindTask = false;
				} else {
					task = task.next;
				}
			}

			// clear cashed items.
			while (processCache.length) {
				processCache.pop();
			}
		}

		while (task) {

			// run task!
			task.run();

			// check if run() did not changed timer object.
			CONFIG::debug {
				if (debugProcessTimer.timerLast != processTimer.timerLast) {
					throw Error("Task " + task + " run() function should not be changing processTime.timerLast, it is public for speed only.");
				}
				if (debugProcessTimer.timerCurrent != processTimer.timerCurrent) {
					throw Error("Task " + task + " run() function should not be changing processTime.timerCurrent, it is public for speed only.");
				}
				if (debugProcessTimer.ms != processTimer.ms) {
					throw Error("Task " + task + " run() function should not be changing processTime.ms, it is public for speed only.");
				}
				if (debugProcessTimer.sec != processTimer.sec) {
					throw Error("Task " + task + " run() function should not be changing processTime.sec, it is public for speed only.");
				}

				// do testing
				var nowTimer:uint = getTimer();
				var testCount:int = task.tests.length;
				for (var i:int = 0; i < testCount; i++) {
					var taskTestVo:TaskTestVO = task.tests[i];
					// check if function run is needed.
					if (taskTestVo.totalDelay > 0) {
						taskTestVo.currentDelay -= nowTimer - taskTestVo.currentTimer;
						taskTestVo.currentTimer = nowTimer;
						if (taskTestVo.currentDelay <= 0) {
							taskTestVo.currentDelay = taskTestVo.totalDelay;
							testRuns[testRuns.length] = taskTestVo;
						}
					} else {
						testRuns[testRuns.length] = taskTestVo;
					}
				}
			}

			// send post constants
			while (postMessageTypes.length) {
				type = postMessageTypes.shift() as String;
				params = postMessageParams.shift();
				// log the action
				CONFIG::debug {
					MvcExpress.debug(new TraceProcess_sendMessage(MvcTraceActionsLive.PROCESS_POST_SENDMESSAGE, moduleName, this, type, params));
				}
				messenger.send(type, params);
				// clean up logging the action
				CONFIG::debug {
					MvcExpress.debug(new TraceProcess_sendMessage(MvcTraceActionsLive.PROCESS_POST_SENDMESSAGE_CLEAN, moduleName, this, type, params));
				}
			}

			// take next task.
			if (isCached) {
				taskIndex++;
				if (cacheLength > taskIndex) {
					task = processCache[taskIndex];
				} else {
					task = null;
				}
			} else {
				//add curent task to cache
				processCache[processCache.length] = task;
				//
				doFindTask = true;
				task = task.next;
				while (doFindTask && task) {
					if (task._isRunning) {
						doFindTask = false;
					} else {
						task = task.next;
					}
				}
			}
		}

		// set process as cached
		isCached = true;

		// send final constants
		while (finalMessageTypes.length) {
			type = finalMessageTypes.shift() as String;
			params = finalMessageParams.shift();
			// log the action
			CONFIG::debug {
				MvcExpress.debug(new TraceProcess_sendMessage(MvcTraceActionsLive.PROCESS_FINAL_SENDMESSAGE, moduleName, this, type, params));
			}
			messenger.send(type, params);
			// clean up logging the action
			CONFIG::debug {
				MvcExpress.debug(new TraceProcess_sendMessage(MvcTraceActionsLive.PROCESS_FINAL_SENDMESSAGE_CLEAN, moduleName, this, type, params));
			}
		}
		// run needed tests.
		CONFIG::debug {
			var runTestCount:int = testRuns.length;
			for (var t:int = 0; t < runTestCount; t++) {
				var totalCount:int = testRuns[t].totalCount
				for (var j:int = 0; j < totalCount; j++) {
					testRuns[t].testFunction();
				}
			}
		}

	}

	// initiates a task.
	private function initTask(taskClass:Class, taskId:String):Task {
		use namespace pureLegsCore;

		CONFIG::debug {
			//check for class type. (taskClass must be or subclass Task class.)
			if (!checkClassSuperclass(taskClass, "mvcexpress.extensions.live.engine::Task")) {
				throw Error("taskClass:" + taskClass + " you are trying to mapTask is not extended from 'mvcexpress.extensions.live.engine::Task' class.");
			}
		}
		// create task.
		var task:Task = new taskClass();
		task.timer = processTimer;
		processMap.initTask(task, taskClass);
		task.process = this;
		taskRegistry[taskId] = task;

		return task;
	}

	/** trigered then process is initiated.
	 * @private */
	pureLegsCore function register():void {
		onRegister();
	}

	/** trigered then process is removed.
	 * @private */
	pureLegsCore function remove():void {
		use namespace pureLegsCore;

		processId = null;
		onRemove();
		// remove all handlers
		removeAllHandlers();
		// dispose all tasks.
		for each (var task:Task in taskRegistry) {
			task.dispose();
		}
		taskRegistry = null;
		// null internals
		head = null;
		tail = null;

		processMap = null;

		postMessageTypes = null;
		postMessageParams = null;

		finalMessageTypes = null;
		finalMessageParams = null;

		processTimer = null;
		CONFIG::debug {
			debugProcessTimer = null;
		}
	}

	//----------------------------------
	//     internal - message sending
	//----------------------------------

	/** send instant constants
	 * @private */
	pureLegsCore function sendInstantMessage(type:String, params:Object):void {
		use namespace pureLegsCore;

		// log the action
		CONFIG::debug {
			MvcExpress.debug(new TraceProcess_sendMessage(MvcTraceActionsLive.PROCESS_INSTANT_SENDMESSAGE, moduleName, this, type, params));
		}
		messenger.send(type, params);
		// clean up logging the action
		CONFIG::debug {
			MvcExpress.debug(new TraceProcess_sendMessage(MvcTraceActionsLive.PROCESS_INSTANT_SENDMESSAGE_CLEAN, moduleName, this, type, params));
		}

	}

	/** stacks message to be sent after current task is done.
	 * @private */
	pureLegsCore function stackPostMessage(type:String, params:Object):void {
		postMessageTypes[postMessageTypes.length] = type;
		postMessageParams[postMessageParams.length] = params;
	}

	/** stacks message to be sent after all tasks of current run are done.
	 * @private */
	pureLegsCore function stackFinalMessage(type:String, params:Object):void {
		finalMessageTypes[finalMessageTypes.length] = type;
		finalMessageParams[finalMessageParams.length] = params;
	}

}
}