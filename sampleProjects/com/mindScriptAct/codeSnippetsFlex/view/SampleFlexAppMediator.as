package com.mindScriptAct.codeSnippetsFlex.view {
import com.mindScriptAct.codeSnippetsFlex.MvcExpressFlexSnippets;
import com.mindScriptAct.codeSnippetsFlex.messages.MsgFlex;
import com.mindScriptAct.codeSnippetsFlex.model.SampleEmptyFlexProxy;
import com.mindScriptAct.codeSnippetsFlex.view.flexObj.TestTileFlexWindow;

import flash.events.MouseEvent;

import mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class SampleFlexAppMediator extends Mediator {

	////////////////////////////
	// geting view object...
	////////////////////////////
	[Inject]
	public var view:MvcExpressFlexSnippets;

	////////////////////////////
	// geting proxies...
	////////////////////////////
	[Inject]
	public var sampleEmptyProxy:SampleEmptyFlexProxy;

	private var testObj:TestTileFlexWindow = new TestTileFlexWindow();

	override protected function onRegister():void {
		trace("SampleAppMediator.onRegister");

		////////////////////////////
		// comunication
		////////////////////////////
		addHandler(MsgFlex.TEST_DATA_MESSAGE, handleTestDataMessage);

		sendMessage(MsgFlex.TEST_DATA_MESSAGE, "SampleAppMediator works!!!");

		removeHandler(MsgFlex.TEST_DATA_MESSAGE, handleTestDataMessage);

		addListener(view.testButton, MouseEvent.CLICK, handleTestButtonClic);

		testObj.x = 100;
		testObj.y = 100;

		mediatorMap.mediate(testObj);


	}

	private function handleTestButtonClic(event:MouseEvent):void {
		view.addElement(testObj);

	}

	// callBack MUST have 1 and only one parameter. This parameter can be typed(or be Object type)
	private function handleTestDataMessage(messageText:String):void {
		trace("SampleAppMediator.handleTestDataMessage > messageText : " + messageText);
	}

	override protected function onRemove():void {
		trace("SampleAppMediator.onRemove");
	}

}
}