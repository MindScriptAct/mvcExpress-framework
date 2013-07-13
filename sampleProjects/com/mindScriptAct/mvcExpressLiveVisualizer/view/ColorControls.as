package com.mindScriptAct.mvcExpressLiveVisualizer.view {
import com.bit101.components.Label;
import com.bit101.components.PushButton;

import flash.display.Sprite;
import flash.events.MouseEvent;

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

	static public const ADD_MEDIATOR:String = "add Mediator";
	static public const REMOVE_MEDIATOR:String = "remove Mediator";

	static public const ADD_PROXY:String = "add Proxy";
	static public const REMOVE_PROXY:String = "remove Proxy";

	public var colorId:String;
	public var taskClass:Class;
	public var afterTaskClass:Class;

	private var addRemoveButton:PushButton;
	private var enableButton:PushButton;
	private var addTestMediatorButton:PushButton;
	private var addTestProxyButton:PushButton;

	public function ColorControls(colorId:String, taskClass:Class, afterTaskClass:Class = null) {
		this.afterTaskClass = afterTaskClass;
		this.colorId = colorId;
		this.taskClass = taskClass;

		new Label(this, 10, 10, colorId);

		addRemoveButton = new PushButton(this, 50, 10, ADD, handleAddRemoveClick);
		if (afterTaskClass) {
			addRemoveButton.label = ADD_AFTER;
		}

		enableButton = new PushButton(this, 155, 10, DISABLE, handleEnableClick);

		addTestMediatorButton = new PushButton(this, 260, 10, ADD_MEDIATOR, handleMediator);

		addTestProxyButton = new PushButton(this, 365, 10, ADD_PROXY, handleProxy);

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

	private function handleMediator(event:MouseEvent):void {
		if (addTestMediatorButton.label == REMOVE_MEDIATOR) {
			addTestMediatorButton.label = ADD_MEDIATOR;
			dispatchEvent(new ColorControlEvent(ColorControlEvent.REMOVE_MEDIATOR, colorId));
		} else {
			addTestMediatorButton.label = REMOVE_MEDIATOR;
			dispatchEvent(new ColorControlEvent(ColorControlEvent.ADD_MEDIATOR, colorId));
		}
	}

	private function handleProxy(event:MouseEvent):void {
		if (addTestProxyButton.label == REMOVE_PROXY) {
			addTestProxyButton.label = ADD_PROXY;
			dispatchEvent(new ColorControlEvent(ColorControlEvent.REMOVE_PROXY, colorId));
		} else {
			addTestProxyButton.label = REMOVE_PROXY;
			dispatchEvent(new ColorControlEvent(ColorControlEvent.ADD_PROXY, colorId));
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