package com.mindScriptAct.mvcExpressVisualizer.view {
import com.mindScriptAct.mvcExpressVisualizer.VisualLoggerTestModule;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class VisualLoggerTestModuleMediator extends Mediator{
	
	[Inject]
	public var view:VisualLoggerTestModule;
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	override public function onRegister():void{
		
	}
	
	override public function onRemove():void{
		
	}
	
}
}