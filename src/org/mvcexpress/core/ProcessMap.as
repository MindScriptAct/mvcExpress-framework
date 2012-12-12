// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core {
import flash.display.Stage;
import flash.events.TimerEvent;
import flash.sampler.NewObjectSample;
import flash.utils.describeType;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import flash.utils.Timer;
import org.mvcexpress.core.inject.InjectRuleVO;
import org.mvcexpress.core.interfaces.IProcessMap;
import org.mvcexpress.core.namespace.mvcExpressLive;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.live.Process;
import org.mvcexpress.live.Task;
import org.mvcexpress.utils.checkClassSuperclass;

/**
 * Handles application processes.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ProcessMap implements IProcessMap {
	
	// name of the module MediatorMap is working for.
	private var moduleName:String;
	
	private var timerRegistry:Dictionary = new Dictionary();
	
	private var processRegistry:Dictionary = new Dictionary();
	
	private var provideRegistry:Dictionary = new Dictionary();
	
	static private var classInjectRules:Dictionary = new Dictionary();
	private var stage:Stage;
	
	public function ProcessMap(moduleName:String) {
		this.moduleName = moduleName;
	
	}
	
	public function initFrameProcess(processClass:Class):Process {
		
		// check if process class provided
		CONFIG::debug {
			if (!checkClassSuperclass(processClass, "org.mvcexpress.live::Process")) {
				throw Error("processClass:" + processClass + " you are trying to init is not extended from 'org.mvcexpress.live::Process' class.");
			}
		}
		
		use namespace mvcExpressLive;
		
		var process:Process = new processClass();
		process.processMap = this;
		return process;
	}
	
	public function initTimerProcess(processClass:Class, delay:int = 1000, name:String = ""):Process {
		
		use namespace mvcExpressLive;
		
		// check if process class provided
		CONFIG::debug {
			if (!checkClassSuperclass(processClass, "org.mvcexpress.live::Process")) {
				throw Error("processClass:" + processClass + " you are trying to init is not extended from 'org.mvcexpress.live::Process' class.");
			}
		}
		
		var className:String = getQualifiedClassName(processClass);
		
		var processId:String = className + name;
		
		var process:Process = new processClass();
		process.processMap = this;
		
		var timer:Timer = new Timer(delay);
		timer.addEventListener(TimerEvent.TIMER, process.runProcess);
		
		timerRegistry[processId] = timer;
		
		processRegistry[processId] = process;
		
		return process;
	}
	
	public function startProcess(processClass:Class, name:String = ""):void {
		trace("ProcessMap.startProcess > processClass : " + processClass);
		
		var className:String = getQualifiedClassName(processClass);
		var processId:String = className + name;
		
		var timer:Timer = timerRegistry[processId];
		timer.start();
	}
	
	public function stopProcess(processClass:Class, name:String = ""):void {
		trace("ProcessMap.stopProcess > processClass : " + processClass + ", name : " + name);
		
		var className:String = getQualifiedClassName(processClass);
		var processId:String = className + name;
		
		var timer:Timer = timerRegistry[processId];
		timer.stop();
	}
	
	/* INTERFACE org.mvcexpress.core.interfaces.IProcessMap */
	
	public function provide(object:Object, name:String):void {
		trace("Process.provide > object : " + object + ", name : " + name);
		
		// TODO : check stuff...
		
		provideRegistry[name] = object;
	
	}
	
	public function setStage(stage:Stage):void {
		if (this.stage) {
			throw Error("Stage was already set for ProcessMap.");
		}
		this.stage = stage;
	}
	
	mvcExpressLive function initTask(task:Task, signatureClass:Class):void {
		trace("ProcessMap.initTask > task : " + task + ", signatureClass : " + signatureClass);
		use namespace pureLegsCore;
		
		// get class injection rules. (cashing is used.)
		var rules:Vector.<InjectRuleVO> = ProcessMap.classInjectRules[signatureClass];
		if (!rules) {
			rules = getInjectRules(signatureClass);
			ProcessMap.classInjectRules[signatureClass] = rules;
		}
		
		// injects all proxy object dependencies using rules.
		for (var i:int = 0; i < rules.length; i++) {
			var injectObject:Object = provideRegistry[rules[i].injectClassAndName];
			if (injectObject) {
				task[rules[i].varName] = injectObject;
			} else {
				throw Error("Process dependency is not provided with name:" + rules[i].injectClassAndName);
			}
		}
	
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
							if (args[k].@key == "name") {
								injectName = args[k].@value;
							} else if (args[k].@key == "scope") {
								scopeName = args[k].@value;
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
		}
		return retVal;
	}

}
}