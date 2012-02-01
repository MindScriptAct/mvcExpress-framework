package com.mindScriptAct.mvcExpressSpeedTest.model {
import com.mindScriptAct.mvcExpressSpeedTest.notes.Note;
import org.mvcexpress.mvc.Model;

/**
 * COMMENT
 * @author rbanevicius
 */
public class BlankModel extends Model {
	
	public var testData:String = "someTestData";
	
	public function BlankModel(){
	}
	
	public function sendTestMessage():void {
		sendMessage(Note.ACTIVATE_MEDIATOR);
	}

}
}