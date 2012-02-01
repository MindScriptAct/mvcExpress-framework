package com.mindScriptAct.mvcExpressSpeedTest.model {
import org.mvcexpress.mvc.Model;

/**
 * COMMENT
 * @author rbanevicius
 */
public class NamedModel extends Model implements INamedModel {
	
	static private var SINGELTON_COUNT:int = 0;
	public var description:String;
	
	public function NamedModel(description:String = "") {
		if (description) {
			this.description = description;
		} else {
			this.description = "Description is autoCreated!! for singelton : " + (++SINGELTON_COUNT);
		}
	}
		
	public function getSomeData():String {
		return "Some data... and description : " + description;
	}

}
}