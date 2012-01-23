package com.mindScriptAct.pureLegsSample.model {
import org.pureLegs.mvc.Model;

/**
 * COMMENT
 * @author rbanevicius
 */
public class SampleEmptyModel extends Model implements ISampleEmptyModel {
	
	private var description:String;
	
	public function SampleEmptyModel(description:String) {
		this.description = description;
	}
	
	/* INTERFACE com.mindScriptAct.pureLegsSample.model.ISampleEmptyModel */
	
	public function getDescription():String {
		return description;
	}

}
}