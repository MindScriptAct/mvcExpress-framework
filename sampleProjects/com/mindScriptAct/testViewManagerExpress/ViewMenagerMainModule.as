package com.mindScriptAct.testViewManagerExpress {
import com.mindScriptAct.testViewManagerExpress.view.main.PlayFieldVMTest;
import com.mindScriptAct.testViewManagerExpress.view.main.PlayFieldVMTestMediator;
import com.mindScriptAct.testViewManagerExpress.view.preloader.PreloaderVMTest;
import com.mindScriptAct.testViewManagerExpress.view.preloader.PreloaderVMTestMediator;
import com.mindScriptAct.testViewManagerExpress.view.test1.Test1VMTest;
import com.mindScriptAct.testViewManagerExpress.view.test1.Test1VMTestMediator;
import com.mindScriptAct.testViewManagerExpress.view.test2.Test2VMTest;
import com.mindScriptAct.testViewManagerExpress.view.test2.Test2VMTestMediator;
import org.mvcexpress.extensions.viewManager.ViewManagerExpress;
import org.mvcexpress.extensions.viewManager.vo.ViewDefinition;
import org.mvcexpress.modules.ModuleCore;

/**
 * COMMENT : todo
 * @author Deril
 */
public class ViewMenagerMainModule extends ModuleCore {
	
	static public const NAME:String = "ViewMenagerTestModule";
	
	public function ViewMenagerMainModule() {
		super(ViewMenagerMainModule.NAME);
	}
	
	override protected function onInit():void {
	
	}
	
	public function start(main:ViewManagerMain):void {
		trace("ViewMenagerMainModule.start > main : " + main);
		
var stageDefinition:ViewDefinition = ViewManagerExpress.init(NAME, main.stage);

stageDefinition.addViews( //
	new ViewDefinition(PreloaderVMTest, PreloaderVMTestMediator), //
	new ViewDefinition(PlayFieldVMTest, PlayFieldVMTestMediator).addViews( //
		new ViewDefinition(Test1VMTest, Test1VMTestMediator), //
		new ViewDefinition(Test2VMTest, Test2VMTestMediator) //
		)
	);

	

	
var level1:ViewDefinition;
var level2:ViewDefinition;
	
level1 = stageDefinition.addDefinition(PreloaderVMTest, PreloaderVMTestMediator);
level1 = stageDefinition.addDefinition(PlayFieldVMTest, PlayFieldVMTestMediator);
{
	level2 = level1.addDefinition(Test1VMTest, Test1VMTestMediator);
	level2 = level1.addDefinition(Test2VMTest, Test2VMTestMediator);
}
			
	}
	
	override protected function onDispose():void {
	
	}
}
}