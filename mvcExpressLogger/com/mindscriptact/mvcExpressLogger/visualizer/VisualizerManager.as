package com.mindscriptact.mvcExpressLogger.visualizer {
import com.mindscriptact.mvcExpressLogger.screens.MvcExpressVisualizerScreen;
import flash.utils.Dictionary;
import org.mvcexpress.core.CommandMap;
import org.mvcexpress.mvc.Command;
import org.mvcexpress.mvc.Mediator;
import org.mvcexpress.mvc.Proxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class VisualizerManager {
	
	private var mvcExpressVisualizerScreen:MvcExpressVisualizerScreen;
	
	private var moduleMediators:Dictionary = new Dictionary();
	private var moduleProxies:Dictionary = new Dictionary();
	private var currentModuleName:String;
	
	public function logMvcExpress(logObj:Object):void {
		var mediators:Vector.<Object>;
		var proxies:Vector.<Object>;
		var i:int;
		//trace("VisualizerManager.logMvcExpress > logObj : " + logObj);
		switch (logObj.action) {
			case "MediatorMap.mediate": 
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
			case "MediatorMap.unmediate": 
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
			case "ProxyMap.map": 
				proxies = getModuleProxies(logObj.moduleName);
				proxies.push(logObj);
				if (this.mvcExpressVisualizerScreen) {
					if (currentModuleName == logObj.moduleName) {
						this.mvcExpressVisualizerScreen.addProxy(logObj);
					}
				}
				break;
			case "ProxyMap.unmap": 
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
			case "ProxyMap.injectStuff": 
				var hostObject:Object = logObj.hostObject;
				var injectedObject:Object = logObj.injectObject;
				var a:Object = injectedObject as Proxy;
				if (injectedObject is Proxy) {
					if (hostObject is Mediator) {
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
					} else if (hostObject is Proxy) {
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
					} else if (hostObject is Command) {
						trace("hostObject : " + hostObject);
					} else {
						trace("!!!!!!!!!!!!ERROR!!!!!!!!!!!!! : fail to handle... ProxyMap.injectStuff object : " + hostObject);
					}
				}
				break;
			default: 
				throw Error("NOT HANDLED");
		}
	}
	
	public function manageThisScreen(currentModuleName:String, mvcExpressVisualizerScreen:MvcExpressVisualizerScreen):void {
		this.currentModuleName = currentModuleName;
		this.mvcExpressVisualizerScreen = mvcExpressVisualizerScreen;
		//
		this.mvcExpressVisualizerScreen.addProxies(moduleProxies[currentModuleName]);
		this.mvcExpressVisualizerScreen.addMediators(moduleMediators[currentModuleName]);
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