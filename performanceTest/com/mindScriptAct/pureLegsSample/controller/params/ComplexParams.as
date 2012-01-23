package com.mindScriptAct.pureLegsSample.controller.params {

/**
 * COMMENT
 * @author rbanevicius
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