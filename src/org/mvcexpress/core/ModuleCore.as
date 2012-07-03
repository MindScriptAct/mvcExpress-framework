// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core {
import flash.display.DisplayObjectContainer;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import org.mvcexpress.base.CommandMap;
import org.mvcexpress.base.MediatorMap;
import org.mvcexpress.base.ProxyMap;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.messenger.MsgVO;
import org.mvcexpress.namespace.pureLegsCore;
import org.mvcexpress.base.FlexMediatorMap;

/**
 * Core class of framework.
 * <p>
 * It inits framework and lets you set up your application. (or execute Cammands that will do it.)
 * Also you can create modular application by having more then one CoreModule subclass.
 * </p>
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ModuleCore {
	
	protected var proxyMap:ProxyMap;
	
	protected var mediatorMap:MediatorMap;
	
	protected var commandMap:CommandMap;
	
	private var messenger:Messenger;
	
	/** @private */
	pureLegsCore var messageDataRegistry:Vector.<MsgVO> = new Vector.<MsgVO>();
	
	private var _debugFunction:Function;
	
	/**
	 * CONSTRUCTOR
	 * @param	mainObject	main object of your application. Should be set once with main module if you have more then one.
	 */
	public function ModuleCore() {
		use namespace pureLegsCore;
		messenger = Messenger.getInstance();
		
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
		removeAllHandlers();
		//
		messenger.removeCommandHandlers(commandMap);
		//
		commandMap.dispose();
		mediatorMap.dispose();
		proxyMap.dispose();
		
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
	 */
	protected function sendMessage(type:String, params:Object = null):void {
		messenger.send(type, params);
	}
	
	/**
	 * adds handle function to be called then messege of provided type is sent.
	 * @param	type	message type for handle function to reoct to.
	 * @param	handler	function that will be called then needed message is sent. this functino must expect one parameter. (you can set your custom type for this param object, or leave it as Object)
	 */
	protected function addHandler(type:String, handler:Function):void {
		use namespace pureLegsCore;
		CONFIG::debug {
			if (handler.length < 1) {
				throw Error("Every message handler function needs at least one parameter. You are trying to add handler function from " + getQualifiedClassName(this) + " for message type:" + type);
			}
			if (!Boolean(type) || type == "null" || type == "undefined") {
				throw Error("Message type:[" + type + "] can not be empty or 'null'.(You are trying to add message handler in: " + this + ")");
			}
			messageDataRegistry.push(messenger.addHandler(type, handler, null, getQualifiedClassName(this)));
			return;
		}
		messageDataRegistry.push(messenger.addHandler(type, handler));
	}
	
	/**
	 * Removes handle function from messege of provided type.
	 * @param	type	message type that was set for handle function to react to. 
	 * @param	handler	function that was set to react to message.
	 */
	protected function removeHandler(type:String, handler:Function):void {
		use namespace pureLegsCore;
		messenger.removeHandler(type, handler);
	}
	
	/**
	 * Remove all handle functions created by this module. (autamaticaly called with dispose() )
	 */
	protected function removeAllHandlers():void {
		use namespace pureLegsCore;
		while ( messageDataRegistry.length) {
			messageDataRegistry.pop().disabled = true;
		}
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