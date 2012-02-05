package com.mindScriptAct.smallSample.controller.setup {
import com.mindScriptAct.smallSample.SampleMain;
import com.mindScriptAct.smallSample.view.backGround.Background;
import com.mindScriptAct.smallSample.view.backGround.MackgroundMediator;
import com.mindScriptAct.smallSample.view.SampleMediator;
import org.mvcexpress.mvc.Command;

/**
 * COMMENT
 * @author rbanevicius
 */
public class SetupMeditorsCommand extends Command {
	
	public function execute(params:Object):void {
		mediatorMap.map(SampleMain, SampleMediator);
		mediatorMap.map(Background, MackgroundMediator);
	}

}
}