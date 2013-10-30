// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core {
import flash.utils.Dictionary;

import mvcexpress.MvcExpress;
import mvcexpress.core.inject.InjectTester;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.errors.TraceError;
import mvcexpress.core.traceObjects.moduleManager.TraceModuleManager_createModule;
import mvcexpress.core.traceObjects.moduleManager.TraceModuleManager_disposeModule;
import mvcexpress.modules.ModuleCore;

use namespace pureLegsCore;

/**
 * INTERNAL FRAMEWORK CLASS.
 * Manages mvcExpress modules.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version 2.0.rc1
 */
public class ModuleManager {

	/* messenger counter, increased with every new created module */
	static private var _moduleId:int;

	/* modules stored by moduleName */
	static private var moduleRegistry:Dictionary = new Dictionary(); //* of ModuleCore by String */

	static private var needMetadataTest:Boolean = true;

	/** CONSTRUCTOR */
	public function ModuleManager() {
		throw Error("ModuleFactory is static framework class for internal use. Not meant to be instantiated.");
	}

	/**
	 * Registers module for given name. (or generates new name if it is not given.)
	 * @param moduleName    name for module
	 * @param moduleCore    module object for given name
	 * @return    returns name (same as provided or generated new one) of the module.
	 *
	 * @private
	 */
	static pureLegsCore function registerModule(moduleName:String, moduleCore:ModuleCore):String {

		// tests if framework can read 'Inject' metadata tag.
		if (needMetadataTest) {
			needMetadataTest = false;
			var injectTest:InjectTester = new InjectTester();
			if (!injectTest.testInjectMetaTag()) {
				use namespace pureLegsCore;

				if (MvcExpress.loggerFunction != null) {
					MvcExpress.loggerFunction(new TraceError(moduleName, "mvcExpress framework failed to use 'Inject' metadata. Please add '-keep-as3-metadata+=Inject' to compile arguments."));
				}
				if (MvcExpress.debugFunction != null) {
					MvcExpress.debugFunction("mvcExpress framework failed to use 'Inject' metadata. Please add '-keep-as3-metadata+=Inject' to compile arguments.");
				}
				throw Error("mvcExpress framework failed to use 'Inject' metadata. Please add '-keep-as3-metadata+=Inject' to compile arguments.");
			}
		}

		// debug this action
		CONFIG::debug {
			use namespace pureLegsCore;

			MvcExpress.debug(new TraceModuleManager_createModule(moduleName));
		}
		if (moduleRegistry[moduleName] == null) {
			_moduleId++;
			//
			if (!moduleName) {
				moduleName = "module" + _moduleId;
			}
			//
			moduleRegistry[moduleName] = moduleCore;
			//
		} else {
			throw Error("You can't have 2 modules with same name. call disposeModule() on old module before creating new one with same name. [moduleName:" + moduleName + "]");
		}
		return moduleName;
	}

	/**
	 * get messenger for module name.
	 * @private
	 */
	static pureLegsCore function getModuleMessenger(moduleName:String):Messenger {
		use namespace pureLegsCore;

		return moduleRegistry[moduleName].messenger;
	}

	/**
	 * get proxyMap for module name.
	 * @private
	 */
	static pureLegsCore function getModuleProxyMap(moduleName:String):Messenger {
		use namespace pureLegsCore;

		return moduleRegistry[moduleName].getProxyMap();
	}

	/**
	 * get mediatorMap for module name.
	 * @private
	 */
	static pureLegsCore function getModuleMediatorMap(moduleName:String):MediatorMap {
		use namespace pureLegsCore;

		return moduleRegistry[moduleName].getMediatorMap();
	}

	/**
	 * get commandMap for module name.
	 * @private
	 */
	static pureLegsCore function getModuleCommandMap(moduleName:String):CommandMap {
		use namespace pureLegsCore;

		return moduleRegistry[moduleName].getCommandMap();
	}


	/**
	 * get module object for module name.
	 * @private
	 */
	static pureLegsCore function getModule(moduleName:String):ModuleCore {
		return moduleRegistry[moduleName];
	}

	/**
	 * disposes of messenger for module name.
	 * @param    moduleName    name of the module this messenger was belong to.
	 * @private
	 */
	static pureLegsCore function disposeModule(moduleName:String):void {
		use namespace pureLegsCore;

		// debug this action
		CONFIG::debug {
			MvcExpress.debug(new TraceModuleManager_disposeModule(moduleName));
		}
		if (moduleRegistry[moduleName]) {
			delete moduleRegistry[moduleName];
		} else {
			throw Error("Module with moduleName:" + moduleName + " doesn't exist.");
		}
	}


	// REFACTOR : temp function to reset state - needs refactor after scope stuff is removed from here.
	static public function disposeAll():void {
		for each(var module:ModuleCore in moduleRegistry) {
			module.disposeModule();
		}
		moduleRegistry = new Dictionary();
	}


	//----------------------------------
	//     DEBUG
	//----------------------------------

	/**
	 * Returns string with all module names.
	 * @return    string of all module names
	 */
	static public function listModules():String {
		var retVal:String = "";
		for each(var module:ModuleCore in moduleRegistry) {
			if (retVal != "") {
				retVal += ",";
			}
			retVal += module.moduleName;
		}
		return "Module list:" + retVal;
	}

	/**
	 * Lists messages for module name.
	 * @param moduleName    module name to debug
	 * @return
	 */
	static public function listMappedMessages(moduleName:String):String {
		if (moduleRegistry[moduleName]) {
			return (moduleRegistry[moduleName] as ModuleCore).listMappedMessages();
		} else {
			return "Module with name :" + moduleName + " is not found.";
		}
	}

	/**
	 * lists mapped mediator for module name
	 * @param moduleName    module name to debug
	 * @return
	 */
	static public function listMappedMediators(moduleName:String):String {
		if (moduleRegistry[moduleName]) {
			return (moduleRegistry[moduleName] as ModuleCore).listMappedMediators();
		} else {
			return "Module with name :" + moduleName + " is not found.";
		}
	}

	/**
	 * lists mapped proxies
	 * @param moduleName    module name to debug
	 * @return
	 */
	static public function listMappedProxies(moduleName:String):String {
		if (moduleRegistry[moduleName]) {
			return (moduleRegistry[moduleName] as ModuleCore).listMappedProxies();
		} else {
			return "Module with name :" + moduleName + " is not found.";
		}
	}

	/**
	 * lists mapped commands
	 * @param moduleName    module name to debug
	 * @return
	 */
	static public function listMappedCommands(moduleName:String):String {
		if (moduleRegistry[moduleName]) {
			return (moduleRegistry[moduleName] as ModuleCore).listMappedCommands();
		} else {
			return "Module with name :" + moduleName + " is not found.";
		}
	}

	/**
	 * EXPERIMENTAL
	 * Invokes custom module function.
	 * Experimental function for mvcLogger and extension development.
	 *
	 * @param moduleName    Name of module.
	 * @param functionName    name of the function
	 * @param params        optional function params
	 * @return        returns object.
	 * @private
	 */
	static pureLegsCore function invokeModuleFunction(moduleName:String, functionName:String, params:Array = null):Object {
		if (moduleRegistry[moduleName]) {
			try {
				var callFunct:Function = moduleRegistry[moduleName][functionName]
				if (params) {
					return callFunct();
				} else {
					return callFunct.apply(null, params);
				}
			} catch (error:Error) {
				return "Failed to invoke " + moduleName + " module function, named: " + functionName + ", with params:" + params + " " + error;
			}
			if (moduleRegistry[moduleName]["listMappedProcesses"] != null) {
				return moduleRegistry[moduleName]["listMappedProcesses"]();
			}
		}
		return "Module with name :" + moduleName + " is not found.";
	}

}
}


