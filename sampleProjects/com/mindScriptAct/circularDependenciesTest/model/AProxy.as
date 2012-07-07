package com.mindScriptAct.circularDependenciesTest.model {
import org.mvcexpress.mvc.Proxy;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class AProxy extends Proxy {
	
	[Inject]
	public var bProxy:BProxy;
	
	[Inject]
	public var cProxy:CProxy;
	
	public var data:int = 2;
	
	public function AProxy() {
	
	}
	
	override protected function onRegister():void {
		trace("AProxy.onRegister");
	}
	
	override protected function onRemove():void {
	
	}
	
	public function getdata():int {
		return bProxy.data * cProxy.data;
	}

}
}