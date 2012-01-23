package com.mindScriptAct.pureLegsSample.model {
import com.mindScriptAct.pureLegsSample.messages.Msg;
import com.mindScriptAct.pureLegsTest.notes.Note;
import org.pureLegs.mvc.Model;

/**
 * COMMENT
 * @author rbanevicius
 */
public class SampleModel extends Model implements ISampleModel {
	
	////////////////////////////
	// geting model...
	////////////////////////////
	[Inject]
	public var sampleEmptyModel:SampleEmptyModel;
	
	public var testData:String = "someTestData";
	
	public function SampleModel() {
	
	}
	
	/* INTERFACE com.mindScriptAct.pureLegsSample.model.ISampleModel */
	public function sendTestMessage():void {
		sendMessage(Msg.TEST_DATA_MESSAGE, "sent message about model change...");
	}

}
}