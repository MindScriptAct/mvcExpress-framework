package com.mindScriptAct.circularDependenciesTest.model {
import org.mvcexpress.mvc.Proxy;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class CProxy extends Proxy {
	
	[Inject]
	public var aProxy:AProxy;
	
	[Inject]
	public var bProxy:BProxy;
	
	public var data:int = 5;
	
	public function CProxy() {
	
	}
	
	override protected function onRegister():void {
		trace("CProxy.onRegister");
	}
	
	override protected function onRemove():void {
	
	}
	
		public function getdata():int {
		return aProxy.data * bProxy.data;
	}

}
}