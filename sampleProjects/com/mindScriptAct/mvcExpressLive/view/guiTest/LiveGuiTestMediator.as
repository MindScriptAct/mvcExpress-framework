package com.mindScriptAct.mvcExpressLive.view.guiTest {
import com.bit101.components.Panel;

import mvcexpress.dlc.live.mvc.MediatorLive;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class LiveGuiTestMediator extends MediatorLive {

	[Inject]
	public var view:LiveGuiTest;

	private var panel:Panel = new Panel(null, 50, 300);

	//[Inject]
	//public var myProxy:MyProxy;

	override public function onRegister():void {
		trace("LiveGuiTestMediator.onRegister");

		view.addChild(panel);
		provide(panel, "guiPanelTest");
	}

	override public function onRemove():void {

	}

	//private var panelProvided:Boolean = false;
	//
	//public function get testPanel():Panel {
	//if (panelProvided) {
	//throw Error("This function is ment to be used only once.");
	//}
	//panelProvided = true;
	//return panel;
	//}


}
}