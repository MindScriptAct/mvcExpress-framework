package com.mindscriptact.mvcExpressLogger.screens {
import com.bit101.components.Label;
import com.bit101.components.Text;
import com.bit101.components.TextArea;
import flash.display.Sprite;
import flash.text.TextFieldAutoSize;
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
	
	public function addMediators(mediators:Vector.<Object>):void {
		if (mediators) {
			this.mediators = mediators;
			//trace("MvcExpressVisualizerScreen.addMediators > mediators : " + mediators);
			for (var i:int = 0; i < mediators.length; i++) {
				addMediator(mediators[i]);
			}
			for (var j:int = 0; j < mediators.length; j++) {
				mediators[j].view.y = j * 20 + 50;
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
		if (this.contains(mediators[possition].view)) {
			this.removeChild(mediators[possition].view);
		}
		for (var i:int = possition + 1; i < mediators.length; i++) {
			mediators[i].view.y = (i - 1) * 20 + 50;
		}
	}
	
	public function addProxies(proxies:Vector.<Object>):void {
		if (proxies) {
			this.proxies = proxies;
		}
		for (var i:int = 0; i < proxies.length; i++) {
			addProxy(proxies[i]);
		}
		for (var j:int = 0; j < proxies.length; j++) {
			proxies[j].view.y = j * 20 + 50;
		}
	}
	
	public function addProxy(proxyLogObj:Object):void {
		var proxyLabel:Label;
		if (proxyLogObj.view == null) {
			proxyLogObj.view = new Label(null, 5, 0, proxyLogObj.proxyObject + "-" + proxyLogObj.injectClass + proxyLogObj.name);
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
		if (this.contains(proxies[possition].view)) {
			this.removeChild(proxies[possition].view);
		}
		for (var i:int = possition + 1; i < proxies.length; i++) {
			proxies[i].view.y = (i - 1) * 20 + 50;
		}
	}

}
}