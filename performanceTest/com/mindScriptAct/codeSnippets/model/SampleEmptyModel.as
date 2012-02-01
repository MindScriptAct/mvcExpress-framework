package com.mindScriptAct.codeSnippets.model {
import org.mvcexpress.mvc.Model;

/**
 * COMMENT
 * @author rbanevicius
 */
public class SampleEmptyModel extends Model implements ISampleEmptyModel {
	
	private var description:String;
	
	public function SampleEmptyModel(description:String) {
		this.description = description;
	}
		
	public function getDescription():String {
		return description;
	}

}
}