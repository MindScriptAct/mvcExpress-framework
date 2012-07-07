package com.mindScriptAct.codeSnippets.model {
import com.mindScriptAct.codeSnippets.messages.Msg;
import org.mvcexpress.mvc.Proxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class SampleProxy extends Proxy implements ISampleProxy {
	
	////////////////////////////
	// geting proxies...
	////////////////////////////
	[Inject]
	public var sampleEmptyProxy:SampleEmptyProxy;
	
	[Inject]
	public var sampleEmptyProxyInterfaced:ISampleEmptyProxy;
	
	[Inject(namespace = 'namedSampleEmptyProxy')]
	public var sampleEmptyProxyInterfacedAndNamed:ISampleEmptyProxy;
	
	public var testData:String = "someTestData";
	
	public function SampleProxy() {
	
	}
	
	public function sendTestMessage():void {
		sendMessage(Msg.TEST_DATA_MESSAGE, "sent message about proxy change...");
	}

}
}