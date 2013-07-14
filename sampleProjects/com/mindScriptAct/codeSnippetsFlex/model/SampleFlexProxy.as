package com.mindScriptAct.codeSnippetsFlex.model {
import com.mindScriptAct.codeSnippetsFlex.messages.MsgFlex;

import mvcexpress.mvc.Proxy;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class SampleFlexProxy extends Proxy implements ISampleFlexProxy {

	////////////////////////////
	// geting proxies...
	////////////////////////////
	//[Inject]
	//public var sampleEmptyProxy:SampleEmptyProxy;

	[Inject]
	public var sampleEmptyProxyInterfaced:ISampleEmptyFlexProxy;

	[Inject(name='namedSampleProxy')]
	public var sampleEmptyProxyNamed:SampleEmptyFlexProxy;

	[Inject(name='namedSampleInterfacedProxy')]
	public var sampleEmptyProxyInterfacedAndNamed:ISampleEmptyFlexProxy;

	public var testData:String = "someTestData";

	public function SampleFlexProxy() {

	}

	override protected function onRegister():void {
		trace("SampleProxy.onRegister");

	}

	public function sendTestMessage():void {
		sendMessage(MsgFlex.TEST_DATA_MESSAGE, "sent message about proxy change...");
	}

}
}