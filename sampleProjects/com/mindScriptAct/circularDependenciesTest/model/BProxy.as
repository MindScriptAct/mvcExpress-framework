package com.mindScriptAct.circularDependenciesTest.model {
import mvcexpress.mvc.Proxy;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class BProxy extends Proxy {

	[Inject]
	public var aProxy:AProxy;

	[Inject]
	public var cProxy:CProxy;

	public var data:int = 3

	public function BProxy() {

	}

	override protected function onRegister():void {
		trace("BProxy.onRegister");
	}

	override protected function onRemove():void {

	}

	public function getdata():int {
		return aProxy.data * cProxy.data;
	}

}
}