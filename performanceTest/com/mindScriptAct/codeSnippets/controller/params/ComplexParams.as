package com.mindScriptAct.codeSnippets.controller.params {

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class ComplexParams {
	public var description:String;
	
	public function ComplexParams(description:String = "") {
		this.description = description;
	}
	
	public function toString():String {
		return "[ComplexParams description=" + description + "]";
	}
}
}