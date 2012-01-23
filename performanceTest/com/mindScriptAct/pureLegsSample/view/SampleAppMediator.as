package com.mindScriptAct.pureLegsSample.view {
import com.mindScriptAct.pureLegsSample.messages.Msg;
import com.mindScriptAct.pureLegsSample.model.SampleEmptyModel;
import com.mindScriptAct.pureLegsSample.PureLegsSample;
import com.mindScriptAct.pureLegsTest.notes.Note;
import com.mindScriptAct.pureLegsTest.PureLegsTesting;
import com.mindScriptAct.pureLegsTest.view.testSprite.TestSprite;
import com.mindScriptAct.pureLegsTest.view.testSprite.TestSpriteMediator;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import org.pureLegs.mvc.Mediator;

/**
 * COMMENT
 * @author rbanevicius
 */
public class SampleAppMediator extends Mediator {
	
	////////////////////////////
	// geting view object...
	////////////////////////////
	[Inject]
	public var view:PureLegsSample;
	
	////////////////////////////
	// geting model...
	////////////////////////////
	[Inject]
	public var sampleEmptyModel:SampleEmptyModel;
	
	override public function onRegister():void {
		trace("SampleAppMediator.onRegister");
		
		////////////////////////////
		// comunication
		////////////////////////////
		addHandler(Msg.TEST_DATA_MESSAGE, handleTestDataMessage);
		
		sendMessage(Msg.TEST_DATA_MESSAGE, "SampleAppMediator works!!!");
		
		removeCallback(Msg.TEST_DATA_MESSAGE, handleTestDataMessage);
	
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