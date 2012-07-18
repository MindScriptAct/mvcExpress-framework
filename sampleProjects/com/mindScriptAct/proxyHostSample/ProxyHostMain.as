package com.mindScriptAct.proxyHostSample {
import flash.display.Sprite;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ProxyHostMain extends Sprite {
	
	public function ProxyHostMain() {
		var mainModule:ProxyHostMainModule = new ProxyHostMainModule();
		mainModule.start(this);
	}

}
}