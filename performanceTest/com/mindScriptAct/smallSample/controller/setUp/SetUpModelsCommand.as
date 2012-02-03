package com.mindScriptAct.smallSample.controller.setUp {
import com.mindScriptAct.smallSample.model.SmallTestModel;
import org.mvcexpress.mvc.Command;
import suites.modelMap.modelTestObj.TestModel;

public class SetUpModelsCommand extends Command {
	
	public function execute(params:Object):void {
		trace( "SetUpModelsCommand.execute > params : " + params );
		modelMap.mapClass(SmallTestModel);		
	}

}
}