package com.mindscriptact.mvcExpressLogger.visualizer {
import com.mindscriptact.mvcExpressLogger.screens.MvcExpressVisualizerScreen;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import org.mvcexpress.core.namespace.pureLegsCore;
//import org.mvcexpress.core.traceObjects.MvcTraceActions;
//import org.mvcexpress.mvc.Command;
//import org.mvcexpress.mvc.Mediator;
//import org.mvcexpress.mvc.Proxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class VisualizerManager {
	
	private var mvcExpressVisualizerScreen:MvcExpressVisualizerScreen;
	
	private var moduleMediators:Dictionary = new Dictionary();
	private var moduleProxies:Dictionary = new Dictionary();
	private var currentModuleName:String;
	private var sendMessageStack:Vector.<Object> = new Vector.<Object>();
	
	static private var commandClass:Class;
	static private var mediatorClass:Class;
	static private var proxyClass:Class;
	static private var processClass:Class;
	
	public function VisualizerManager() {
		if (!VisualizerManager.commandClass) {
			try {
				VisualizerManager.commandClass = getDefinitionByName("org.mvcexpress.mvc::Command") as Class;
			} catch (error:Error) {
				VisualizerManager.commandClass = null;
			}
		}
		if (!VisualizerManager.mediatorClass) {
			try {
				VisualizerManager.mediatorClass = getDefinitionByName("org.mvcexpress.mvc::Mediator") as Class;
			} catch (error:Error) {
				VisualizerManager.mediatorClass = null;
			}
		}
		if (!VisualizerManager.proxyClass) {
			try {
				VisualizerManager.proxyClass = getDefinitionByName("org.mvcexpress.mvc::Proxy") as Class;
			} catch (error:Error) {
				VisualizerManager.proxyClass = null;
			}
		}
		if (!VisualizerManager.processClass) {
			try {
				VisualizerManager.processClass = getDefinitionByName("org.mvcexpress.live::Process") as Class;
			} catch (error:Error) {
				VisualizerManager.processClass = null;
			}
		}
	
	}
	
	public function logMvcExpress(logObj:Object):void {
		use namespace pureLegsCore;
		var topObject:Object;
		var mediators:Vector.<Object>;
		var proxies:Vector.<Object>;
		var i:int;
		//trace("VisualizerManager.logMvcExpress > logObj : " + logObj);
		switch (logObj.action) {
			case "MediatorMap.mediate"://MvcTraceActions.MEDIATORMAP_MEDIATE: 
				mediators = getModuleMediators(logObj.moduleName);
				mediators.push(logObj);
				//mediatorClass = com.mindScriptAct.mvcExpressVisualizer.view.VisualLoggerTestModuleMediator$)
				//viewClass = com.mindScriptAct.mvcExpressVisualizer.VisualLoggerTestModule$)
				//viewObject = com.mindScriptAct.mvcExpressVisualizer.VisualLoggerTestModule (@5845f91)
				if (this.mvcExpressVisualizerScreen) {
					if (currentModuleName == logObj.moduleName) {
						this.mvcExpressVisualizerScreen.addMediator(logObj);
					}
				}
				break;
			case "MediatorMap.unmediate"://MvcTraceActions.MEDIATORMAP_UNMEDIATE: 
				mediators = getModuleMediators(logObj.moduleName);
				for (i = 0; i < mediators.length; i++) {
					if (mediators[i].viewObject == logObj.viewObject) {
						if (this.mvcExpressVisualizerScreen) {
							if (currentModuleName == logObj.moduleName) {
								this.mvcExpressVisualizerScreen.removeMediatorFromPossition(i);
							}
						}
						mediators.splice(i, 1);
						break;
					}
				}
				break;
			case "ProxyMap.map"://MvcTraceActions.PROXYMAP_MAP: 
				proxies = getModuleProxies(logObj.moduleName);
				proxies.push(logObj);
				if (this.mvcExpressVisualizerScreen) {
					if (currentModuleName == logObj.moduleName) {
						this.mvcExpressVisualizerScreen.addProxy(logObj);
					}
				}
				break;
			case "ProxyMap.unmap"://MvcTraceActions.PROXYMAP_UNMAP: 
				proxies = getModuleProxies(logObj.moduleName);
				for (i = 0; i < proxies.length; i++) {
					if (proxies[i].injectClass == logObj.injectClass && proxies[i].name == logObj.name) {
						if (this.mvcExpressVisualizerScreen) {
							if (currentModuleName == logObj.moduleName) {
								this.mvcExpressVisualizerScreen.removeProxyFromPossition(i);
							}
						}
						proxies.splice(i, 1);
						break;
					}
				}
				break;
			case "ProxyMap.injectStuff"://MvcTraceActions.PROXYMAP_INJECTSTUFF: 
				var hostObject:Object = logObj.hostObject;
				var injectedObject:Object = logObj.injectObject;
				var a:Object = injectedObject as VisualizerManager.proxyClass;
				if (injectedObject is VisualizerManager.proxyClass) {
					if (hostObject is VisualizerManager.mediatorClass) {
						// find mediator
						var mediatorObject:Object;
						mediators = getModuleMediators(logObj.moduleName);
						for (var j:int = 0; j < mediators.length; j++) {
							if (mediators[j].mediatorObject == hostObject) {
								mediatorObject = mediators[j];
								break;
							}
						}
						if (mediatorObject) {
							if (!mediatorObject.dependencies) {
								mediatorObject.dependencies = new Vector.<Object>();
							}
							mediatorObject.dependencies.push(injectedObject);
							// show dependency
							if (this.mvcExpressVisualizerScreen) {
								if (currentModuleName == logObj.moduleName) {
									this.mvcExpressVisualizerScreen.drawMediatorDependency(mediatorObject, injectedObject);
								}
							}
						}
					} else if (hostObject is VisualizerManager.proxyClass) {
						// find proxy
						var proxyObject:Object;
						proxies = getModuleProxies(logObj.moduleName);
						for (var p:int = 0; j < proxies.length; p++) {
							if (proxies[p].proxyObject == hostObject) {
								proxyObject = proxies[p];
								break;
							}
						}
						if (proxyObject) {
							if (!proxyObject.dependencies) {
								proxyObject.dependencies = new Vector.<Object>();
							}
							proxyObject.dependencies.push(injectedObject);
							// show dependency
							if (this.mvcExpressVisualizerScreen) {
								if (currentModuleName == logObj.moduleName) {
									this.mvcExpressVisualizerScreen.drawProxyDependency(proxyObject, injectedObject);
								}
							}
						}
					} else if (hostObject is VisualizerManager.commandClass) {
						if (this.mvcExpressVisualizerScreen) {
							if (currentModuleName == logObj.moduleName) {
								this.mvcExpressVisualizerScreen.drawCommandDependency(hostObject, injectedObject);
							}
						}
					} else if (hostObject is VisualizerManager.processClass) {
						// DOIT: visualise injection into process...
					} else {
						trace("!!!!!!!!!!!!ERROR!!!!!!!!!!!!! : fail to handle... ProxyMap.injectStuff object : " + hostObject);
					}
				}
				break;
			case "CommandMap.execute"://MvcTraceActions.COMMANDMAP_EXECUTE: 
			case "CommandMap.handleCommandExecute"://MvcTraceActions.COMMANDMAP_HANDLECOMMANDEXECUTE: 
				if (this.mvcExpressVisualizerScreen) {
					if (currentModuleName == logObj.moduleName) {
						if (sendMessageStack.length) {
							topObject = sendMessageStack[sendMessageStack.length - 1];
							if (topObject.moduleName == logObj.moduleName && topObject.type == logObj.type && topObject.params == logObj.params) {
								if (topObject.moduleObject) {
									logObj.messageFromModule = topObject.moduleObject;
								} else if (topObject.mediatorObject) {
									logObj.messageFromMediator = topObject.mediatorObject;
								} else if (topObject.proxyObject) {
									logObj.messageFromProxy = topObject.proxyObject;
								} else if (topObject.commandObject) {
									logObj.messageFromCommand = topObject.commandObject;
								} else {
									CONFIG::debug {
										//throw Error("NOT HANDLED:" + logObj);
									}
								}
							}
						}
						this.mvcExpressVisualizerScreen.addCommand(logObj);
					}
				}
				break;
			case "Mediator.addHandler"://MvcTraceActions.MEDIATOR_ADDHANDLER: 
				// add handler to mediator
				mediators = getModuleMediators(logObj.moduleName);
				for (var k:int = 0; k < mediators.length; k++) {
					if (mediators[k].mediatorObject == logObj.mediatorObject) {
						if (!mediators[k].handleObjects) {
							mediators[k].handleObjects = new Vector.<Object>();
						}
						mediators[k].handleObjects.push(logObj);
					}
				}
				break;
			case "ModuleBase.sendMessage": //MvcTraceActions.MODULEBASE_SENDMESSAGE: 
			case "ModuleBase.sendScopeMessage": //MvcTraceActions.MODULEBASE_SENDSCOPEMESSAGE: 
			case "Mediator.sendMessage": //MvcTraceActions.MEDIATOR_SENDMESSAGE: 
			case "Mediator.sendScopeMessage": //MvcTraceActions.MEDIATOR_SENDSCOPEMESSAGE: 
			case "Proxy.sendMessage": //MvcTraceActions.PROXY_SENDMESSAGE: 
			case "Proxy.sendScopeMessage": //MvcTraceActions.PROXY_SENDSCOPEMESSAGE: 
			case "Command.sendMessage": //MvcTraceActions.COMMAND_SENDMESSAGE: 
			case "Command.sendScopeMessage": //MvcTraceActions.COMMAND_SENDSCOPEMESSAGE: 
			case "Process.runProcess.instantSendMessage": //MvcTraceActions.PROCESS_INSTANT_SENDMESSAGE: 
			case "Process.runProcess.postSendMessage": //MvcTraceActions.PROCESS_POST_SENDMESSAGE: 
			case "Process.runProcess.finalSendMessage": //MvcTraceActions.PROCESS_FINAL_SENDMESSAGE: 
				sendMessageStack.push(logObj);
				break;
			case "ModuleBase.sendMessage.CLEAN": //MvcTraceActions.MODULEBASE_SENDMESSAGE_CLEAN: 
			case "ModuleBase.sendScopeMessage.CLEAN": //MvcTraceActions.MODULEBASE_SENDSCOPEMESSAGE_CLEAN: 
			case "Mediator.sendMessage.CLEAN": //MvcTraceActions.MEDIATOR_SENDMESSAGE_CLEAN: 
			case "Mediator.sendScopeMessage.CLEAN": //MvcTraceActions.MEDIATOR_SENDSCOPEMESSAGE_CLEAN: 
			case "Proxy.sendMessage.CLEAN": //MvcTraceActions.PROXY_SENDMESSAGE_CLEAN: 
			case "Proxy.sendScopeMessage.CLEAN": //MvcTraceActions.PROXY_SENDSCOPEMESSAGE_CLEAN: 
			case "Command.sendMessage.CLEAN": //MvcTraceActions.COMMAND_SENDMESSAGE_CLEAN: 
			case "Command.sendScopeMessage.CLEAN": //MvcTraceActions.COMMAND_SENDSCOPEMESSAGE_CLEAN: 
			case "Process.runProcess.instantSendMessage.CLEAN": //MvcTraceActions.PROCESS_INSTANT_SENDMESSAGE_CLEAN: 
			case "Process.runProcess.postSendMessage.CLEAN": //MvcTraceActions.PROCESS_POST_SENDMESSAGE_CLEAN: 
			case "Process.runProcess.finalSendMessage.CLEAN": //MvcTraceActions.PROCESS_FINAL_SENDMESSAGE_CLEAN: 
				topObject = sendMessageStack.pop();
				if (logObj.type != topObject.type) {
					CONFIG::debug {
						//throw Error("NOT HANDLED:" + logObj);
					}
				} else {
					if (logObj.params != topObject.params) {
						CONFIG::debug {
							//throw Error("NOT HANDLED:" + logObj);
						}
					}
				}
				break;
			case "Messenger.send": //MvcTraceActions.MESSENGER_SEND: 
				topObject = sendMessageStack[sendMessageStack.length - 1];
				if (topObject) {
					if (logObj.type == topObject.type) {
						if (logObj.params == topObject.params) {
							if (topObject.moduleName == null) {
								topObject.moduleName = logObj.moduleName;
							} else {
								if (topObject.moduleName == logObj.moduleName) {
									// ALL IS GOOD...
								} else {
									CONFIG::debug {
										//throw Error("NOT HANDLED:" + logObj);
									}
								}
							}
						} else {
							CONFIG::debug {
								//throw Error("NOT HANDLED:" + logObj);
							}
						}
					} else {
						CONFIG::debug {
							//throw Error("NOT HANDLED:" + logObj);
						}
					}
				} else {
					CONFIG::debug {
						//throw Error("NOT HANDLED:" + logObj);
					}
				}
				break;
			case "Messenger.send.HANDLER": //MvcTraceActions.MESSENGER_SEND_HANDLER: 
				if (mvcExpressVisualizerScreen) {
					if (currentModuleName == logObj.moduleName) {
						//
						topObject = sendMessageStack[sendMessageStack.length - 1];
						if (topObject) {
							if (logObj.type == topObject.type) {
								if (logObj.params == topObject.params) {
									if (topObject.moduleName == logObj.moduleName) {
										// ALL IS GOOD...
										// find mediator with handler function.
										mediators = getModuleMediators(logObj.moduleName);
										for (var l:int = 0; l < mediators.length; l++) {
											if (mediators[l].mediatorClassName == logObj.handlerClassName) {
												var handlerObjects:Vector.<Object> = mediators[l].handleObjects;
												if (handlerObjects) {
													for (var m:int = 0; m < handlerObjects.length; m++) {
														if (handlerObjects[m].handler == logObj.handler) {
															if (topObject.moduleName == logObj.moduleName && topObject.type == logObj.type && topObject.params == logObj.params) {
																// remember there message comes from.
																if (topObject.moduleObject) {
																	logObj.messageFromModule = topObject.moduleObject;
																} else if (topObject.mediatorObject) {
																	logObj.messageFromMediator = topObject.mediatorObject;
																} else if (topObject.proxyObject) {
																	logObj.messageFromProxy = topObject.proxyObject;
																} else if (topObject.commandObject) {
																	logObj.messageFromCommand = topObject.commandObject;
																} else {
																	CONFIG::debug {
																		//throw Error("NOT HANDLED:" + logObj);
																	}
																}
																this.mvcExpressVisualizerScreen.drawMessageToMediator(logObj, l);
															}
														}
													}
												}
											}
										}
									} else {
										CONFIG::debug {
											//throw Error("NOT HANDLED:" + logObj);
										}
									}
								} else {
									CONFIG::debug {
										//throw Error("NOT HANDLED:" + logObj);
									}
								}
							} else {
								CONFIG::debug {
									//throw Error("NOT HANDLED:" + logObj);
								}
							}
						} else {
							CONFIG::debug {
								//throw Error("NOT HANDLED:" + logObj);
							}
						}
					}
				}
				break;
			default: 
				CONFIG::debug {
					//throw Error("NOT HANDLED:" + logObj);
			}
				break;
		}
	}
	
	public function manageThisScreen(currentModuleName:String, mvcExpressVisualizerScreen:MvcExpressVisualizerScreen):void {
		this.currentModuleName = currentModuleName;
		if (mvcExpressVisualizerScreen) {
			this.mvcExpressVisualizerScreen = mvcExpressVisualizerScreen;
			//
			if (currentModuleName != "") {
				this.mvcExpressVisualizerScreen.showModule(currentModuleName);
				this.mvcExpressVisualizerScreen.addProxies(moduleProxies[currentModuleName]);
				this.mvcExpressVisualizerScreen.addMediators(moduleMediators[currentModuleName]);
				this.mvcExpressVisualizerScreen.clearCommands();
			}
		}
	}
	
	public function manageNothing():void {
		this.mvcExpressVisualizerScreen = null;
	}
	
	private function getModuleMediators(moduleName:String):Vector.<Object> {
		if (!moduleMediators[moduleName]) {
			moduleMediators[moduleName] = new Vector.<Object>();
		}
		return moduleMediators[moduleName];
	}
	
	private function getModuleProxies(moduleName:String):Vector.<Object> {
		if (!moduleProxies[moduleName]) {
			moduleProxies[moduleName] = new Vector.<Object>();
		}
		return moduleProxies[moduleName];
	}

}
}