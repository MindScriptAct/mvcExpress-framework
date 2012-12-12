// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core {
import flash.events.TimerEvent;
import flash.sampler.NewObjectSample;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import flash.utils.Timer;
import org.mvcexpress.core.namespace.mvcExpressLive;
import org.mvcexpress.live.Process;
import org.mvcexpress.live.Task;
import org.mvcexpress.utils.checkClassSuperclass;

/**
 * Handles application processes.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ProcessMap {
	
	private var timerRegistry:Dictionary = new Dictionary();
	private var processRegistry:Dictionary = new Dictionary();
	
	public function ProcessMap() {
	
	}
	
	public function initFrameProcess(processClass:Class):Process {
		
		// check if process class provided
		CONFIG::debug {
			if (!checkClassSuperclass(processClass, "org.mvcexpress.live::Process")) {
				throw Error("processClass:" + processClass + " you are trying to init is not extended from 'org.mvcexpress.live::Process' class.");
			}
		}
		
		var process:Process = new processClass();
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

}
}