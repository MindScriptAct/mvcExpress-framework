package com.mindScriptAct.modules.counter {
import com.mindScriptAct.modules.counter.view.CounterModuleMediator;
import flash.display.Shape;
import flash.text.TextField;
import org.mvcexpress.modules.ModuleSprite;

/**
 * COMMENT : todo
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class CounterModule extends ModuleSprite {
	
	public var outputText:TextField;
	
	static public const NAME:String = "CounterModule";
	
	public function CounterModule() {
		super(CounterModule.NAME);
		drawView();
		
		mediatorMap.map(CounterModule, CounterModuleMediator);
		
		mediatorMap.mediate(this);
	}
	
	private function drawView():void {
		
		var roundRectangle:Shape = new Shape();
		roundRectangle.graphics.lineStyle(2, 0xFF0000);
		roundRectangle.graphics.beginFill(0xC0C0C0);
		roundRectangle.graphics.drawRoundRect(0, 0, 100, 100, 20);
		roundRectangle.graphics.endFill();
		this.addChild(roundRectangle);
		
		outputText = new TextField();
		this.addChild(outputText);
		outputText.text = '...';
		outputText.x = 10;
		outputText.y = 10;
	}
	
	override protected function onInit():void {
	
	}
	
	override protected function onDispose():void {
	
	}
}
}