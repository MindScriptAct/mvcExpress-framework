// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.live {
import flash.events.Event;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import org.mvcexpress.core.namespace.mvcExpressLive;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.ProcessMap;
import org.mvcexpress.utils.checkClassSuperclass;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class Process {
	
	static public const FRAME_PROCESS:int = 0;
	
	static public const TIMER_PROCESS:int = 1;
	
	mvcExpressLive var type:int;
	
	mvcExpressLive var totalFrameSkip:int = 0;
	mvcExpressLive var currentFrameSkip:int = 0;
	
	private var taskRegistry:Dictionary = new Dictionary();
	
	mvcExpressLive var processMap:ProcessMap;
	
	private var head:Task;
	
	private var _isRunning:Boolean = false;
	
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
	
	}
	
	public function onRemove():void {
	
	}
	
	public function addHeadTask(headTask:Task):void {
		if (head) {
			throw Error("Head is already added.");
		}
		// TODO: check if task is mapped.
		
		head = headTask;
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
		
		taskRegistry[taskId] = task;
		
		return task;
	}
	
	mvcExpressLive function remove():void {
		use namespace mvcExpressLive;
		onRemove();
		// remove all forks
		for each (var item:Task in taskRegistry) {
			item.forks = null;
		}
		taskRegistry = null;
		// null internals
		head = null;
		processMap = null;
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
	
	public function get isRunning():Boolean {
		return _isRunning;
	}
	
	mvcExpressLive function setIsRunning(value:Boolean):void {
		_isRunning = value;
	}

}
}