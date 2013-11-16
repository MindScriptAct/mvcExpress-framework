package mvcexpress.extensions.workers.core.messenger {
import flash.net.registerClassAlias;
import flash.utils.Dictionary;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.workers.core.WorkerManager;
import mvcexpress.extensions.workers.data.ClassAliasRegistry;

/**
 * Messenger to send messages from worker to worker.
 * @private
 */
public class WorkerMessenger extends Messenger {

	static private const $classAliasRegistry:Dictionary = ClassAliasRegistry.getAliasRegistry();

	// true if messenger is ready for use.
	private var isReady:Boolean;// = false;

	// messages are stored here if messenger is requested to send message while it is not ready.
	private var pendingDestinationModules:Vector.<String> = new <String>[];
	private var pendingTypes:Vector.<String> = new <String>[];
	private var pendingParams:Vector.<Object> = new <Object>[];

	/**
	 * CONSTRUCTOR
	 * @param $moduleName
	 */
	public function WorkerMessenger($moduleName:String) {
		super($moduleName);
	}

	// send message
	public function workerSend(destinationModule:String, type:String, params:Object = null):void {
		// messenger is not ready until worker is ready.
		if (isReady) {
			// handle parameters types. (register class alias if needed).
			if (params) {
				if (WorkerManager.doAutoRegisterClasses) {
					var paramClass:Class = params.constructor;
					var qualifiedName:String = $classAliasRegistry[paramClass];
					if (!qualifiedName) {
						handleClassAliases(params.constructor);
					}
				}
			}

			use namespace pureLegsCore;

			// send message to other workers.
			WorkerManager.sendWorkerMessageToRemoteChannel(destinationModule, type, params);
		} else {
			// messenger is not ready, push to pending vector and wait for it to be ready.
			pendingDestinationModules.push(destinationModule);
			pendingTypes.push(type);
			pendingParams.push(params);
		}
	}

	// make messenger ready.
	pureLegsCore function ready():void {
		isReady = true;

		// send all waiting messages.
		while (pendingTypes.length) {
			workerSend(pendingDestinationModules.pop(), pendingTypes.pop(), pendingParams.pop());
		}
	}

	// handle class aliases
	private function handleClassAliases(paramClass:Class):void {
		use namespace pureLegsCore;

		// TODO : check if object class constructor has parameters, handle those too.

		qualifiedName = getQualifiedClassName(paramClass).replace("::", ".");

		//trace("start registration ... ", qualifiedName);
		registerClassAlias(qualifiedName, paramClass);

		$classAliasRegistry[paramClass] = qualifiedName;

		// register class alias with all workers.
		WorkerManager.startClassRegistration(qualifiedName);

		// handle member types.
		var classDescription:XML = describeType(paramClass);
		var factoryNodes:XMLList = classDescription.factory.*;
		var nodeCount:int = factoryNodes.length();
		for (var i:int; i < nodeCount; i++) {
			var node:XML = factoryNodes[i];
			var nodeName:String = node.name();
			if (nodeName == "variable" || nodeName == "accessor") {

				var memberClass:Class = getDefinitionByName(factoryNodes[i].@type) as Class;

				var qualifiedName:String = $classAliasRegistry[memberClass];
				if (!qualifiedName) {
					handleClassAliases(memberClass);
				}
			}
		}
	}
}
}
