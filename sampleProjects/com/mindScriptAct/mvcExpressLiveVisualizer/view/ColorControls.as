package com.mindScriptAct.mvcExpressLiveVisualizer.view {
import adobe.utils.CustomActions;
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
	
	static public const ENABLE:String = "ENABLE";
	static public const DISABLE:String = "DISABLE";
	
	public var colorId:String;
	public var taskClass:Class;
	public var afterTaskClass:Class;
	
	private var addRemoveButton:PushButton;
	private var enableButton:PushButton;
	
	public function ColorControls(colorId:String, taskClass:Class, afterTaskClass:Class = null) {
		this.afterTaskClass = afterTaskClass;
		this.colorId = colorId;
		this.taskClass = taskClass;
		
		new Label(this, 10, 10, colorId);
		
		addRemoveButton = new PushButton(this, 50, 10, ADD, handleAddRemoveClick);
		if (afterTaskClass) {
			addRemoveButton.label = ADD_AFTER;
		}
		
		enableButton = new PushButton(this, 150, 10, DISABLE, handleEnableClick);
	}
	
	private function handleEnableClick(event:MouseEvent):void {
		if (enableButton.label == DISABLE) {
			enableButton.label = ENABLE;
			dispatchEvent(new ColorControlEvent(ColorControlEvent.DISABLE, colorId));
		} else {
			enableButton.label = DISABLE;
			dispatchEvent(new ColorControlEvent(ColorControlEvent.ENABLE, colorId));
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
	
	public function resetState():void {
		if (afterTaskClass) {
			addRemoveButton.label = ADD_AFTER;
		} else {
			addRemoveButton.label = ADD;
		}
		
		enableButton.label = DISABLE;
	}

}
}