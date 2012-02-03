package com.mindScriptAct.smallSample.view {
import com.mindScriptAct.smallSample.SmallSampleMain;
import com.mindScriptAct.smallSample.view.backGround.Background;
import org.mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author rbanevicius
 */
public class SmallSampleMediator extends Mediator {
	
	[Inject]
	public var view:SmallSampleMain;
	
	override public function onRegister():void {
		trace("SmallSampleMediator.onRegister", view);
		
		var bg:Background = new Background();
		view.addChild(bg);
		mediatorMap.mediate(bg);
	}

}
}