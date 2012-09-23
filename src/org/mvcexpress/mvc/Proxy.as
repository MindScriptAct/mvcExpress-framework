// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.mvc {
import org.mvcexpress.core.interfaces.IProxyMap;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.core.ModuleManager;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.TraceObj;
import org.mvcexpress.core.traceObjects.TraceProxy_sendMessage;
import org.mvcexpress.core.traceObjects.TraceProxy_sendScopeMessage;
import org.mvcexpress.MvcExpress;

/**
 * Proxy holds and manages application data, provide API to work with it. 				</br>
 * Can send messages. (Usually sends one with data update)								</br>
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class Proxy {
	
	/**
	 * Interface to work with proxies.
	 */
	protected var proxyMap:IProxyMap;
	
	// Shows if proxy is ready. Read only.
	private var _isReady:Boolean = false;
	
	// for comunication.
	/** @private */
	pureLegsCore var messenger:Messenger;
	
	/** @private */
	pureLegsCore var pendingInjections:int = 0;
	
	/** CONSTRUCTOR */
	public function Proxy() {
	}
	
	/**
	 * Then proxy is mapped with proxyMap this function is called.
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
	 */
	protected function get isReady():Boolean {
		return _isReady;
	}
	
	//----------------------------------
	//     MESSAGING
	//----------------------------------
	
	/**
	 * Sends a message with optional params object inside of current module.
	 * @param	type	type of the message for Commands or Mediator's handle function to react to.
	 * @param	params	Object that will be passed to Command execute() function and to handle functions.
	 */
	protected function sendMessage(type:String, params:Object = null):void {
		use namespace pureLegsCore;
		// log the action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceProxy_sendMessage(MvcTraceActions.PROXY_SENDMESSAGE, messenger.moduleName, this, type, params));
		}
		//
		messenger.send(type, params);
		//
		// clean up loging the action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceProxy_sendMessage(MvcTraceActions.PROXY_SENDMESSAGE_CLEAN, messenger.moduleName, this, type, params));
		}
	}
	
	/**
	 * DEPRICATED : Sends message to all existing modules. (Planned to be removed in 1.3)
	 * @param	type				message type to find needed handlers
	 * @param	params				parameter object that will be sent to all handler and execute functions as single parameter.
	 * @deprecated v1.1
	 */
	protected function sendMessageToAll(type:String, params:Object = null):void {
		use namespace pureLegsCore;
		messenger.sendToAll(type, params);
	}
	
	/**
	 * Sends scoped module to module message, all modules that are listening to specified scopeName and message type will get it.
	 * @param	type		type of the message for Commands or Mediator's handle function to react to.
	 * @param	params		Object that will be passed to Command execute() function and to handle functions.
	 * @param	scopeName	both sending and receiving modules must use same scope to make module to module comminication.
	 */
	protected function sendScopeMessage(type:String, params:Object = null, scopeName:String = "default"):void {
		use namespace pureLegsCore;
		// log the action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceProxy_sendScopeMessage(MvcTraceActions.PROXY_SENDSCOPEMESSAGE, messenger.moduleName, this, type, params));
		}
		//
		ModuleManager.sendScopeMessage(type, params, scopeName);
		//
		// clean up loging the action
		CONFIG::debug {
			use namespace pureLegsCore;
			MvcExpress.debug(new TraceProxy_sendScopeMessage(MvcTraceActions.PROXY_SENDSCOPEMESSAGE, messenger.moduleName, this, type, params));
		}
	}
	
	//----------------------------------
	//     INTERNAL
	//----------------------------------
	
	/**
	 * sets proxyMap interface.
	 * @param	iProxyMap
	 * @private
	 */
	pureLegsCore function setProxyMap(iProxyMap:IProxyMap):void {
		this.proxyMap = iProxyMap;
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
		onRemove();
	}

}
}