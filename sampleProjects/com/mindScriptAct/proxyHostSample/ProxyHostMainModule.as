package com.mindScriptAct.proxyHostSample {
import com.mindScriptAct.proxyHostSample.model.TestProxy;
import com.mindScriptAct.proxyHostSample.view.ProxyHostMainMediator;
import org.mvcexpress.modules.ModuleCore;

/**
 * COMMENT : todo
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ProxyHostMainModule extends ModuleCore {
	
	static public const NAME:String = "ProxyHostMainModule";
	
	public function ProxyHostMainModule() {
		super(ProxyHostMainModule.NAME);
	}
	
	override protected function onInit():void {
		
		// map main view Class with mediator class
		mediatorMap.map(ProxyHostMain, ProxyHostMainMediator);
		
		// create proxy for glabal use
		var testProxy:TestProxy = new TestProxy();
		// map for local use.
		proxyMap.map(testProxy);
		
		// map for global use.
		proxyMap.host(testProxy);
		
	}
	
	public function start(main:ProxyHostMain):void {
		// madiate main view object.
		mediatorMap.mediate(main);
	}
	
	override protected function onDispose():void {
	
	}
}
}