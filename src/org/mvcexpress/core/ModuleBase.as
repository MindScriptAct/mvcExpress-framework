// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core {
import flash.utils.getDefinitionByName;
import org.mvcexpress.core.CommandMap;
import org.mvcexpress.core.FlexMediatorMap;
import org.mvcexpress.core.MediatorMap;
import org.mvcexpress.core.ModuleManager;
import org.mvcexpress.core.ProxyMap;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.namespace.pureLegsCore;

/**
 * Internal framework class. Not meant to be constructed.
 * <p>
 * Provides base module functions for all other module classes.
 * </p>
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ModuleBase {
	
	// defines if class can be instantiated.
	static pureLegsCore var allowInstantiation:Boolean = false;
	
	private var _moduleName:String;
	
	public var proxyMap:ProxyMap;
	public var mediatorMap:MediatorMap;
	public var commandMap:CommandMap;
	private var messenger:Messenger;
	
	/**
	 * Internal framework class. Not meant to be constructed.
	 */
	public function ModuleBase(moduleName:String, autoInit:Boolean) {
		use namespace pureLegsCore;
		if (!allowInstantiation) {
			throw Error("ModuleBase is framework internal class and is not meant to be instantiated. Use ModuleCore, ModuleSprite or other module classes instead.");
		}
		//
		this._moduleName = moduleName;
		if (autoInit) {
			initModule();
		}
	}
	
	/**
	 * Internal framework function. Not meant to be used from outside.
	 */
	// Module creation function used instead of constructor.
	// @param	moduleName	module name that is used for referencing a module.
	// @param	autoInit	if set to false framework is not initialized for this module. If you want to use framework features you will have to manually init() it first.
	// 						(or you start getting null reference errors.)
	static public function getModuleInstance(moduleName:String, autoInit:Boolean):ModuleBase {
		var retVal:ModuleBase;
		use namespace pureLegsCore;
		ModuleBase.allowInstantiation = true;
		retVal = new ModuleBase(moduleName, autoInit);
		ModuleBase.allowInstantiation = false;
		return retVal;
	}
	
	/**
	 * Internal framework function. Not meant to be used from outside.
	 */
	// Initializes module. If this function is not called module will not work.
	// By default it is called in constructor.
	public function initModule():void {
		use namespace pureLegsCore;
		if (messenger) {
			throw Error("Module can be initiated only once.");
		}
		messenger = ModuleManager.createMessenger(_moduleName);
		
		proxyMap = new ProxyMap(_moduleName, messenger);
		// check if flex is used.
		var uiComponentClass:Class = getFlexClass();
		// if flex is used - special FlexMediatorMap Class is instantiated that wraps mediate() and unmediate() functions to handle flex 'creationComplete' issues.
		if (uiComponentClass) {
			mediatorMap = new FlexMediatorMap(_moduleName, messenger, proxyMap, uiComponentClass);
		} else {
			mediatorMap = new MediatorMap(_moduleName, messenger, proxyMap);
		}
		commandMap = new CommandMap(_moduleName, messenger, proxyMap, mediatorMap);
	}
	
	/**
	 * Internal framework function. Not meant to be used from outside.
	 */
	// Function to get rid of module.
	// - All module commands are unmapped.
	// - All module mediators are unmediated
	// - All module proxies are unmapped
	// - All internals are nulled.
	public function disposeModule():void {
		use namespace pureLegsCore;
		//
		commandMap.dispose();
		mediatorMap.dispose();
		proxyMap.dispose();
		
		commandMap = null;
		mediatorMap = null;
		proxyMap = null;
		messenger = null;
		//
		ModuleManager.disposeMessenger(_moduleName);
	}
	
	/**
	 * Internal framework function. Not meant to be used from outside.
	 */
	// Message sender.
	// @param	type	type of the message. (Commands and handle functions must bu map to it to react.)
	// @param	params	Object that will be send to Command execute() or to handle function as parameter.
	// @param	targetAllModules	if true, will send message to all existing modules, by default message will be internal for current module only.
	public function sendMessage(type:String, params:Object = null, targetAllModules:Boolean = false):void {
		messenger.send(type, params, targetAllModules);
	}
	
	public function get moduleName():String {
		return _moduleName;
	}
	
	//----------------------------------
	//     proxy hosting
	//----------------------------------
	
	public function hostProxy(classToHost:Class, name:String = ""):void {
		use namespace pureLegsCore;
		proxyMap.host(classToHost, name);
	}
	
	public function unhostProxy(classToHost:Class, name:String = ""):void {
		use namespace pureLegsCore;
		proxyMap.unhost(classToHost, name);
	}
	
	//----------------------------------
	//     utils
	//----------------------------------	
	
	/** get flex lowest class by definition. ( way to check for flex project.) */
	protected static function getFlexClass():Class {
		var uiComponentClass:Class;
		try {
			uiComponentClass = getDefinitionByName('mx.core::UIComponent') as Class;
		} catch (error:Error) {
			// do nothing
		}
		return uiComponentClass;
	}
	
	//----------------------------------
	//     Debug
	//----------------------------------
	
	/**
	 * Internal framework function. Not meant to be used from outside.
	 */
	// List all message mappings.
	public function listMappedMessages():String {
		return messenger.listMappings(commandMap);
	}
	
	/**
	 * Internal framework function. Not meant to be used from outside.
	 */
	// List all view mappings.
	public function listMappedMediators():String {
		return mediatorMap.listMappings();
	}
	
	/**
	 * Internal framework function. Not meant to be used from outside.
	 */
	// List all model mappings.
	public function listMappedProxies():String {
		return proxyMap.listMappings();
	}
	
	/**
	 * Internal framework function. Not meant to be used from outside.
	 */
	// List all controller mappings.
	public function listMappedCommands():String {
		return commandMap.listMappings();
	}

}
}