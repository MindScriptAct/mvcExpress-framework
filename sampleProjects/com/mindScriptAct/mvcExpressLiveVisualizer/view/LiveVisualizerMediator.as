package com.mindScriptAct.mvcExpressLiveVisualizer.view {
import com.bit101.components.PushButton;
import com.mindScriptAct.mvcExpressLiveVisualizer.constants.ColorIds;
import com.mindScriptAct.mvcExpressLiveVisualizer.engine.AlphaTask;
import com.mindScriptAct.mvcExpressLiveVisualizer.engine.BlueTask;
import com.mindScriptAct.mvcExpressLiveVisualizer.engine.GreenTask;
import com.mindScriptAct.mvcExpressLiveVisualizer.engine.RedTask;
import com.mindScriptAct.mvcExpressLiveVisualizer.LiveVisualizer;
import com.mindScriptAct.mvcExpressLiveVisualizer.messages.VizualizerMessage;
import com.mindScriptAct.mvcExpressLiveVisualizer.view.test.TestColorRectangle;
import flash.events.Event;
import flash.utils.Dictionary;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author rBanevicius
 */
public class LiveVisualizerMediator extends Mediator {
	
	[Inject]
	public var view:LiveVisualizer;
	
	private var testMediators:Dictionary = new Dictionary();
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	override public function onRegister():void {
		
		var redColorControls:ColorControls = new ColorControls(ColorIds.RED, RedTask, null);
		
		var greenColorControls:ColorControls = new ColorControls(ColorIds.GREEN, GreenTask, null);
		greenColorControls.y = 50;
		
		var blueColorControls:ColorControls = new ColorControls(ColorIds.BLUE, BlueTask, null);
		blueColorControls.y = 100;
		
		var alphaColorControls:ColorControls = new ColorControls(ColorIds.ALPHA, AlphaTask, BlueTask);
		alphaColorControls.y = 150;
		
		view.addChild(redColorControls);
		view.addChild(greenColorControls);
		view.addChild(blueColorControls);
		view.addChild(alphaColorControls);
		
		mediatorMap.mediate(redColorControls);
		mediatorMap.mediate(greenColorControls);
		mediatorMap.mediate(blueColorControls);
		mediatorMap.mediate(alphaColorControls);
		
		var clearAll:PushButton = new PushButton(view, 100, 500, "Remove all.", handleRemoveAll);
		
		addHandler(VizualizerMessage.ADD_MEDIATOR, handleAddMediator);
		addHandler(VizualizerMessage.REMOVE_MEDIATOR, handleRemoveMediator);
	
	}
	
	private function handleAddMediator(colorId:String):void {
		var testRectangle:TestColorRectangle = new TestColorRectangle(colorId);
		
		view.addChild(testRectangle);
		mediatorMap.mediate(testRectangle);
		
		testMediators[colorId] = testRectangle;
	
	}
	
	private function handleRemoveMediator(colorId:String):void {
		view.removeChild(testMediators[colorId]);
		mediatorMap.unmediate(testMediators[colorId]);
		delete testMediators[colorId];
	}
	
	private function handleRemoveAll(event:Event):void {
		sendMessage(VizualizerMessage.REMOVE_ALL);
	}
	
	override public function onRemove():void {
	
	}

}
}