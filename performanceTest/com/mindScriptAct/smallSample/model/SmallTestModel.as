package com.mindScriptAct.smallSample.model {
import org.mvcexpress.mvc.Model;

public class SmallTestModel extends Model {
	
	private var someThoughts:String = "Those who are unaware they are walking in darkness will never seek the light.";
	
	public function SmallTestModel() {
	}
	
	public function getThought():String {
		return someThoughts;
	}

}
}