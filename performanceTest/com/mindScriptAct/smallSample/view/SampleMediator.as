package com.mindScriptAct.smallSample.view {
import com.mindScriptAct.smallSample.SampleMain;
import com.mindScriptAct.smallSample.view.backGround.Background;
import org.mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author rbanevicius
 */
public class SampleMediator extends Mediator {
	
	[Inject]
	public var view:SampleMain;
	
	override public function onRegister():void {
		trace("SampleMediator.onRegister", view);
		
		var bg:Background = new Background();
		view.addChild(bg);
		mediatorMap.mediate(bg);
	}

}
}