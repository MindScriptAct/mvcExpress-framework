// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core {
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import org.mvcexpress.base.CommandMap;
import org.mvcexpress.base.MediatorMap;
import org.mvcexpress.base.ProxyMap;
import org.mvcexpress.messenger.MessengerManager;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.messenger.MsgVO;
import org.mvcexpress.namespace.pureLegsCore;
import org.mvcexpress.base.FlexMediatorMap;

/**
 * Core class of framework as sprite.
 * <p>
 * It inits framework and lets you set up your application. (or execute Cammands that will do it.)
 * Also you can create modular application by having more then one Module.
 * </p>
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ModuleSprite extends Sprite {
	
	private var moduleName:String;
	
	protected var proxyMap:ProxyMap;
	
	protected var mediatorMap:MediatorMap;
	
	protected var commandMap:CommandMap;
	
	private var messenger:Messenger;
	
	private var _debugFunction:Function;
	
	/**
	 * CONSTRUCTOR
	 * @param	moduleName	module name that is used for referencing a module.
	 * @param	autoInit	if set to false framework is not initialized for this module. If you want to use framewokr features you will have to manualy init() it first. 
	 * 						(or you start getting null reference errors.)
	 */
	public function ModuleSprite(moduleName:String = null, autoInit:Boolean = true) {
		this.moduleName = moduleName;
		use namespace pureLegsCore;
		MessengerManager.increaseMessengerCount();
		if (!moduleName) {
			this.moduleName = "module" + (MessengerManager.messengerCount);
		}
		if (autoInit) {
			init();
		}
	}
	
	/**
	 * Initializes module. If this function is nat called module will not work.
	 * By default it is called in constructor.
	 */
	protected function init():void {
		use namespace pureLegsCore;
		messenger = MessengerManager.createMessenger(moduleName);
		
		proxyMap = new ProxyMap(messenger);
		// check if flex is used.
		var uiComponentClass:Class = getFlexClass();
		// if flex is used - special FlexMediatorMap Class is instantiated that wraps mediate() and unmediate() functions to handle flex 'creationComplete' isues.
		if (uiComponentClass) {
			mediatorMap = new FlexMediatorMap(messenger, proxyMap, uiComponentClass);
		} else {
			mediatorMap = new MediatorMap(messenger, proxyMap);
		}
		commandMap = new CommandMap(messenger, proxyMap, mediatorMap);
		
		onInit();
	}
	
	/**
	 * Function called after framework is initialized.
	 * Ment to be overriten.
	 */
	protected function onInit():void {
		// for override
	}
	
	/**
	 * Function to get rid of module.
	 *  All internals are disposed.
	 *  All mediators removed.
	 *  All proxies removed.
	 */
	public function dispose():void {
		onDispose();
		//
		use namespace pureLegsCore;
		//
		MessengerManager.disposeMessenger(moduleName);
		//
		commandMap.dispose();
		mediatorMap.dispose();
		proxyMap.dispose();
		//
		commandMap = null;
		mediatorMap = null;
		proxyMap = null;
		messenger = null;
	}
	
	/**
	 * Function called before module is destroed.
	 * Ment to be overriten.
	 */
	protected function onDispose():void {
		// for override
	}
	
	/**
	 * Message sender.
	 * @param	type	type of the message. (Commands and handle functions must bu map to it to react.)
	 * @param	params	Object that will be send to Command execute() or to handle function as parameter.
 	 * @param	targetModuleNames	array of module names as strings, by default [MessageTarget.SELF] is used.<\br>
	 * 									To target all existing modules use : [MessageTarget.ALL]
	 */
	protected function sendMessage(type:String, params:Object = null, targetModuleNames:Array = null):void {
		messenger.send(type, params, targetModuleNames);
	}
	
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
	 * Sets a debug function that will get all framework activity as string messages.
	 * WARNING : will work only with compile variable CONFIG:debug set to true.
	 * @param	debugFunction
	 */
	public function setDebugFunction(debugFunction:Function):void {
		this.debugFunction = debugFunction;
	}
	
	private function set debugFunction(value:Function):void {
		_debugFunction = value;
		use namespace pureLegsCore;
		proxyMap.setDebugFunction(_debugFunction);
		mediatorMap.setDebugFunction(_debugFunction);
		commandMap.setDebugFunction(_debugFunction);
		messenger.setDebugFunction(_debugFunction);
	}
	
	/**
	 * List all message mappings.
	 */
	public function listMappedMessages():String {
		return messenger.listMappings(commandMap);
	}
	
	/**
	 * List all view mappings.
	 */
	public function listMappedMediators():String {
		return mediatorMap.listMappings();
	}
	
	/**
	 * List all model mappings.
	 */
	public function listMappedProxies():String {
		return proxyMap.listMappings();
	}
	
	/**
	 * List all controller mappings.
	 */
	public function listMappedCommands():String {
		return commandMap.listMappings();
	}

}
}