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
	
	mvcExpressLive var type:int;
	mvcExpressLive var processId:String;
	
	mvcExpressLive var totalFrameSkip:int = 0;
	mvcExpressLive var currentFrameSkip:int = 0;
	
	private var taskRegistry:Dictionary = new Dictionary();
	
	// used internally for process management
	/** @private */
	mvcExpressLive var processMap:ProcessMap;
	
	// used internally for communication
	/** @private */
	pureLegsCore var messenger:Messenger;
	
	/** all added message handlers. */
	private var handlerVoRegistry:Vector.<HandlerVO> = new Vector.<HandlerVO>();
	
	private var head:Task;
	private var tail:Task;
	
	private var _isRunning:Boolean = false;
	
	private var postMessageTypes:Vector.<String> = new Vector.<String>();
	private var postMessageParams:Vector.<Object> = new Vector.<Object>();
	
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
	
	public function onRegister():void {
		// for overide
	}
	
	public function onRemove():void {
		// for overide
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
	//     task managment
	//----------------------------------
	
	protected function addHeadTask(headTask:Task):void {
		if (head) {
			throw Error("Head is already added.");
		}
		// TODO: check if task is mapped.
		
		head = headTask;
		tail = headTask;
	}
	
	protected function addTask(task:Task):void {
		if (!head) {
			addHeadTask(task);
		} else {
			tail.addTask(task);
			tail = task;
		}
	}
	
	public function mapTask(taskClass:Class, name:String = ""):Task {
		use namespace mvcExpressLive;
		
		var className:String = getQualifiedClassName(taskClass);
		var taskId:String = className + name;
		
		CONFIG::debug {
			// check for class type. (taskClass must be or subclass Task class.)
			if (!checkClassSuperclass(taskClass, "org.mvcexpress.live::Task")) {
				throw Error("taskClass:" + taskClass + " you are trying to mapTask is not extended from 'org.mvcexpress.live::Task' class.");
			}
			// check for dublications. (task must be unique)
			if (taskRegistry[taskId] != null) {
				throw Error("Task already mapped to this process: className:" + className + ", name:" + name);
			}
		}
		
		var task:Task = new taskClass();
		processMap.initTask(task, taskClass);
		task.process = this;
		taskRegistry[taskId] = task;
		
		return task;
	}
	
	mvcExpressLive function setModuleName(moduleName:String):void {
		this.moduleName = moduleName;
	}
	
	mvcExpressLive function stackPostMessage(type:String, params:Object):void {
		postMessageTypes.push(type);
		postMessageParams.push(params);
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
		processMap = null;
		
		postMessageTypes = null;
		postMessageParams = null;
	}
	
	public function get isRunning():Boolean {
		return _isRunning;
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
	//     internal
	//----------------------------------
	
	mvcExpressLive function runProcess(event:Event = null):void {
		//trace("Process.runProcess > event : " + event);
		use namespace mvcExpressLive;
		use namespace pureLegsCore;
		CONFIG::debug {
			var testRuns:Vector.<TastTestVO> = new Vector.<TastTestVO>();
		}
		var current:Task = head;
		while (current) {
			current.run();
			// do testing
			CONFIG::debug {
				var nowTimer:uint = getTimer();
				for (var i:int = 0; i < current.tests.length; i++) {
					var taskTestVo:TastTestVO = current.tests[i];
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
				}
			}
			// go to next fork.
			if (current.forks) {
				current = current.forks[current.forkId]
				current.forkId = 0;
			} else {
				break;
			}
		}
		// send post messages
		while (postMessageTypes.length) {
			var type:String = postMessageTypes.shift() as String;
			var params:Object = postMessageParams.shift();
			// log the action
			CONFIG::debug {
				use namespace pureLegsCore;
				
				var moduleName:String = messenger.moduleName;
				MvcExpress.debug(new TraceProcess_sendMessage(MvcTraceActions.PROCESS_POST_SENDMESSAGE, moduleName, this, type, params));
			}
			messenger.send(type, params);
			// clean up logging the action
			CONFIG::debug {
				use namespace pureLegsCore;
				MvcExpress.debug(new TraceProcess_sendMessage(MvcTraceActions.PROCESS_POST_SENDMESSAGE_CLEAN, moduleName, this, type, params));
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
	
	mvcExpressLive function setIsRunning(value:Boolean):void {
		_isRunning = value;
	}

}
}