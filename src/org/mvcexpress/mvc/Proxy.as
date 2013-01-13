// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.mvc {
import flash.utils.Dictionary;
import org.mvcexpress.MvcExpress;
import org.mvcexpress.core.ModuleManager;
import org.mvcexpress.core.interfaces.IProxyMap;
import org.mvcexpress.core.messenger.Messenger;
import org.mvcexpress.core.namespace.pureLegsCore;
import org.mvcexpress.core.ProcessMap;
import org.mvcexpress.core.traceObjects.MvcTraceActions;
import org.mvcexpress.core.traceObjects.proxy.TraceProxy_sendMessage;
import org.mvcexpress.core.traceObjects.proxy.TraceProxy_sendScopeMessage;

/**
 * Proxy holds and manages application data, provide API to work with it. 				</br>
 * Can send messages. (Usually sends one with each data update)						</br>
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class Proxy {
	
	/**
	 * Interface to work with proxies.
	 */
	protected var proxyMap:IProxyMap;
	
	// Shows if proxy is ready. Read only.
	private var _isReady:Boolean = false;
	
	// used internally for communication
	/** @private */
	pureLegsCore var messenger:Messenger;
	
	/////////////////
	// mvcExpressLive
	
	/** Used to provide stuff for processes. */
	private var processMap:ProcessMap;
	
	/**	all objects provided by this proxy */
	private var provideRegistry:Dictionary = new Dictionary(); /* of Object by String*/
	
	// mvcExpressLive
	/////////////////
	
	// for sending scoped messages then injected by scope.
	private var proxyScopes:Vector.<String> = new Vector.<String>();
	
	// for command classes that are dependant on this proxy.
	private var dependantCommands:Dictionary = new Dictionary();
	
	// amount of pending injections.
	/** @private */
	pureLegsCore var pendingInjections:int = 0;
	
	/** CONSTRUCTOR */
	public function Proxy() {
	}
	
	//----------------------------------
	//     Life cycle functions
	//----------------------------------
	
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
	 * @param	params	Object that will be passed to Command execute() function or to handle functions.
	 */
	protected function sendMessage(type:String, params:Object = null):void {
		use namespace pureLegsCore;
		// log the action
		CONFIG::debug {
			var moduleName:String = messenger.moduleName;
			MvcExpress.debug(new TraceProxy_sendMessage(moduleName, this, type, params, true));
		}
		//
		messenger.send(type, params);
		//
		for (var i:int = 0; i < proxyScopes.length; i++) {
			ModuleManager.sendScopeMessage(proxyScopes[i], type, params);
		}
		//
		// clean up logging the action
		CONFIG::debug {
			MvcExpress.debug(new TraceProxy_sendMessage(moduleName, this, type, params, false));
		}
	}
	
	/**
	 * Sends scoped module to module message, all modules that are listening to specified scopeName and message type will get it.
	 * @param	scopeName	both sending and receiving modules must use same scope to make module to module communication.
	 * @param	type		type of the message for Commands or Mediator's handle function to react to.
	 * @param	params		Object that will be passed to Command execute() function and to handle functions.
	 */
	protected function sendScopeMessage(scopeName:String, type:String, params:Object = null):void {
		use namespace pureLegsCore;
		// log the action
		CONFIG::debug {
			var moduleName:String = messenger.moduleName;
			MvcExpress.debug(new TraceProxy_sendScopeMessage(moduleName, this, type, params, true));
		}
		//
		ModuleManager.sendScopeMessage(scopeName, type, params);
		//
		// clean up logging the action
		CONFIG::debug {
			MvcExpress.debug(new TraceProxy_sendScopeMessage(moduleName, this, type, params, false));
		}
	}
	
	/////////////////
	// mvcExpressLive
	//----------------------------------
	//     mvcExpressLive functions
	//----------------------------------
	
	protected function provide(object:Object, name:String):void {
		processMap.provide(object, name);
		provideRegistry[name] = object;
	}
	
	protected function unprovide(object:Object, name:String):void {
		processMap.unprovide(object, name);
		delete provideRegistry[name];
	}
	
	protected function unprovideAll():void {
		for (var name:String in provideRegistry) {
			unprovide(provideRegistry[name], name);
		}
	}

	/**
	 * sets processMap interface.
	 * @param	iProcessMap
	 * @private
	 */
	pureLegsCore function setProcessMap(processMap:ProcessMap):void {
		this.processMap = processMap;
	}

	// mvcExpressLive
	/////////////////	

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
		dependantCommands = null;
		onRemove();
		/////////////////
		// mvcExpressLive		
		unprovideAll();
		/////////////////
	}
	
	//----------------------------------
	//     Scoping
	//----------------------------------
	
	/**
	 * Add scope for proxy to send all proxy messages to.
	 * @param	scopeName
	 * @private
	 */
	pureLegsCore function addScope(scopeName:String):void {
		var messengerFound:Boolean = false;
		for (var i:int = 0; i < proxyScopes.length; i++) {
			if (proxyScopes[i] == scopeName) {
				messengerFound = true;
				break;
			}
		}
		if (!messengerFound) {
			proxyScopes.push(scopeName);
		}
	}
	
	/**
	 * Remove scope for proxy to send all proxy messages to.
	 * @param	scopeName
	 * @private
	 */
	pureLegsCore function removeScope(scopeName:String):void {
		for (var i:int = 0; i < scopeName.length; i++) {
			if (proxyScopes[i] == scopeName) {
				proxyScopes.splice(i, 1);
				break;
			}
		}
	}
	
	//----------------------------------
	//     Pooled commands
	//----------------------------------
	
	// Registers command that needs this proxy. (used for PooledCommand's only)
	/** @private */
	pureLegsCore function registerDependantCommand(signatureClass:Class):void {
		// TODO : check if it is better to instantiate dictionary here.. (instead of default instantiation)
		dependantCommands[signatureClass] = signatureClass;
	}
	
	// gets the list of dependant commands. (used to clear all PooledCommand's then proxy is removed)
	/** @private */
	pureLegsCore function getDependantCommands():Dictionary {
		return dependantCommands;
	}
}
}