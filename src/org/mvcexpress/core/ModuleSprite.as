// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core {
import flash.display.Sprite;
import org.mvcexpress.base.CommandMap;
import org.mvcexpress.base.MediatorMap;
import org.mvcexpress.base.ProxyMap;

/**
 * Core class of framework as sprite.
 * <p>
 * It inits framework and lets you set up your application. (or execute Cammands that will do it.)
 * Also you can create modular application by having more then one Module.
 * </p>
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ModuleSprite extends Sprite {
	
	private var moduleBase:ModuleBase;
	
	protected var proxyMap:ProxyMap;
	
	protected var mediatorMap:MediatorMap;
	
	protected var commandMap:CommandMap;
	
	/**
	 * CONSTRUCTOR
	 * @param	moduleName	module name that is used for referencing a module.
	 * @param	autoInit	if set to false framework is not initialized for this module. If you want to use framewokr features you will have to manualy init() it first.
	 * 						(or you start getting null reference errors.)
	 */
	public function ModuleSprite(moduleName:String = null, autoInit:Boolean = true) {
		moduleBase = ModuleBase.getModuleInstance(moduleName, autoInit);
		//
		proxyMap = moduleBase.proxyMap;
		mediatorMap = moduleBase.mediatorMap;
		commandMap = moduleBase.commandMap;
		//
		if (autoInit) {
			onInit();
		}
	}
	
	/**
	 * Name of the module
	 */
	public function get moduleName():String {
		return moduleBase.moduleName;
	}
	
	/**
	 * Initializes module. If this function is not called module will not work.
	 * By default it is called in constructor.
	 */
	protected function initModule():void {
		moduleBase.initModule();
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
	 * - All module cammands are unmaped.
	 * - All module mediators are unmediated
	 * - All module proxies are unmaped
	 * - All internals are nulled.
	 */
	public function disposeModule():void {
		onDispose();
		moduleBase.disposeModule();
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
		moduleBase.sendMessage(type, params, targetModuleNames);
	}
	
	//----------------------------------
	//     Debug
	//----------------------------------
	
	/**
	 * List all message mappings.
	 */
	public function listMappedMessages():String {
		return moduleBase.listMappedMessages();
	}
	
	/**
	 * List all view mappings.
	 */
	public function listMappedMediators():String {
		return moduleBase.listMappedMessages();
	}
	
	/**
	 * List all model mappings.
	 */
	public function listMappedProxies():String {
		return moduleBase.listMappedProxies();
	}
	
	/**
	 * List all controller mappings.
	 */
	public function listMappedCommands():String {
		return moduleBase.listMappedCommands();
	}

}
}