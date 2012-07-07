package com.mindScriptAct.codeSnippets.model {
import org.mvcexpress.mvc.Proxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class SampleEmptyProxy extends Proxy implements ISampleEmptyProxy {
	
	private var description:String;
	
	public function SampleEmptyProxy(description:String) {
		this.description = description;
	}
		
	public function getDescription():String {
		return description;
	}

}
}