package com.mindScriptAct.codeSnippets.model {
import com.mindScriptAct.codeSnippets.messages.Msg;
import org.mvcexpress.mvc.Model;

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
	
	[Inject]
	public var sampleEmptyModelInterfaced:ISampleEmptyModel;
	
	[Inject(namespace = 'namedSampleEmptyModel')]
	public var sampleEmptyModelInterfacedAndNamed:ISampleEmptyModel;
	
	public var testData:String = "someTestData";
	
	public function SampleModel() {
	
	}
	
	public function sendTestMessage():void {
		sendMessage(Msg.TEST_DATA_MESSAGE, "sent message about model change...");
	}

}
}