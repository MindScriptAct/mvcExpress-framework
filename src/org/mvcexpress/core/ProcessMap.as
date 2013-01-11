// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core {
import flash.display.Stage;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.describeType;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer;
import flash.utils.Timer;
import org.mvcexpress.core.inject.InjectRuleVO;
import org.mvcexpress.core.inject.TestRuleVO;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.core.namespace.mvcExpressLive;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.taskTest.TaskTestVO;
import org.mvcexpress.core.traceObjects.live.processMap.TraceProcessMap_provide;
import org.mvcexpress.core.traceObjects.live.processMap.TraceProcessMap_unprovide;
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.live.Process;
import org.mvcexpress.live.Task;
import org.mvcexpress.MvcExpress;
import org.mvcexpress.utils.checkClassSuperclass;

/**
 * Handles application processes.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ProcessMap {
	
	// name of the module MediatorMap is working for.
	private var moduleName:String;
	
	// for internal use.
	private var messenger:Messenger;
	
	private var stage:Stage;
	
	/** Stores class QualifiedClassName by class */
	static private var qualifiedClassNameRegistry:Dictionary = new Dictionary(); /* of String by Class*/
	
	static private var classInjectRules:Dictionary = new Dictionary();
	
	/** Dictionary with constonts of inject names, used with constName, and constScope. */
	static private var classConstRegistry:Dictionary = new Dictionary();
	
	private var timerRegistry:Dictionary = new Dictionary();
	
	private var processRegistry:Dictionary = new Dictionary();
	
	private var provideRegistry:Dictionary = new Dictionary();
	
	private var runningFrameProcesses:Vector.<Process> = new Vector.<Process>();
	
	/** All tasks stored by inject object name  */
	private var injectObjectRegistry:Dictionary = new Dictionary(); /* of Vector.<Task> by String */
	
	public function ProcessMap(moduleName:String, messenger:Messenger) {
		this.moduleName = moduleName;
		this.messenger = messenger;
	
	}
	
	public function mapFrameProcess(processClass:Class, frameSkip:int = 0, name:String = ""):void {
		
		// check if process class provided
		CONFIG::debug {
			if (!checkClassSuperclass(processClass, "org.mvcexpress.live::Process")) {
				throw Error("processClass:" + processClass + " you are trying to init is not extended from 'org.mvcexpress.live::Process' class.");
			}
		}
		
		use namespace mvcExpressLive;
		use namespace pureLegsCore;
		
		var className:String = ProcessMap.qualifiedClassNameRegistry[processClass];
		if (!className) {
			className = getQualifiedClassName(processClass);
			ProcessMap.qualifiedClassNameRegistry[processClass] = className
		}
		var processId:String = className + name;
		
		CONFIG::debug {
			Process.canConstruct = true;
		}
		var process:Process = new processClass();
		process.setModuleName(moduleName);
		CONFIG::debug {
			Process.canConstruct = false;
		}
		
		process.processType = Process.FRAME_PROCESS;
		process.processId = processId;
		process.messenger = messenger;
		process.processMap = this;
		
		process.register();
		process.totalFrameSkip = frameSkip;
		process.currentFrameSkip = frameSkip;
		
		processRegistry[processId] = process;
	
	}
	
	public function mapTimerProcess(processClass:Class, delay:int = 1000, name:String = ""):void {
		
		use namespace mvcExpressLive;
		use namespace pureLegsCore;
		
		// check if process class provided
		CONFIG::debug {
			if (!checkClassSuperclass(processClass, "org.mvcexpress.live::Process")) {
				throw Error("processClass:" + processClass + " you are trying to init is not extended from 'org.mvcexpress.live::Process' class.");
			}
		}
		
		var className:String = ProcessMap.qualifiedClassNameRegistry[processClass];
		if (!className) {
			className = getQualifiedClassName(processClass);
			ProcessMap.qualifiedClassNameRegistry[processClass] = className
		}
		var processId:String = className + name;
		
		CONFIG::debug {
			Process.canConstruct = true;
		}
		var process:Process = new processClass();
		process.setModuleName(moduleName);
		CONFIG::debug {
			Process.canConstruct = false;
		}
		
		process.processType = Process.TIMER_PROCESS;
		process.processId = processId;
		process.messenger = messenger;
		process.processMap = this;
		
		var timer:Timer = new Timer(delay);
		timer.addEventListener(TimerEvent.TIMER, process.runProcess);
		
		timerRegistry[processId] = timer;
		
		process.register();
		
		processRegistry[processId] = process;
	
	}
	
	public function unmapProcess(processClass:Class, name:String = ""):void {
		use namespace mvcExpressLive;
		
		var className:String = ProcessMap.qualifiedClassNameRegistry[processClass];
		if (!className) {
			className = getQualifiedClassName(processClass);
			ProcessMap.qualifiedClassNameRegistry[processClass] = className
		}
		var processId:String = className + name;
		
		var process:Process = processRegistry[processId];
		
		if (process._isRunning) {
			stopProcess(processClass, name);
		}
		
		// TODO dispose properly...
		process.remove();
		
		delete processRegistry[processId];
	
	}
	
	public function startProcess(processClass:Class, name:String = ""):void {
		//trace("ProcessMap.startProcess > processClass : " + processClass);
		use namespace mvcExpressLive;
		
		var className:String = ProcessMap.qualifiedClassNameRegistry[processClass];
		if (!className) {
			className = getQualifiedClassName(processClass);
			ProcessMap.qualifiedClassNameRegistry[processClass] = className
		}
		var processId:String = className + name;
		
		//CONFIG::debug {
		
		// TODO : check if process exists
		//}
		
		startProcessObject(processRegistry[processId]);
	}
	
	mvcExpressLive function startProcessObject(process:Process):void {
		use namespace mvcExpressLive;
		if (process) {
			if (!process._isRunning) {
				process._isRunning = true;
				if (process.processType == Process.FRAME_PROCESS) {
					if (runningFrameProcesses.length == 0) {
						if (this.stage) {
							this.stage.addEventListener(Event.ENTER_FRAME, handleFrameProcesses);
						} else {
							throw Error("ProcessMap needs Stage set, if you want frame pcocesses to be able to run. Use 'processMap.setStage(...)' to set it. ");
						}
						runningFrameProcesses.push(process);
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
	
	private function handleFrameProcesses(event:Event):void {
		//trace( "ProcessMap.handleFrameProcesses > event : " + event );
		use namespace mvcExpressLive;
		for (var i:int = 0; i < runningFrameProcesses.length; i++) {
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
	
	public function stopProcess(processClass:Class, name:String = ""):void {
		//trace("ProcessMap.stopProcess > processClass : " + processClass + ", name : " + name);
		use namespace mvcExpressLive;
		
		var className:String = ProcessMap.qualifiedClassNameRegistry[processClass];
		if (!className) {
			className = getQualifiedClassName(processClass);
			ProcessMap.qualifiedClassNameRegistry[processClass] = className
		}
		var processId:String = className + name;
		
		//CONFIG::debug {
		// TODO : check if process exists
		//}
		
		stopProcessObject(processRegistry[processId]);
	}
	
	mvcExpressLive function stopProcessObject(process:Process):void {
		use namespace mvcExpressLive;
		if (process) {
			if (process._isRunning) {
				process._isRunning = false;
				if (process.processType == Process.FRAME_PROCESS) {
					// find process for removal..
					for (var i:int = 0; i < runningFrameProcesses.length; i++) {
						if (runningFrameProcesses[i] == process) {
							runningFrameProcesses.splice(i, 1);
							// remove handler if there is nothing to handle.
							if (runningFrameProcesses.length == 0) {
								if (this.stage) {
									this.stage.removeEventListener(Event.ENTER_FRAME, handleFrameProcesses);
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
	
	/* INTERFACE org.mvcexpress.core.interfaces.IProcessMap */
	
	public function provide(object:Object, name:String):void {
		use namespace mvcExpressLive;
		if (provideRegistry[name] != null) {
			throw Error("There is already object provided with name:" + name + " - " + provideRegistry[name]);
		}
		provideRegistry[name] = object;
		
		// log the action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceProcessMap_provide(MvcTraceActions.PROCESSMAP_PROVIDE, moduleName, name, object));
		}
		
		//add this inject in all existing tasks using it.
		var injectTasks:Vector.<Task> = injectObjectRegistry[name];
		if (injectTasks) {
			for (var i:int = 0; i < injectTasks.length; i++) {
				var varname:String = injectTasks[i].getInjectPoint(name);
				
				// if varieble is empty - reduce dependency count.
				if (injectTasks[i][varname] == null) {
					injectTasks[i]._missingDependencyCount--;
					// reset process cash.
					injectTasks[i].setNotCached();
				}
				// set new injection.
				injectTasks[i][varname] = object;
			}
		}
	}
	
	public function unprovide(object:Object, name:String):void {
		use namespace mvcExpressLive;
		
		// log the action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceProcessMap_unprovide(MvcTraceActions.PROCESSMAP_UNPROVIDE, moduleName, name, object));
		}
		
		if (provideRegistry[name] != null) {
			
			delete provideRegistry[name];
			
			// clear all injects in tasks existing tasks...
			var injectTasks:Vector.<Task> = injectObjectRegistry[name];
			if (injectTasks) {
				for (var i:int = 0; i < injectTasks.length; i++) {
					var varname:String = injectTasks[i].getInjectPoint(name);
					
					//if varieble is not empty - increase dependeny count.
					if (injectTasks[i][varname] != null) {
						injectTasks[i]._missingDependencyCount++;
						// reset process cash.
						injectTasks[i].setNotCached();
						// clear injection.
						injectTasks[i][varname] = null;
					}
				}
			}
		}
	}
	
	public function setStage(stage:Stage):void {
		if (this.stage) {
			throw Error("Stage was already set for ProcessMap.");
		}
		this.stage = stage;
	}
	
	//----------------------------------
	//     debug
	//----------------------------------
	
	/**
	 * Returns text of all command classes that are mapped to messages. (for debugging)
	 * @return		Text with all mapped commands.
	 */
	public function listProcesses():String {
		use namespace mvcExpressLive;
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
	
	mvcExpressLive function initTask(task:Task, signatureClass:Class):void {
		//trace("ProcessMap.initTask > task : " + task + ", signatureClass : " + signatureClass);
		use namespace pureLegsCore;
		use namespace mvcExpressLive;
		
		// get class injection rules. (cashing is used.)
		var rules:Vector.<InjectRuleVO> = ProcessMap.classInjectRules[signatureClass];
		if (!rules) {
			rules = getInjectRules(signatureClass);
			ProcessMap.classInjectRules[signatureClass] = rules;
		}
		
		// injects all proxy object dependencies using rules.
		for (var i:int = 0; i < rules.length; i++) {
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
			}
			if (!injectObjectRegistry[injectName]) {
				injectObjectRegistry[injectName] = new Vector.<Task>();
			}
			injectObjectRegistry[injectName].push(task);
		}
	}
	
	
	// TODO : vector search used... think if its posible to optimize it. (use linked list?)
	mvcExpressLive function removeTask(task:Task, signatureClass:Class):void {
		// get class injection rules. (cache is used.)
		var rules:Vector.<InjectRuleVO> = ProcessMap.classInjectRules[signatureClass];
		
		// find task by inject object name and remove it.
		for (var i:int = 0; i < rules.length; i++) {
			var allTasks:Vector.<Task> = injectObjectRegistry[rules[i].injectClassAndName];
			if (allTasks) {
				for (var j:int = 0; j < allTasks.length; j++) {
					if (allTasks[j] == task) {
						allTasks.splice(j, 1);
						break;
					}
				}
			}
		}
	}
	
	// remove indejet object registry data then all tasks are removed.
	mvcExpressLive function removeAllTasks():void {
		injectObjectRegistry = new Dictionary();
	}
	
	/**
	 * Finds and cashes class injection point rules.
	 */
	// TODO : dublicated code... (from ProxyMap .... but it deffers... injectClassAndName... provide tag...)
	private function getInjectRules(signatureClass:Class):Vector.<InjectRuleVO> {
		var retVal:Vector.<InjectRuleVO> = new Vector.<InjectRuleVO>();
		var classDescription:XML = describeType(signatureClass);
		var factoryNodes:XMLList = classDescription.factory.*;
		
		for (var i:int = 0; i < factoryNodes.length(); i++) {
			var node:XML = factoryNodes[i];
			var nodeName:String = node.name();
			if (nodeName == "variable" || nodeName == "accessor") {
				var metadataList:XMLList = node.metadata;
				for (var j:int = 0; j < metadataList.length(); j++) {
					nodeName = metadataList[j].@name;
					if (nodeName == "Inject") {
						var injectName:String = "";
						var scopeName:String = "";
						var args:XMLList = metadataList[j].arg;
						for (var k:int = 0; k < args.length(); k++) {
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
						var mapRule:InjectRuleVO = new InjectRuleVO();
						mapRule.varName = node.@name.toString();
						mapRule.injectClassAndName = injectName;
						mapRule.scopeName = scopeName;
						retVal.push(mapRule);
					}
					
				}
			}
			CONFIG::debug {
				if (nodeName == "method") {
					var methodMetadataList:XMLList = node.metadata;
					for (var m:int = 0; m < methodMetadataList.length(); m++) {
						nodeName = methodMetadataList[m].@name;
						if (nodeName == "Test") {
							var testDelay:int = 0;
							var testCount:int = 1;
							var testArgs:XMLList = methodMetadataList[m].arg;
							for (var n:int = 0; n < testArgs.length(); n++) {
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
							
							retVal.push(testRule);
						}
					}
				}
			}
		}
		return retVal;
	}
	
	[Inline]
	
	// TODO : add error checking.
	private function getInjectByContName(constName:String):String {
		if (!classConstRegistry[constName]) {
			var split:Array = constName.split(".");
			var className:String = split[0];
			for (var spliteIndex:int = 1; spliteIndex < split.length - 1; spliteIndex++) {
				className += "." + split[spliteIndex];
			}
			var constClass:Class = getDefinitionByName(className) as Class;
			classConstRegistry[constName] = constClass[split[spliteIndex]];
		}
		return classConstRegistry[constName];
	}
	
	pureLegsCore function dispose():void {
		use namespace mvcExpressLive;
		for each (var process:Process in processRegistry) {
			stopProcessObject(process);
		}
		messenger = null;
		stage = null;
		timerRegistry = null;
		processRegistry = null;
		provideRegistry = null;
		runningFrameProcesses = null;
		injectObjectRegistry = null;
	}

}
}