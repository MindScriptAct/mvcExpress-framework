package com.mindscriptact.mvcExpressLogger.screens {
import com.bit101.components.Label;
import flash.display.Sprite;
import flash.utils.getQualifiedClassName;
import flash.utils.setTimeout;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class MvcExpressVisualizerScreen extends Sprite {
	private var screenWidth:int;
	private var screenHeight:int;
	private var mediators:Vector.<Object>;
	private var proxies:Vector.<Object>;
	private var commands:Vector.<Object> = new Vector.<Object>();
	
	public function MvcExpressVisualizerScreen(screenWidth:int, screenHeight:int) {
		this.screenWidth = screenWidth;
		this.screenHeight = screenHeight;
		
		this.graphics.lineStyle(0.1, 0x393939);
		this.graphics.moveTo(0, 0);
		this.graphics.lineTo(1500, 0);
		this.graphics.lineStyle(0.1, 0x494949);
		this.graphics.moveTo(0, 1);
		this.graphics.lineTo(1500, 1);
	}
	
	public function updateProxies(listMappedProxies:String):void {
		trace("MvcExpressVisualizerScreen.updateProxies > listMappedProxies : " + listMappedProxies);
	}
	
	//----------------------------------
	//     mediators
	//----------------------------------
	
	public function addMediators(mediators:Vector.<Object>):void {
		// remove old mediators
		if (this.mediators) {
			for (var k:int = 0; k < this.mediators.length; k++) {
				if (this.mediators[k].view) {
					if (this.contains(this.mediators[k].view)) {
						this.removeChild(this.mediators[k].view);
					}
				}
			}
		}
		//
		if (mediators) {
			this.mediators = mediators;
			//trace("MvcExpressVisualizerScreen.addMediators > mediators : " + mediators);
			for (var i:int = 0; i < mediators.length; i++) {
				addMediator(mediators[i]);
			}
			for (var j:int = 0; j < mediators.length; j++) {
				mediators[j].view.y = j * 20 + 50;
				redrawMediatorDependencies(mediators[j]);
			}
		}
	}
	
	public function addMediator(mediatorLogObj:Object):void {
		var mediatorLabel:Label;
		if (mediatorLogObj.view == null) {
			mediatorLogObj.view = new Label(null, 5, 0, mediatorLogObj.viewObject.name + "-" + mediatorLogObj.mediatorClass);
			(mediatorLogObj.view as Label).textField.borderColor = 0x00AA00;
			(mediatorLogObj.view as Label).textField.border = true;
		}
		mediatorLabel = mediatorLogObj.view;
		//
		mediatorLabel.x = 300 - mediatorLabel.width;
		mediatorLabel.y = (mediators.length - 1) * 20 + 50;
		this.addChild(mediatorLabel);
	}
	
	public function removeMediatorFromPossition(possition:int):void {
		if (mediators[possition] && this.contains(mediators[possition].view)) {
			this.removeChild(mediators[possition].view);
		}
		for (var i:int = possition + 1; i < mediators.length; i++) {
			mediators[i].view.y = (i - 1) * 20 + 50;
			redrawMediatorDependencies(mediators[i]);
		}
	}
	
	private function redrawMediatorDependencies(mediatorObject:Object):void {
		var dependencies:Vector.<Object> = mediatorObject.dependencies
		if (dependencies) {
			mediatorObject.view.graphics.clear();
			for (var i:int = 0; i < dependencies.length; i++) {
				drawMediatorDependency(mediatorObject, dependencies[i]);
			}
		}
	}
	
	public function drawMediatorDependency(mediatorObject:Object, injectedObject:Object):void {
		for (var i:int = 0; i < proxies.length; i++) {
			if (proxies[i].proxyObject == injectedObject) {
				var mediatorLabel:Label = (mediatorObject.view as Label);
				mediatorLabel.graphics.lineStyle(1, 0xFF8000, 0.5);
				mediatorLabel.graphics.moveTo(mediatorLabel.width, 5);
				mediatorLabel.graphics.lineTo(proxies[i].view.x - mediatorLabel.x, proxies[i].view.y - mediatorLabel.y + 5);
				mediatorLabel.graphics.moveTo(mediatorLabel.width, 5);
				mediatorLabel.graphics.lineTo(mediatorLabel.width + 5, 5 - 2);
				mediatorLabel.graphics.moveTo(mediatorLabel.width, 5);
				mediatorLabel.graphics.lineTo(mediatorLabel.width + 5, 5 + 2);
			}
		}
	}
	
	//----------------------------------
	//     proxies
	//----------------------------------
	
	public function addProxies(proxies:Vector.<Object>):void {
		// remove old proxies
		if (this.proxies) {
			for (var k:int = 0; k < this.proxies.length; k++) {
				if (this.contains(this.proxies[k].view)) {
					this.removeChild(this.proxies[k].view);
				}
			}
		}
		//
		if (proxies) {
			this.proxies = proxies;
		}
		for (var i:int = 0; i < proxies.length; i++) {
			addProxy(proxies[i]);
		}
		for (var j:int = 0; j < proxies.length; j++) {
			proxies[j].view.y = j * 20 + 50;
			redrawProxyDependencies(proxies[j]);
		}
	}
	
	public function addProxy(proxyLogObj:Object):void {
		var proxyLabel:Label;
		if (proxyLogObj.view == null) {
			proxyLogObj.view = new Label(null, 5, 0, proxyLogObj.proxyObject + "-" + proxyLogObj.injectClass + " " + proxyLogObj.name);
			(proxyLogObj.view as Label).textField.borderColor = 0x3E3EFF;
			(proxyLogObj.view as Label).textField.border = true;
		}
		proxyLabel = proxyLogObj.view;
		//
		proxyLabel.x = 600;
		proxyLabel.y = (proxies.length - 1) * 20 + 50;
		this.addChild(proxyLabel);
	}
	
	public function removeProxyFromPossition(possition:int):void {
		if (proxies[possition] && this.contains(proxies[possition].view)) {
			this.removeChild(proxies[possition].view);
		}
		for (var i:int = possition + 1; i < proxies.length; i++) {
			proxies[i].view.y = (i - 1) * 20 + 50;
			redrawProxyDependencies(proxies[i]);
		}
	}
	
	private function redrawProxyDependencies(proxyObject:Object):void {
		var dependencies:Vector.<Object> = proxyObject.dependencies
		if (dependencies) {
			proxyObject.view.graphics.clear();
			for (var i:int = 0; i < dependencies.length; i++) {
				drawProxyDependency(proxyObject, dependencies[i]);
			}
		}
	}
	
	public function drawProxyDependency(proxyObject:Object, injectedObject:Object):void {
		for (var i:int = 0; i < proxies.length; i++) {
			if (proxies[i].proxyObject == injectedObject) {
				var proxyLabel:Label = (proxyObject.view as Label);
				proxyLabel.graphics.lineStyle(1, 0xFF00FF, 0.5);
				proxyLabel.graphics.moveTo(0, 15);
				proxyLabel.graphics.curveTo(-50, 15, proxies[i].view.x - proxyLabel.x, proxies[i].view.y - proxyLabel.y + 17);
				proxyLabel.graphics.moveTo(0, 15);
				proxyLabel.graphics.lineTo(-5, 15 - 2);
				proxyLabel.graphics.moveTo(0, 15);
				proxyLabel.graphics.lineTo(-5, 15 + 2);
			}
		}
	}
	
	//----------------------------------
	//     commands
	//----------------------------------
	
	public function addCommand(commandLogObj:Object):void {
		var commandPosition:int = -1;
		//
		for (var i:int = 0; i < commands.length; i++) {
			if (commands[i] == null) {
				commandPosition = i;
				commands[i] = commandLogObj;
				break;
			}
		}
		if (commandPosition == -1) {
			commandPosition = commands.length;
			commands.push(commandLogObj);
		}
		
		//
		var commandLabel:Label;
		if (commandLogObj.view == null) {
			commandLogObj.view = new Label(null, 5, 0, commandLogObj.commandObject + " - " + commandLogObj.params);
			(commandLogObj.view as Label).textField.borderColor = 0xFFFF00;
			(commandLogObj.view as Label).textField.border = true;
		}
		commandLabel = commandLogObj.view;
		//
		commandLabel.x = 450 - (commandLabel.width >> 1);
		commandLabel.y = commandPosition * 20 + 60;
		this.addChild(commandLabel);
		
		setTimeout(removeObject, 1500, commandPosition, commandLogObj);
	}
	
	private function removeObject(commandPosition:int, commandLogObj:Object):void {
		
		if (commands.length > commandPosition) {
			if (commands[commandPosition] == commandLogObj) {
				if (this.contains(commandLogObj.view)) {
					this.removeChild(commandLogObj.view);
				}
				commands[commandPosition] = null;
			}
		}
	}
	
	public function clearCommands():void {
		while (commands.length) {
			var command:Object = commands.pop();
			if (command.view) {
				if (this.contains(command.view)) {
					this.removeChild(command.view);
				}
			}
		}
	}

}
}