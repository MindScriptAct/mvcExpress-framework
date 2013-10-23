// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.mvc {
import flash.utils.Dictionary;

import mvcexpress.MvcExpress;
import mvcexpress.core.interfaces.IProxyMap;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.proxy.TraceProxy_sendMessage;
import mvcexpress.modules.ModuleCore;

use namespace pureLegsCore;

/**
 * Proxy holds and manages application data, implements API to work with it.                                                                               <p>
 * Can send messages strings. (to tell about data updates)                                                                                                 </p>
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version 2.0.rc1
 */
public class Proxy {

	/**
	 * Interface to work with proxies.
	 */
	protected var proxyMap:IProxyMap;

	// Shows if proxy is ready. Read only.
	private var _isReady:Boolean; // = false;

	/** used internally for communication
	 * @private */
	pureLegsCore var messenger:Messenger;

	// for pooled command classes that are dependant on this proxy.
	private var dependantCommands:Dictionary = new Dictionary();

	/** amount of pending injections.
	 * @private */
	pureLegsCore var pendingInjections:int; // = 0;

	/** CONSTRUCTOR */
	public function Proxy() {
	}


	//----------------------------------
	//     Life cycle functions
	//----------------------------------

	/**
	 * Then proxy is created, mapped with proxyMap, and all dependencies injected making proxy ready - this function is called.
	 */
	protected function onRegister():void {
		// for override
	}

	/**
	 * Then proxy is unmapped with proxyMap this function is called.
	 */
	protected function onRemove():void {
		// for override
	}

	/**
	 * Indicates if proxy is ready for usage. (all dependencies are injected.)
	 * Proxy will not be ready if it has pending, not resolved dependencies. (Pending injection feature must be turned on for that.)
	 */
	protected function get isReady():Boolean {
		return _isReady;
	}


	//----------------------------------
	//     MESSAGING
	//----------------------------------

	/**
	 * Sends a message with optional params object.
	 * @param    type    type of the message for Commands or Mediator's handle function to react to.
	 * @param    params    Object that will be passed to Command execute() function or to handle functions.
	 */
	protected function sendMessage(type:String, params:Object = null):void {
		use namespace pureLegsCore;

		var moduleName:String = messenger.moduleName;
		// log the action
		CONFIG::debug {
			MvcExpress.debug(new TraceProxy_sendMessage(moduleName, this, type, params, true));
		}
		//
		messenger.send(type, params);
		//

		//
		// clean up logging the action
		CONFIG::debug {
			MvcExpress.debug(new TraceProxy_sendMessage(moduleName, this, type, params, false));
		}
	}


	//----------------------------------
	//     INTERNAL
	//----------------------------------

	/**
	 * sets proxyMap interface.
	 * @param    iProxyMap
	 * @private
	 */
	pureLegsCore function setProxyMap(iProxyMap:IProxyMap):void {
		proxyMap = iProxyMap;
	}

	/**
	 * marks mediator as ready and calls onRegister()
	 * called from proxyMap
	 * @private
	 */
	pureLegsCore function register():void {
		if (!_isReady) {
			_isReady = true;
			onRegister();
		}
	}

	/**
	 * marks mediator as not ready and calls onRemove().
	 * called from proxyMap
	 * @private
	 */
	pureLegsCore function remove():void {
		_isReady = false;
		dependantCommands = null;
		onRemove();
	}

	//----------------------------------
	//     Pooled commands
	//----------------------------------

	/** Registers command that needs this proxy. (used for PooledCommand's only)
	 * @private */
	pureLegsCore function registerDependantCommand(signatureClass:Class):void {
		dependantCommands[signatureClass] = signatureClass;
	}

	/** gets the list of dependant commands. (used to clear all PooledCommand's then proxy is removed)
	 * @private */
	pureLegsCore function getDependantCommands():Dictionary {
		return dependantCommands;
	}


	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_id:int = ModuleCore.EXTENSION_CORE_ID;

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_name:String = ModuleCore.EXTENSION_CORE_NAME;
}
}