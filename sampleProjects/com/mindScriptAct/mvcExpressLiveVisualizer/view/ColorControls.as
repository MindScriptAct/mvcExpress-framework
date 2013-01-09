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
	static public const REMOVE:String = "REMOVE";	
	
	public var colorId:String;
	public var taskClass:Class;
	
	private var addRemoveButton:PushButton;
	
	public function ColorControls(colorId:String, taskClass:Class) {
		this.colorId = colorId;
		this.taskClass = taskClass;
		
		new Label(this, 10, 10, colorId);
		
		addRemoveButton = new PushButton(this, 50, 10, "ADD", handleAddRemoveClick);
	
	}
	
	private function handleAddRemoveClick(event:MouseEvent):void {
		trace("ColorControls.handleAddRemoveClick > event : " + event);
		if (addRemoveButton.label == ADD) {
			addRemoveButton.label = REMOVE;
			dispatchEvent(new ColorControlEvent(ColorControlEvent.ADD, colorId));
		} else {
			addRemoveButton.label = ADD;
			dispatchEvent(new ColorControlEvent(ColorControlEvent.REMOVE, colorId));
		}
	}

}
}