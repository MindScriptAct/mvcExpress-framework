package com.mindScriptAct.mvcExpressLiveVisualizer.view {
import com.mindScriptAct.mvcExpressLiveVisualizer.messages.VizualizerMessage;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author rBanevicius
 */
public class ColorControlMediator extends Mediator {
	
	[Inject]
	public var view:ColorControls;
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	override public function onRegister():void {
		trace("ColorControlMediator.onRegister", view.colorId);
		
		view.addEventListener(ColorControlEvent.ADD, handleAdd);
		view.addEventListener(ColorControlEvent.ADDAFTER, handleAddAfter);
		view.addEventListener(ColorControlEvent.REMOVE, handleRemove);
		
		addHandler(VizualizerMessage.REMOVE_ALL, handleRemoveAll);
	}
	
	private function handleAddAfter(event:ColorControlEvent):void {
		//trace( "ColorControlMediator.handleAddAfter > event : " + event );
		sendMessage(VizualizerMessage.ADD_AFTER, view);
	}
	
	private function handleRemove(event:ColorControlEvent):void {
		//trace("ColorControlMediator.handleRemove > event : " + event.colorId);
		sendMessage(VizualizerMessage.ADD, view);
	}
	
	private function handleAdd(event:ColorControlEvent):void {
		//trace("ColorControlMediator.handleAdd > event : " + event.colorId);
		sendMessage(VizualizerMessage.REMOVE, view);
	}
	
	private function handleRemoveAll(blank:Object):void {
		view.resetState();
	}
	
	override public function onRemove():void {
	}

}
}