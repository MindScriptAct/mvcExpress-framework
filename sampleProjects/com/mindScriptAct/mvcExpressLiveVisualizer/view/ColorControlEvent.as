package com.mindScriptAct.mvcExpressLiveVisualizer.view {
import flash.events.Event;

/**
 * COMMENT
 * @author rBanevicius
 */
public class ColorControlEvent extends Event {
	public var colorId:String;
	static public const ADD:String = "add";
	static public const REMOVE:String = "remove";
	static public const ADDAFTER:String = "addafter";
	
	public function ColorControlEvent(type:String, colorId:String) {
		super(type);
		this.colorId = colorId;
	
	}

}
}