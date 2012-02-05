package com.mindScriptAct.smallSample.model {
import org.mvcexpress.mvc.Proxy;

public class SmallTestProxy extends Proxy {
	
	private var someThoughts:String = "Those who are unaware they are walking in darkness will never seek the light.";
	
	public function SmallTestProxy() {
	}
	
	public function getThought():String {
		return someThoughts;
	}

}
}