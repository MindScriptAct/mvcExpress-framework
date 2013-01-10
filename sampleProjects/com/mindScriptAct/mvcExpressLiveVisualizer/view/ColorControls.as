package com.mindScriptAct.mvcExpressLiveVisualizer.view {
import com.bit101.components.Label;
import com.bit101.components.PushButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import org.mvcexpress.live.Task;

/**
 * COMMENT
 * @author rBanevicius
 */
public class ColorControls extends Sprite {
	
	static public const ADD:String = "ADD";
	static public const ADD_AFTER:String = "ADD_AFTER";
	static public const REMOVE:String = "REMOVE";
	
	public var colorId:String;
	public var taskClass:Class;
	public var afterTaskClass:Class;
	
	private var addRemoveButton:PushButton;
	
	public function ColorControls(colorId:String, taskClass:Class, afterTaskClass:Class = null) {
		this.afterTaskClass = afterTaskClass;
		this.colorId = colorId;
		this.taskClass = taskClass;
		
		new Label(this, 10, 10, colorId);
		
		addRemoveButton = new PushButton(this, 50, 10, "ADD", handleAddRemoveClick);
		if (afterTaskClass) {
			addRemoveButton.label = ADD_AFTER;
		}
	}
	
	private function handleAddRemoveClick(event:MouseEvent):void {
		//trace("ColorControls.handleAddRemoveClick > event : " + event);
		
		if (addRemoveButton.label == REMOVE) {
			if (afterTaskClass) {
				addRemoveButton.label = ADD_AFTER;
			} else {
				addRemoveButton.label = ADD;
			}
			dispatchEvent(new ColorControlEvent(ColorControlEvent.REMOVE, colorId));
		} else {
			addRemoveButton.label = REMOVE;
			if (afterTaskClass) {
				dispatchEvent(new ColorControlEvent(ColorControlEvent.ADDAFTER, colorId));
			} else {
				dispatchEvent(new ColorControlEvent(ColorControlEvent.ADD, colorId));
			}
		}
	}

}
}