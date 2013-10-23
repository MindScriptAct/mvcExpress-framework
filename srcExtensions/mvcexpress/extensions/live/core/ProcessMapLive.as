// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.live.core {
import flash.display.Stage;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Dictionary;
import flash.utils.Timer;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer;

import mvcexpress.MvcExpress;
import mvcexpress.core.ProxyMap;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.live.core.inject.InjectRuleTaskVO;
import mvcexpress.extensions.live.engine.Process;
import mvcexpress.extensions.live.engine.Task;
import mvcexpress.extensions.live.taskTests.TaskTestVO;
import mvcexpress.extensions.live.taskTests.TestRuleVO;
import mvcexpress.extensions.live.traceObjects.MvcTraceActionsLive;
import mvcexpress.extensions.live.traceObjects.processMap.TraceProcessMap_provide;
import mvcexpress.extensions.live.traceObjects.processMap.TraceProcessMap_unprovide;
import mvcexpress.utils.checkClassSuperclass;

use namespace pureLegsCore;

/**
 * Handles application processes.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version live.1.0.beta2
 */
public class ProcessMapLive {

	// name of the module MediatorMap is working for.
	private var moduleName:String;

	// used internally for communications
	private var messenger:Messenger;

	// used internally to work with proxies.
	private var proxyMap:ProxyMap;

	// stage for enterFrame based processes.
	private var stage:Stage;

	/** Stores class QualifiedClassName by class */
	static private var qualifiedClassNameRegistry:Dictionary = new Dictionary(); //* of String by Class*/

	/** Stores all inject points by class. */
	static private var classInjectRules:Dictionary = new Dictionary();

	/** Dictionary with constonts of inject names, used with constName, and constScope. */
	static private var classConstRegistry:Dictionary = new Dictionary();

	/* Timers for timer besad processes, by name. */
	private var timerRegistry:Dictionary = new Dictionary(); //* of Timer by String */

	/* all processes storeb by id.(class definition + name) */
	private var processRegistry:Dictionary = new Dictionary(); //* of Process by String */

	/* all provided object by name*/
	private var provideRegistry:Dictionary = new Dictionary(); //* of Object by String */

	/* all running enterFrame processes */
	private var runningFrameProcesses:Vector.<Process> = new Vector.<Process>();

	/** All tasks stored by inject object name  */
	private var injectObjectRegistry:Dictionary = new Dictionary(); //* of Vector.<Task> by String */

	/* CONSTUCTOR */
	public function ProcessMapLive($moduleName:String, $messenger:Messenger, $proxyMap:ProxyMap) {
		moduleName = $moduleName;
		messenger = $messenger;
		proxyMap = $proxyMap;
	}

	//----------------------------------
	//     Set Stage
	//----------------------------------

	/**
	 * Sets stage for framework to be used for enterFrame processes.
	 * @param    stage    application Stage.
	 */
	public function setStage($stage:Stage):void {
		if (stage) {
			throw Error("Stage was already set for ProcessMap.");
		}
		stage = $stage;
	}

	//----------------------------------
	//     process maping
	//----------------------------------

	/**
	 * Maps enterFrame based process to class and optional name.            <br>
	 * Process onRegister() function  will be called at the end of this function.
	 * @param    processClass    Class of process
	 * @param    frameSkip        Option for process to skip frames to run all tasks.
	 * @param    name            Optional name for process. (if you will need 2 processes with same class running).
	 */
	public function mapFrameProcess(processClass:Class, frameSkip:int = 0, name:String = ""):void {
		use namespace pureLegsCore;

		// check if process class is valid
		CONFIG::debug {
			if (!checkClassSuperclass(processClass, "mvcexpress.extensions.live.engine::Process")) {
				throw Error("processClass:" + processClass + " you are trying to init is not extended from 'mvcexpress.extensions.live.engine::Process' class.");
			}
		}

		// get process id
		var className:String = qualifiedClassNameRegistry[processClass];
		if (!className) {
			className = getQualifiedClassName(processClass);
			qualifiedClassNameRegistry[processClass] = className
		}
		var processId:String = className + name;

		// create process
		CONFIG::debug {
			Process.canConstruct = true;
		}
		var process:Process = new processClass();
		process.setModuleName(moduleName);
		CONFIG::debug {
			Process.canConstruct = false;
		}

		// inject dependencies
		proxyMap.injectStuff(process, processClass);

		// init process.
		process.processType = Process.FRAME_PROCESS;
		process.processId = processId;
		process.messenger = messenger;
		process.processMap = this;

		process.totalFrameSkip = frameSkip;
		process.currentFrameSkip = frameSkip;
		processRegistry[processId] = process;

		// register process.
		process.register();

	}

	/**
	 * Maps Timer based process to class and optional name.                        <br>
	 * Process onRegister() function  will be called at the end of this function.
	 * @param    processClass    Class of process
	 * @param    delay            Delay of how often process will run all it's tasks.
	 * @param    name            Optional name for process. (if you will need 2 processes with same class running).
	 */
	public function mapTimerProcess(processClass:Class, delay:int = 1000, name:String = ""):void {
		use namespace pureLegsCore;

		// check if process class is valid
		CONFIG::debug {
			if (!checkClassSuperclass(processClass, "mvcexpress.extensions.live.engine::Process")) {
				throw Error("processClass:" + processClass + " you are trying to init is not extended from 'mvcexpress.extensions.live.engine::Process' class.");
			}
		}

		// get process id
		var className:String = qualifiedClassNameRegistry[processClass];
		if (!className) {
			className = getQualifiedClassName(processClass);
			qualifiedClassNameRegistry[processClass] = className
		}
		var processId:String = className + name;

		// create process
		CONFIG::debug {
			Process.canConstruct = true;
		}
		var process:Process = new processClass();
		process.setModuleName(moduleName);
		CONFIG::debug {
			Process.canConstruct = false;
		}

		// inject dependencies
		proxyMap.injectStuff(process, processClass);

		// init process.
		process.processType = Process.TIMER_PROCESS;
		process.processId = processId;
		process.messenger = messenger;
		process.processMap = this;

		var timer:Timer = new Timer(delay);
		timer.addEventListener(TimerEvent.TIMER, process.runProcess);
		timerRegistry[processId] = timer;

		processRegistry[processId] = process;

		// register process.
		process.register();

	}

	/**
	 * Unmaps process. Process will be stoped, all tasks and process disposed.
	 * @param    processClass    Class of process
	 * @param    name            Optional name for process.
	 */
	public function unmapProcess(processClass:Class, name:String = ""):void {
		use namespace pureLegsCore;

		// get process id
		var className:String = qualifiedClassNameRegistry[processClass];
		if (!className) {
			className = getQualifiedClassName(processClass);
			qualifiedClassNameRegistry[processClass] = className
		}
		var processId:String = className + name;

		var process:Process = processRegistry[processId];

		if (process._isRunning) {
			stopProcess(processClass, name);
		}

		if (process.processType == Process.TIMER_PROCESS) {
			var timer:Timer = timerRegistry[processId];
			timer.removeEventListener(TimerEvent.TIMER, process.runProcess);
			delete timerRegistry[processId];
		}

		process.remove();

		delete processRegistry[processId];
	}

	//----------------------------------
	//     Stop/start process
	//----------------------------------

	/**
	 * Start process indentified by class and optional name. <br>
	 * Process will start running all it's tasks.
	 * @param    processClass    Class of process
	 * @param    name            Optional name for process.
	 */
	public function startProcess(processClass:Class, name:String = ""):void {
		use namespace pureLegsCore;

		// get process id
		var className:String = qualifiedClassNameRegistry[processClass];
		if (!className) {
			className = getQualifiedClassName(processClass);
			qualifiedClassNameRegistry[processClass] = className
		}
		var processId:String = className + name;

		CONFIG::debug {
			if (!processRegistry[processId]) {
				throw Error("Process :" + processClass + "(" + name + ") you are trying to start is not mapped yet. Use mapFrameProcess() or mapTimerProcess() first.");
			}
		}

		startProcessObject(processRegistry[processId]);
	}

	/**
	 * Stop process indentified by class and optional name. <br>
	 * Process will halt running all it's tasks.
	 * @param    processClass    Class of process
	 * @param    name            Optional name for process.
	 */
	public function stopProcess(processClass:Class, name:String = ""):void {
		use namespace pureLegsCore;

		// get process id
		var className:String = qualifiedClassNameRegistry[processClass];
		if (!className) {
			className = getQualifiedClassName(processClass);
			qualifiedClassNameRegistry[processClass] = className
		}
		var processId:String = className + name;

		stopProcessObject(processRegistry[processId]);
	}

	//----------------------------------
	//     debug
	//----------------------------------

	/**
	 * Checks if processi is already mapped.
	 * @param    processClass    Class of process
	 * @param    name            Optional name for process.
	 */
	public function isProcessMapped(processClass:Class, name:String = ""):Boolean {
		var retVal:Boolean;

		// get process id
		var className:String = qualifiedClassNameRegistry[processClass];
		if (className) {
			retVal = (processRegistry[className + name] != null);
		}
		return retVal;
	}

	/**
	 * Returns text of all command classes that are mapped to constants. (for debugging)
	 * @return        Text with all mapped commands.
	 */
	public function listProcesses():String {
		use namespace pureLegsCore;

		var retVal:String = "";
		retVal = "===================== ProcessMap Mappings: =====================\n";
		for (var key:String in processRegistry) {
			var process:Process = processRegistry[key];
			retVal += "PROCESS: " + process + "  (" + ((process.isRunning ? "isRunning" : "NOT RUNNING.")) + ")\n";

			retVal += process.listTasks();
		}
		retVal += "================================================================\n";
		return retVal;
	}

	//----------------------------------
	//     INTERNAL
	//----------------------------------

	/** start process timer or add it to running enter frame processes.
	 * @private */
	pureLegsCore function startProcessObject(process:Process):void {
		use namespace pureLegsCore;

		if (process) {
			if (!process._isRunning) {
				process._isRunning = true;
				if (process.processType == Process.FRAME_PROCESS) {
					if (runningFrameProcesses.length == 0) {
						if (stage) {
							stage.addEventListener(Event.ENTER_FRAME, handleFrameProcesses);
						} else {
							throw Error("ProcessMap needs Stage set, if you want frame pcocesses to be able to run. Use 'processMap.setStage(...)' to set it. ");
						}
						runningFrameProcesses[runningFrameProcesses.length] = process;
					}
				} else {
					var timer:Timer = timerRegistry[process.processId];
					timer.start();
				}
			}
		} else {
			throw Error("Procces not found... process:" + process);
		}
	}

	// special function to handle enter frame events.
	private function handleFrameProcesses(event:Event):void {
		use namespace pureLegsCore;

		var frameProcessCount:int = runningFrameProcesses.length;
		for (var i:int = 0; i < frameProcessCount; i++) {
			var process:Process = runningFrameProcesses[i];
			if (process.totalFrameSkip > 0) {
				if (process.currentFrameSkip > 0) {
					process.currentFrameSkip--;
				} else {
					runningFrameProcesses[i].runProcess();
					process.currentFrameSkip = process.totalFrameSkip;
				}
			} else {
				runningFrameProcesses[i].runProcess();
			}
		}
	}

	/** stop process
	 * @private */
	pureLegsCore function stopProcessObject(process:Process):void {
		use namespace pureLegsCore;

		if (process) {
			if (process._isRunning) {
				process._isRunning = false;
				if (process.processType == Process.FRAME_PROCESS) {
					// find process for removal..
					var frameProcessCount:int = runningFrameProcesses.length;
					for (var i:int = 0; i < frameProcessCount; i++) {
						if (runningFrameProcesses[i] == process) {
							runningFrameProcesses.splice(i, 1);
							// remove handler if there is nothing to handle.
							if (runningFrameProcesses.length == 0) {
								if (stage) {
									stage.removeEventListener(Event.ENTER_FRAME, handleFrameProcesses);
								}
							}
							break;
						}
					}
				} else {
					var timer:Timer = timerRegistry[process.processId];
					timer.stop();
				}
			}

		} else {
			throw Error("Procces not found... process:" + process);
		}
	}

	//----------------------------------
	//     provide/unprovide
	//----------------------------------

	/** provides existing tasks with objects(fill or replaces them), stores provided objects for new tasks.
	 * @private */
	pureLegsCore function provide(object:Object, name:String):void {
		use namespace pureLegsCore;

		if (provideRegistry[name] != null) {
			throw Error("There is already object provided with name:" + name + " - " + provideRegistry[name]);
		}
		provideRegistry[name] = object;

		// check for invalid primitive data types.
		CONFIG::debug {
			var objectClassName:String = getQualifiedClassName(object);
			if (objectClassName == "String" || objectClassName == "Boolean" || objectClassName == "Number" || objectClassName == "int" || objectClassName == "uint" || objectClassName == "null") {
				throw Error("You provided primitive data type(" + objectClassName + ") value named:" + name + ". Only complex data types can be provided.");
			}
		}

		// log the action
		CONFIG::debug {
			use namespace pureLegsCore;

			MvcExpress.debug(new TraceProcessMap_provide(MvcTraceActionsLive.PROCESSMAP_PROVIDE, moduleName, name, object));
		}

		//add this inject in all existing tasks using it.
		var injectTasks:Vector.<Task> = injectObjectRegistry[name];
		if (injectTasks) {
			var injectTaskCount:int = injectTasks.length;
			for (var i:int = 0; i < injectTaskCount; i++) {
				var varname:String = injectTasks[i].getInjectPoint(name);

				// if varieble is empty - reduce dependency count.
				if (injectTasks[i][varname] == null) {
					var task:Task = injectTasks[i];
					task._missingDependencyCount--;
					task._isRunning = (task._isEnabled && task._missingDependencyCount == 0);
					// reset process cash.
					task.setNotCached();
				}
				// set new injection.
				injectTasks[i][varname] = object;
			}
		}
	}

	/** removes injected objects from tasks
	 * @private */
	pureLegsCore function unprovide(name:String):void {
		use namespace pureLegsCore;

		// log the action
		CONFIG::debug {
			use namespace pureLegsCore;

			MvcExpress.debug(new TraceProcessMap_unprovide(MvcTraceActionsLive.PROCESSMAP_UNPROVIDE, moduleName, name, provideRegistry[name]));
		}

		if (provideRegistry[name] != null) {

			delete provideRegistry[name];

			// clear all injects in tasks existing tasks...
			var injectTasks:Vector.<Task> = injectObjectRegistry[name];
			if (injectTasks) {
				var injectTaskCount:int = injectTasks.length;
				for (var i:int = 0; i < injectTaskCount; i++) {
					var varname:String = injectTasks[i].getInjectPoint(name);

					//if varieble is not empty - increase dependeny count.
					if (injectTasks[i][varname] != null) {
						var task:Task = injectTasks[i];
						task._missingDependencyCount++;
						task._isRunning = false;
						// reset process cash.
						task.setNotCached();
						// clear injection.
						task[varname] = null;
					}
				}
			}
		}
	}

	//----------------------------------
	//     INTERNAL - tasks
	//----------------------------------

	/** @private */
	pureLegsCore function initTask(task:Task, signatureClass:Class):void {
		use namespace pureLegsCore;

		// get class injection rules. (cashing is used.)
		var rules:Vector.<InjectRuleTaskVO> = classInjectRules[signatureClass];
		if (!rules) {
			rules = getInjectRules(signatureClass);
			classInjectRules[signatureClass] = rules;
		}

		// injects all proxy object dependencies using rules.
		var ruleCount:int = rules.length;
		for (var i:int = 0; i < ruleCount; i++) {
			CONFIG::debug {
				if (rules[i] is TestRuleVO) {
					var testRule:TestRuleVO = rules[i] as TestRuleVO;
					if (testRule.testCount > 0) {
						var taskTestVo:TaskTestVO = new TaskTestVO();
						taskTestVo.testFunction = task[testRule.functionName];
						taskTestVo.totalCount = testRule.testCount;
						taskTestVo.totalDelay = testRule.testDelay;
						taskTestVo.currentDelay = testRule.testDelay;
						taskTestVo.currentTimer = getTimer();
						task.tests.push(taskTestVo);

					}
					continue;
				}
			}
			var injectName:String = rules[i].injectClassAndName;
			var injectObject:Object = provideRegistry[injectName];

			task.setInjectPoint(injectName, rules[i].varName);

			if (injectObject) {
				task[rules[i].varName] = injectObject;
			} else {
				task._missingDependencyCount++;
				task._isRunning = false;
			}
			if (!injectObjectRegistry[injectName]) {
				injectObjectRegistry[injectName] = new Vector.<Task>();
			}
			var injectObjectTasks:Vector.<Task> = injectObjectRegistry[injectName];
			injectObjectTasks[injectObjectTasks.length] = task;
		}
	}

	/** DOIT : vector search used... think if it's possible to optimize it. (use linked list?)
	 * @private */
	pureLegsCore function removeTask(task:Task, signatureClass:Class):void {
		// get class injection rules. (cache is used.)
		var rules:Vector.<InjectRuleTaskVO> = classInjectRules[signatureClass];

		// find task by inject object name and remove it.
		var ruleCount:int = rules.length;
		for (var i:int = 0; i < ruleCount; i++) {
			var allTasks:Vector.<Task> = injectObjectRegistry[rules[i].injectClassAndName];
			if (allTasks) {
				var taskCount:int = allTasks.length;
				for (var j:int = 0; j < taskCount; j++) {
					if (allTasks[j] == task) {
						allTasks.splice(j, 1);
						break;
					}
				}
			}
		}
	}

	/** clear inject object registry then all tasks are removed.
	 * @private */
	pureLegsCore function removeAllTasks():void {
		injectObjectRegistry = new Dictionary();
	}

	/**
	 * Finds and cashes class injection point rules.
	 * Same function is in ProxyMap.
	 */
	private function getInjectRules(signatureClass:Class):Vector.<InjectRuleTaskVO> {
		var retVal:Vector.<InjectRuleTaskVO> = new Vector.<InjectRuleTaskVO>();
		var classDescription:XML = describeType(signatureClass);
		var factoryNodes:XMLList = classDescription.factory.*;

		var nodeCount:int = factoryNodes.length();
		for (var i:int = 0; i < nodeCount; i++) {
			var node:XML = factoryNodes[i];
			var nodeName:String = node.name();
			if (nodeName == "variable" || nodeName == "accessor") {
				var metadataList:XMLList = node.metadata;
				var metadataCount:int = metadataList.length();
				for (var j:int = 0; j < metadataCount; j++) {
					nodeName = metadataList[j].@name;
					if (nodeName == "Inject") {
						var injectName:String = "";
						var scopeName:String = "";
						var args:XMLList = metadataList[j].arg;
						var argCount:int = args.length();
						for (var k:int = 0; k < argCount; k++) {
							var argKey:String = args[k].@key
							if (argKey == "name") {
								injectName = args[k].@value;
							} else if (argKey == "scope") {
								scopeName = args[k].@value;
							} else if (argKey == "constName") {
								injectName = getInjectByContName(args[k].@value);
							} else if (argKey == "constScope") {
								scopeName = getInjectByContName(args[k].@value);
							}

						}
						var mapRule:InjectRuleTaskVO = new InjectRuleTaskVO();
						mapRule.varName = node.@name.toString();
						mapRule.injectClassAndName = injectName;
						mapRule.scopeName = scopeName;
						retVal[retVal.length] = mapRule
					}

				}
			}
			CONFIG::debug {
				if (nodeName == "method") {
					var methodMetadataList:XMLList = node.metadata;
					var methodCount:int = methodMetadataList.length();
					for (var m:int = 0; m < methodCount; m++) {
						nodeName = methodMetadataList[m].@name;
						if (nodeName == "Test") {
							var testDelay:int = 0;
							var testCount:int = 1;
							var testArgs:XMLList = methodMetadataList[m].arg;
							var cestArgCount:int = testArgs.length();
							for (var n:int = 0; n < cestArgCount; n++) {
								if (testArgs[n].@key == "delay") {
									testDelay = int(testArgs[n].@value);
								} else if (testArgs[n].@key == "count") {
									testCount = int(testArgs[n].@value);
								}
							}

							var testRule:TestRuleVO = new TestRuleVO();
							testRule.functionName = node.@name;
							testRule.testDelay = testDelay;
							testRule.testCount = testCount;

							retVal[retVal.length] = testRule;
						}
					}
				}
			}
		}
		return retVal;
	}

	// !!! code dublicated. [ProxyMap]
	[Inline]

	private function getInjectByContName(constName:String):String {
		if (!classConstRegistry[constName]) {
			var split:Array = constName.split(".");
			var className:String = split[0];
			var splitLength:int = split.length - 1;
			for (var spliteIndex:int = 1; spliteIndex < splitLength; spliteIndex++) {
				className += "." + split[spliteIndex];
			}
			try {
				var constClass:Class = getDefinitionByName(className) as Class;
				classConstRegistry[constName] = constClass[split[spliteIndex]];
				if (classConstRegistry[constName] == null) {
					throw Error("Failed to get constant out of class:" + constClass + " Check constant name: " + split[spliteIndex]);
				}
			} catch (error:Error) {
				throw Error("Failed to get constant out of constName:" + constName + " Can't get class from definition : " + className);
			}
		}
		return classConstRegistry[constName];
	}

	/** stop and remove all process, tasks, all dictionaries, remove timer events and stage event.
	 * @private */
	pureLegsCore function dispose():void {
		use namespace pureLegsCore;

		messenger = null;
		proxyMap = null;
		for each (var process:Process in processRegistry) {
			stopProcessObject(process);
			if (process.processType == Process.TIMER_PROCESS) {
				var timer:Timer = timerRegistry[process.processId];
				timer.removeEventListener(TimerEvent.TIMER, process.runProcess);
			}
			process.remove();
		}
		processRegistry = null;
		if (stage) {
			if (stage.hasEventListener(Event.ENTER_FRAME)) {
				stage.removeEventListener(Event.ENTER_FRAME, handleFrameProcesses);
			}
		}
		stage = null;
		timerRegistry = null;
		provideRegistry = null;
		runningFrameProcesses = null;
		injectObjectRegistry = null;
	}

}
}