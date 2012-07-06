package com.mindScriptAct.codeSnippets.view {
import com.mindScriptAct.codeSnippets.messages.Msg;
import com.mindScriptAct.codeSnippets.model.SampleEmptyProxy;
import com.mindScriptAct.codeSnippets.MvcExpressSnippets;
import com.mindScriptAct.codeSnippets.SnippetAppModule;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import org.mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class SampleAppMediator extends Mediator {
	
	////////////////////////////
	// geting view object...
	////////////////////////////
	[Inject]
	public var view:MvcExpressSnippets;
	
	////////////////////////////
	// geting proxies...
	////////////////////////////
	[Inject]
	public var sampleEmptyProxy:SampleEmptyProxy;
	
	override public function onRegister():void {
		trace("SampleAppMediator.onRegister");
		
		////////////////////////////
		// comunication
		////////////////////////////
		addHandler(Msg.TEST_DATA_MESSAGE, handleTestDataMessage);
		
		sendMessage(Msg.TEST_DATA_MESSAGE, "SampleAppMediator works!!!");
		
		removeHandler(Msg.TEST_DATA_MESSAGE, handleTestDataMessage);
	
	}
	
	// callBack MUST have 1 and only one parameter. This parameter can be typed(or be Object type)
	private function handleTestDataMessage(messageText:String):void {
		trace("SampleAppMediator.handleTestDataMessage > messageText : " + messageText);
	}
	
	override public function onRemove():void {
		trace("SampleAppMediator.onRemove");
	}

}
}