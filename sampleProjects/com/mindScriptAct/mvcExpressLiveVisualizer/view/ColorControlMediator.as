package com.mindScriptAct.mvcExpressLiveVisualizer.view {
import com.mindScriptAct.mvcExpressLiveVisualizer.messages.VizualizerMessage;
import org.mvcexpress.mvc.Mediator;

/**
 * CLASS COMMENT
 * @author rBanevicius
 */
public class ColorControlMediator extends Mediator {
	
	[Inject]
	public var view:ColorControls;
	
	override public function onRegister():void {
		trace("ColorControlMediator.onRegister", view.colorId);
		
		view.addEventListener(ColorControlEvent.ADD, handleAdd);
		view.addEventListener(ColorControlEvent.ADDAFTER, handleAddAfter);
		view.addEventListener(ColorControlEvent.REMOVE, handleRemove);
		
		view.addEventListener(ColorControlEvent.ENABLE, handleEnable);
		view.addEventListener(ColorControlEvent.DISABLE, handleDisable);
		
		view.addEventListener(ColorControlEvent.ADD_MEDIATOR, handleAddMediator);
		view.addEventListener(ColorControlEvent.REMOVE_MEDIATOR, handleRemoveMediator);
		view.addEventListener(ColorControlEvent.ADD_PROXY, handleAddProxy);
		view.addEventListener(ColorControlEvent.REMOVE_PROXY, handleRemoveProxy);
		
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
	
	private function handleEnable(event:ColorControlEvent):void {
		sendMessage(VizualizerMessage.ENABLE, view);
	}
	
	private function handleDisable(event:ColorControlEvent):void {
		sendMessage(VizualizerMessage.DISABLE, view);
	}
	
	private function handleRemoveAll(blank:Object):void {
		view.resetState();
	}
	
	private function handleAddMediator(event:ColorControlEvent):void {
		sendMessage(VizualizerMessage.ADD_MEDIATOR, view.colorId);
	}
	
	private function handleRemoveMediator(event:ColorControlEvent):void {
		sendMessage(VizualizerMessage.REMOVE_MEDIATOR, view.colorId);
	}
	
	private function handleAddProxy(event:ColorControlEvent):void {
		sendMessage(VizualizerMessage.ADD_PROXY, view.colorId);
	}
	
	private function handleRemoveProxy(event:ColorControlEvent):void {
		sendMessage(VizualizerMessage.REMOVE_PROXY, view.colorId);
	}
	
	override public function onRemove():void {
	}

}
}