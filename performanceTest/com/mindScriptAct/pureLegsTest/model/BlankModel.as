package com.mindScriptAct.pureLegsTest.model {
import com.mindScriptAct.pureLegsTest.notes.Note;
import org.pureLegs.mvc.Model;

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