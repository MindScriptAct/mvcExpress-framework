// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.live {
import flash.events.Event;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer;
import org.mvcexpress.core.messenger.HandlerVO;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.core.namespace.mvcExpressLive;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.ProcessMap;
import org.mvcexpress.core.taskTest.TastTestVO;
import org.mvcexpress.core.traceObjects.live.process.TraceProcess_addFirstTask;
import org.mvcexpress.core.traceObjects.live.process.TraceProcess_addTask;
import org.mvcexpress.core.traceObjects.live.process.TraceProcess_addTaskAfter;
import org.mvcexpress.core.traceObjects.live.process.TraceProcess_removeTask;
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceProcess_sendMessage;
import org.mvcexpress.MvcExpress;
import org.mvcexpress.utils.checkClassSuperclass;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class Process {
	
	private var moduleName:String
	
	static public const FRAME_PROCESS:int = 0;
	
	static public const TIMER_PROCESS:int = 1;
	
	// used internally for process management
	/** @private */
	mvcExpressLive var processMap:ProcessMap;
	
	// used internally for communication
	/** @private */
	pureLegsCore var messenger:Messenger;
	
	/** Stores class QualifiedClassName by class */
	static private var qualifiedClassNameRegistry:Dictionary = new Dictionary(); /* of String by Class*/
	
	mvcExpressLive var type:int;
	mvcExpressLive var processId:String;
	
	mvcExpressLive var totalFrameSkip:int = 0;
	mvcExpressLive var currentFrameSkip:int = 0;
	
	//
	private var taskRegistry:Dictionary = new Dictionary();
	
	private var head:Task;
	private var tail:Task;
	
	private var processCache:Vector.<Task> = new Vector.<Task>();
	
	private var isCached:Boolean = false;
	
	/** all added message handlers. */
	private var handlerVoRegistry:Vector.<HandlerVO> = new Vector.<HandlerVO>();
	
	private var postMessageTypes:Vector.<String> = new Vector.<String>();
	private var postMessageParams:Vector.<Object> = new Vector.<Object>();
	
	private var finalMessageTypes:Vector.<String> = new Vector.<String>();
	private var finalMessageParams:Vector.<Object> = new Vector.<Object>();
	
	mvcExpressLive var _isRunning:Boolean = false;
	
	// Allows Process to be constructed. (removed from release build to save some performance.)
	/** @private */
	CONFIG::debug
	static pureLegsCore var canConstruct:Boolean = false;
	
	public function Process() {
		CONFIG::debug {
			use namespace pureLegsCore;
			if (!canConstruct) {
				throw Error("Process:" + this + " can be constructed only by framework. If you want to use it - map it with 'processMap'");
			}
		}
	}
	
	protected function onRegister():void {
		// for overide
	}
	
	protected function onRemove():void {
		// for overide
	}
	
	public function get isRunning():Boolean {
		use namespace mvcExpressLive;
		return _isRunning as Boolean;
	}
	
	//----------------------------------
	//     Process managment
	//----------------------------------
	
	public function startProcess():void {
		use namespace mvcExpressLive;
		processMap.startProcessObject(this);
	}
	
	public function stopProcess():void {
		use namespace mvcExpressLive;
		processMap.stopProcessObject(this);
	}
	
	//----------------------------------
	//     message handlers
	//----------------------------------
	
	/**
	 * adds handle function to be called then message of given type is sent.
	 * @param	type	message type for handle function to react to.
	 * @param	handler	function that will be called then needed message is sent. this function must expect one parameter. (you can set your custom type for this param object, or leave it as Object)
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
			//MvcExpress.debug(new TraceMediator_addHandler(MvcTraceActions.MEDIATOR_ADDHANDLER, messenger.moduleName, this, type, handler));
			
			handlerVoRegistry.push(messenger.addHandler(type, handler, getQualifiedClassName(this)));
			return;
		}
		handlerVoRegistry.push(messenger.addHandler(type, handler));
	}
	
	/**
	 * Removes handle function from message of given type.
	 * Then Mediator is removed(unmediated) all message handlers are automatically removed by framework.
	 * @param	type	message type that was set for handle function to react to.
	 * @param	handler	function that was set to react to message.
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
	
	// TODO : consider adding isEnabled:Boolean = true
	
	protected function addTask(taskClass:Class, name:String = ""):void {
		use namespace mvcExpressLive;
		
		// mark process as not cached.
		isCached = false;
		
		// get task id
		var className:String = Process.qualifiedClassNameRegistry[taskClass];
		if (!className) {
			className = getQualifiedClassName(taskClass);
			Process.qualifiedClassNameRegistry[taskClass] = className
		}
		var taskId:String = className + name;
		
		//get task, initiate it if needed.
		var task:Task = taskRegistry[taskId];
		if (task == null) {
			task = initTask(taskClass, taskId);
			
			// log the action
			CONFIG::debug {
				use namespace pureLegsCore;
				var moduleName:String = messenger.moduleName;
				MvcExpress.debug(new TraceProcess_addTask(MvcTraceActions.PROCESS_ADDTASK, moduleName, taskClass, name));
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
				use namespace pureLegsCore;
				moduleName = messenger.moduleName;
				MvcExpress.debug(new TraceProcess_addTask(MvcTraceActions.PROCESS_ADDTASK, moduleName, taskClass, name, true));
			}
		}
	}
	
	protected function addFirstTask(taskClass:Class, name:String = ""):void {
		use namespace mvcExpressLive;
		
		// mark process as not cached.
		isCached = false;
		
		// get task id
		var className:String = Process.qualifiedClassNameRegistry[taskClass];
		if (!className) {
			className = getQualifiedClassName(taskClass);
			Process.qualifiedClassNameRegistry[taskClass] = className
		}
		var taskId:String = className + name;
		
		//get task, initiate it if needed.
		var task:Task = taskRegistry[taskId];
		if (task == null) {
			task = initTask(taskClass, taskId);
			
			// log the action
			CONFIG::debug {
				use namespace pureLegsCore;
				var moduleName:String = messenger.moduleName;
				MvcExpress.debug(new TraceProcess_addFirstTask(MvcTraceActions.PROCESS_ADDFIRSTTASK, moduleName, taskClass, name));
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
				use namespace pureLegsCore;
				moduleName = messenger.moduleName;
				MvcExpress.debug(new TraceProcess_addFirstTask(MvcTraceActions.PROCESS_ADDFIRSTTASK, moduleName, taskClass, name, true));
			}
		}
	}
	
	protected function addTaskAfter(taskClass:Class, afterTaskClass:Class, name:String = "", afterName:String = ""):void {
		use namespace mvcExpressLive;
		
		// mark process as not cached.
		isCached = false;
		
		// after task id
		var afterClassName:String = Process.qualifiedClassNameRegistry[afterTaskClass];
		if (!afterClassName) {
			afterClassName = getQualifiedClassName(afterTaskClass);
			Process.qualifiedClassNameRegistry[afterTaskClass] = afterClassName
		}
		var afterTaskId:String = afterClassName + afterName;
		
		// get after task
		var afterTask:Task = taskRegistry[afterTaskId];
		if (afterTask != null) {
			
			// get task id
			var className:String = Process.qualifiedClassNameRegistry[taskClass];
			if (!className) {
				className = getQualifiedClassName(taskClass);
				Process.qualifiedClassNameRegistry[taskClass] = className
			}
			var taskId:String = className + name;
			
			//
			var task:Task = taskRegistry[taskId];
			if (task == null) {
				task = initTask(taskClass, taskId);
				
				// log the action
				CONFIG::debug {
					use namespace pureLegsCore;
					moduleName = messenger.moduleName;
					MvcExpress.debug(new TraceProcess_addTaskAfter(MvcTraceActions.PROCESS_ADDTASKAFTER, moduleName, taskClass, name));
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
					use namespace pureLegsCore;
					moduleName = messenger.moduleName;
					MvcExpress.debug(new TraceProcess_addTaskAfter(MvcTraceActions.PROCESS_ADDTASKAFTER, moduleName, taskClass, name, true));
				}
			}
		} else {
			throw Error("Task with id:" + afterTaskId + " you are trying to add another task after, is not added to process yet. ");
		}
	}
	
	protected function removeTask(taskClass:Class, name:String = ""):void {
		use namespace mvcExpressLive;
		
		// mark process as not cached.
		isCached = false;
		
		var className:String = Process.qualifiedClassNameRegistry[taskClass];
		if (!className) {
			className = getQualifiedClassName(taskClass);
			Process.qualifiedClassNameRegistry[taskClass] = className
		}
		var taskId:String = className + name;
		
		var task:Task = taskRegistry[taskId];
		
		// log the action
		CONFIG::debug {
			use namespace pureLegsCore;
			var moduleName:String = messenger.moduleName;
			MvcExpress.debug(new TraceProcess_removeTask(MvcTraceActions.PROCESS_REMOVETASK, moduleName, taskClass, name));
		}
		
		if (task != null) {
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
	
	protected function removeAllTasks():void {
		// TODO
	}
	
	protected function enableTask(taskClass:Class, name:String = ""):void {
		// TODO
	}
	
	protected function disableTask(taskClass:Class, name:String = ""):void {
		// TODO
	}
	
	//----------------------------------
	//     debug
	//----------------------------------
	
	public function listTasks():String {
		use namespace mvcExpressLive;
		var retVal:String = "TASKS:\n";
		var currentListTask:Task = head;
		while (currentListTask) {
			
			retVal += "\t"
			
			if (!currentListTask._isEnabled || currentListTask._missingDependencyCount > 0) {
				retVal += "|\t";
			}
			
			retVal += currentListTask;
			
			if (!currentListTask._isEnabled) {
				retVal += "   (DISABLED)";
			}
			
			if (currentListTask._missingDependencyCount > 0) {
				retVal += "   (MISSING DEPENDENCIES:" + currentListTask._missingDependencyCount + ")";
			}
			
			retVal += "\n";
			
			currentListTask = currentListTask.next;
		}
		
		return retVal;
	}
	
	//----------------------------------
	//     internal
	//----------------------------------
	
	private function initTask(taskClass:Class, taskId:String):Task {
		use namespace mvcExpressLive;
		CONFIG::debug {
			//check for class type. (taskClass must be or subclass Task class.)
			if (!checkClassSuperclass(taskClass, "org.mvcexpress.live::Task")) {
				throw Error("taskClass:" + taskClass + " you are trying to mapTask is not extended from 'org.mvcexpress.live::Task' class.");
			}
		}
		// create task.
		var task:Task = new taskClass();
		processMap.initTask(task, taskClass);
		task.process = this;
		taskRegistry[taskId] = task;
		
		return task;
	}
	
	//----------------------------------
	//     internal
	//----------------------------------
	
	mvcExpressLive function register():void {
		onRegister();
	}
	
	mvcExpressLive function remove():void {
		use namespace mvcExpressLive;
		processId = null;
		onRemove();
		// remove all handlers
		removeAllHandlers();
		// dispose all tasks.
		for each (var item:Task in taskRegistry) {
			item.dispose();
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
	}
	
	mvcExpressLive function setModuleName(moduleName:String):void {
		this.moduleName = moduleName;
	}
	
	// send instant messages
	mvcExpressLive function sendInstantMessage(type:String, params:Object):void {
		// log the action
		CONFIG::debug {
			use namespace pureLegsCore;
			var moduleName:String = messenger.moduleName;
			MvcExpress.debug(new TraceProcess_sendMessage(MvcTraceActions.PROCESS_INSTANT_SENDMESSAGE, moduleName, this, type, params));
		}
		messenger.send(type, params);
		// clean up logging the action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceProcess_sendMessage(MvcTraceActions.PROCESS_INSTANT_SENDMESSAGE_CLEAN, moduleName, this, type, params));
		}
	
	}
	
	mvcExpressLive function stackPostMessage(type:String, params:Object):void {
		postMessageTypes.push(type);
		postMessageParams.push(params);
	}
	
	mvcExpressLive function stackFinalMessage(type:String, params:Object):void {
		finalMessageTypes.push(type);
		finalMessageParams.push(params);
	}
	
	mvcExpressLive function runProcess(event:Event = null):void {
		
		var moduleName:String;
		var params:Object;
		var type:String;
		
		use namespace mvcExpressLive;
		use namespace pureLegsCore;
		
		CONFIG::debug {
			var testRuns:Vector.<TastTestVO> = new Vector.<TastTestVO>();
		}
		
		var task:Task = head;
		
		while (task) {
			
			// run task:
			task.run();
			
			// do testing
			CONFIG::debug {
				var nowTimer:uint = getTimer();
				for (var i:int = 0; i < task.tests.length; i++) {
					var taskTestVo:TastTestVO = task.tests[i];
					// check if function run is needed.
					if (taskTestVo.totalDelay > 0) {
						taskTestVo.currentDelay -= nowTimer - taskTestVo.currentTimer;
						taskTestVo.currentTimer = nowTimer;
						if (taskTestVo.currentDelay <= 0) {
							taskTestVo.currentDelay = taskTestVo.totalDelay;
							testRuns.push(taskTestVo);
						}
					} else {
						testRuns.push(taskTestVo);
					}
					// send post messages
					while (postMessageTypes.length) {
						type = postMessageTypes.shift() as String;
						params = postMessageParams.shift();
						// log the action
						CONFIG::debug {
							use namespace pureLegsCore;
							moduleName = messenger.moduleName;
							MvcExpress.debug(new TraceProcess_sendMessage(MvcTraceActions.PROCESS_POST_SENDMESSAGE, moduleName, this, type, params));
						}
						messenger.send(type, params);
						// clean up logging the action
						CONFIG::debug {
							use namespace pureLegsCore;
							MvcExpress.debug(new TraceProcess_sendMessage(MvcTraceActions.PROCESS_POST_SENDMESSAGE_CLEAN, moduleName, this, type, params));
						}
					}
				}
			}
			
			task = task.next;
			
		}
		// send final messages
		while (finalMessageTypes.length) {
			type = finalMessageTypes.shift() as String;
			params = finalMessageParams.shift();
			// log the action
			CONFIG::debug {
				use namespace pureLegsCore;
				moduleName = messenger.moduleName;
				MvcExpress.debug(new TraceProcess_sendMessage(MvcTraceActions.PROCESS_FINAL_SENDMESSAGE, moduleName, this, type, params));
			}
			messenger.send(type, params);
			// clean up logging the action
			CONFIG::debug {
				use namespace pureLegsCore;
				MvcExpress.debug(new TraceProcess_sendMessage(MvcTraceActions.PROCESS_FINAL_SENDMESSAGE_CLEAN, moduleName, this, type, params));
			}
		}
		// run needed tests.
		CONFIG::debug {
			for (var t:int = 0; t < testRuns.length; t++) {
				var totalCount:int = testRuns[t].totalCount
				for (var j:int = 0; j < totalCount; j++) {
					testRuns[t].testFunction();
				}
			}
		}
	
	}

}
}