package com.mindscriptact.mvcExpressLogger.screens {
import com.mindscriptact.mvcExpressLogger.minimalComps.components.Mvce_TextArea;
import flash.display.Sprite;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class MvcExpressLogScreen extends Sprite {
	private var screenWidth:int;
	private var screenHeight:int;
	private var txt:Mvce_TextArea;
	
	public function MvcExpressLogScreen(screenWidth:int, screenHeight:int) {
		this.screenWidth = screenWidth;
		this.screenHeight = screenHeight;
		
		txt = new Mvce_TextArea(this);
		txt.width = this.screenWidth;
		txt.height = this.screenHeight;
		txt.editable = false;
	
	}
	
	public function showLog(log:String):void {
		txt.text = log;
	}
	
	public function scrollDown(autoScroll:Boolean = true):void {
		txt.autoScroll = autoScroll;
	}

}
}