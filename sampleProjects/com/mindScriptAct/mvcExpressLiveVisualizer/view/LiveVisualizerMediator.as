package com.mindScriptAct.mvcExpressLiveVisualizer.view {
import com.mindScriptAct.mvcExpressLiveVisualizer.constants.ColorIds;
import com.mindScriptAct.mvcExpressLiveVisualizer.engine.BlueTask;
import com.mindScriptAct.mvcExpressLiveVisualizer.engine.GreenTask;
import com.mindScriptAct.mvcExpressLiveVisualizer.engine.RedTask;
import com.mindScriptAct.mvcExpressLiveVisualizer.LiveVisualizer;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author rBanevicius
 */
public class LiveVisualizerMediator extends Mediator {
	
	[Inject]
	public var view:LiveVisualizer;
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	override public function onRegister():void {
		
		var redColorControls:ColorControls = new ColorControls(ColorIds.RED, RedTask);
		
		var greenColorControls:ColorControls = new ColorControls(ColorIds.GREEN, GreenTask);
		greenColorControls.y = 50;
		
		var blueColorControls:ColorControls = new ColorControls(ColorIds.BLUE, BlueTask);
		blueColorControls.y = 100;
		
		view.addChild(redColorControls);
		view.addChild(greenColorControls);
		view.addChild(blueColorControls);
		
		mediatorMap.mediate(redColorControls);
		mediatorMap.mediate(greenColorControls);
		mediatorMap.mediate(blueColorControls);
	
	}
	
	override public function onRemove():void {
	
	}

}
}