// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.scoped.mvc {
import mvcexpress.MvcExpress;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.proxy.TraceProxy_sendScopeMessage;
import mvcexpress.extensions.scoped.core.ScopeManager;
import mvcexpress.extensions.scoped.modules.ModuleScoped;
import mvcexpress.mvc.Proxy;

use namespace pureLegsCore;

/**
 * Proxy holds and manages application data, implements API to work with it.                  </br>
 * Can send constants. (Usually sends one with each data update)                            </br>
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version scoped.1.0.beta2
 */
public class ProxyScoped extends Proxy {


	// for sending scoped constants then injected by scope.
	private var proxyScopes:Vector.<String> = new Vector.<String>();


	//----------------------------------
	//     MESSAGING
	//----------------------------------

	/** @inheritDoc */
	override protected function sendMessage(type:String, params:Object = null):void {
		super.sendMessage(type, params);
		var scopeCount:int = proxyScopes.length;
		for (var i:int; i < scopeCount; i++) {
			ScopeManager.sendScopeMessage(messenger.moduleName, proxyScopes[i], type, params, false);
		}
	}

	/**
	 * Sends scoped module to module message, all modules that are listening to specified scopeName and message type will get it.
	 * @param    scopeName    both sending and receiving modules must use same scope to make module to module communication.
	 * @param    type        type of the message for Commands or Mediator's handle function to react to.
	 * @param    params        Object that will be passed to Command execute() function and to handle functions.
	 */
	protected function sendScopeMessage(scopeName:String, type:String, params:Object = null):void {
		use namespace pureLegsCore;

		var moduleName:String = messenger.moduleName;
		// log the action
		CONFIG::debug {
			MvcExpress.debug(new TraceProxy_sendScopeMessage(moduleName, this, type, params, true));
		}
		//
		ScopeManager.sendScopeMessage(moduleName, scopeName, type, params);
		//
		// clean up logging the action
		CONFIG::debug {
			MvcExpress.debug(new TraceProxy_sendScopeMessage(moduleName, this, type, params, false));
		}
	}


	//----------------------------------
	//     Scoping
	//----------------------------------

	/**
	 * Add scope for proxy to send all proxy constants to.
	 * @param    scopeName
	 * @private
	 */
	pureLegsCore function addScope(scopeName:String):void {
		var messengerFound:Boolean; // = false;
		var scopeCount:int = proxyScopes.length;
		for (var i:int; i < scopeCount; i++) {
			if (proxyScopes[i] == scopeName) {
				messengerFound = true;
				break;
			}
		}
		if (!messengerFound) {
			proxyScopes[proxyScopes.length] = scopeName;
		}
	}

	/**
	 * Remove scope for proxy to send all proxy constants to.
	 * @param    scopeName
	 * @private
	 */
	pureLegsCore function removeScope(scopeName:String):void {
		var scopeCount:int = scopeName.length;
		for (var i:int; i < scopeCount; i++) {
			if (proxyScopes[i] == scopeName) {
				proxyScopes.splice(i, 1);
				break;
			}
		}
	}


	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_id:int = ModuleScoped.EXTENSION_SCOPED_ID;

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_name:String = ModuleScoped.EXTENSION_SCOPED_NAME;
}
}