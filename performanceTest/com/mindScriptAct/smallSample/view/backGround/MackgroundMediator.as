package com.mindScriptAct.smallSample.view.backGround {
import com.mindScriptAct.smallSample.model.SmallTestProxy;
import flash.geom.Point;
import org.mvcexpress.mvc.Mediator;

/**
 * COMMENT
 * @author rbanevicius
 */
public class MackgroundMediator extends Mediator {
	
	[Inject]
	public var view:Background;
	
	[Inject]
	public var smallProxy:SmallTestProxy;
	
	
	override public function onRegister():void {
		trace("MackgroundMediator.onRegister" + view);
		
		addHandler("moveBg", handleMoveBg);
		
		trace(smallProxy.getThought());
	}
	
	private function handleMoveBg(moveTo:Point):void {
		trace("MackgroundMediator.handleMoveBg > moveTo : " + moveTo);
		view.x = moveTo.x;
		view.y = moveTo.y;
	}
	
	
	private function handleMessage(params:Object):void {
		
	}

}
}