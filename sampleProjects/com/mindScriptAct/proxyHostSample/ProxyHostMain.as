package com.mindScriptAct.proxyHostSample {
import flash.display.Sprite;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ProxyHostMain extends Sprite {
	
	public function ProxyHostMain() {
		var mainModule:ProxyHostMainModule = new ProxyHostMainModule();
		mainModule.start(this);
	}

}
}