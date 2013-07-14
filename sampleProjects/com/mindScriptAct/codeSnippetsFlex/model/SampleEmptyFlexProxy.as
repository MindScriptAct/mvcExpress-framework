package com.mindScriptAct.codeSnippetsFlex.model {

import mvcexpress.mvc.Proxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class SampleEmptyFlexProxy extends Proxy implements ISampleEmptyFlexProxy {

	private var description:String;

	public function SampleEmptyFlexProxy(description:String) {
		this.description = description;
	}

	public function getDescription():String {
		return description;
	}

}
}