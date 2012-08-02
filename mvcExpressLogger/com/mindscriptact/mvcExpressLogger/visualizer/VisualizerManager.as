package com.mindscriptact.mvcExpressLogger.visualizer {
import com.mindscriptact.mvcExpressLogger.screens.MvcExpressVisualizerScreen;
import flash.utils.Dictionary;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class VisualizerManager {
	
	private var mvcExpressVisualizerScreen:MvcExpressVisualizerScreen;
	
	private var moduleMediators:Dictionary = new Dictionary();
	private var moduleProxies:Dictionary = new Dictionary();
	
	public function logMvcExpress(logObj:Object):void {
		var mediators:Vector.<Object>;
		var proxies:Vector.<Object>;
		var i:int;
		//trace("VisualizerManager.logMvcExpress > logObj : " + logObj);
		switch (logObj.action) {
			case "MediatorMap.mediate": 
				mediators = moduleMediators[logObj.moduleName];
				if (!mediators) {
					moduleMediators[logObj.moduleName] = new Vector.<Object>();
					mediators = moduleMediators[logObj.moduleName];
				}
				mediators.push(logObj);
				//mediatorClass = com.mindScriptAct.mvcExpressVisualizer.view.VisualLoggerTestModuleMediator$)
				//viewClass = com.mindScriptAct.mvcExpressVisualizer.VisualLoggerTestModule$)
				//viewObject = com.mindScriptAct.mvcExpressVisualizer.VisualLoggerTestModule (@5845f91)
				if (this.mvcExpressVisualizerScreen) {
					this.mvcExpressVisualizerScreen.addMediator(logObj);
				}
				break;
			case "MediatorMap.unmediate": 
				mediators = moduleMediators[logObj.moduleName];
				if (!mediators) {
					moduleMediators[logObj.moduleName] = new Vector.<Object>();
					mediators = moduleMediators[logObj.moduleName];
				}
				for (i = 0; i < mediators.length; i++) {
					if (mediators[i].viewObject == logObj.viewObject) {
						if (this.mvcExpressVisualizerScreen) {
							this.mvcExpressVisualizerScreen.removeMediatorFromPossition(i);
						}
						mediators.splice(i, 1);
						break;
					}
				}
			case "ProxyMap.map": 
				proxies = moduleProxies[logObj.moduleName];
				if (!proxies) {
					moduleProxies[logObj.moduleName] = new Vector.<Object>();
					proxies = moduleProxies[logObj.moduleName];
				}
				proxies.push(logObj);
				if (this.mvcExpressVisualizerScreen) {
					this.mvcExpressVisualizerScreen.addProxy(logObj);
				}
				break;
			case "ProxyMap.unmap": 
				proxies = moduleProxies[logObj.moduleName];
				if (!proxies) {
					moduleProxies[logObj.moduleName] = new Vector.<Object>();
					proxies = moduleProxies[logObj.moduleName];
				}
				for (i = 0; i < proxies.length; i++) {
					if (proxies[i].injectClass == logObj.injectClass && proxies[i].name == logObj.name ) {
						if (this.mvcExpressVisualizerScreen) {
							this.mvcExpressVisualizerScreen.removeProxyFromPossition(i);
						}
						proxies.splice(i, 1);
						break;
					}
				}
				break;
			default: 
				throw Error("NOT HANDLED");
		}
	}
	
	public function manageThisScreen(moduleName:String, mvcExpressVisualizerScreen:MvcExpressVisualizerScreen):void {
		this.mvcExpressVisualizerScreen = mvcExpressVisualizerScreen;
		//
		this.mvcExpressVisualizerScreen.addMediators(moduleMediators[moduleName]);
		this.mvcExpressVisualizerScreen.addProxies(moduleProxies[moduleName]);
	}
	
	public function manageNothing():void {
		this.mvcExpressVisualizerScreen = null;
	}

}
}