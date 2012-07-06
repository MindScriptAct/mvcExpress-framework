package com.mindscriptact.mvcExpressLogger.screens {
import com.bit101.components.Text;
import com.bit101.components.TextArea;
import flash.display.Sprite;
import flash.utils.setTimeout;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class MvcExpressLogScreen extends Sprite {
	private var screenWidth:int;
	private var screenHeight:int;
	private var txt:TextArea;
	
	public function MvcExpressLogScreen(screenWidth:int, screenHeight:int) {
		this.screenWidth = screenWidth;
		this.screenHeight = screenHeight;
		
		txt = new TextArea(this);
		txt.width = this.screenWidth;
		txt.height = this.screenHeight;
		txt.editable = false;
	
	}
	
	public function showLog(log:String):void {
		txt.text = log;
	}
	
	//public function scrollDown():void {
		//setTimeout(doScroll, 100);
	//
	//}
	//
	//public function doScroll():void {
		//txt.scrollDown();
	//}

}
}