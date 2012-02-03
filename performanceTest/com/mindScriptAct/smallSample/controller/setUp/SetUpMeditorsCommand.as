package com.mindScriptAct.smallSample.controller.setUp {
import com.mindScriptAct.smallSample.SmallSampleMain;
import com.mindScriptAct.smallSample.view.backGround.Background;
import com.mindScriptAct.smallSample.view.backGround.MackgroundMediator;
import com.mindScriptAct.smallSample.view.SmallSampleMediator;
import org.mvcexpress.mvc.Command;

/**
 * COMMENT
 * @author rbanevicius
 */
public class SetUpMeditorsCommand extends Command {
	
	public function execute(params:Object):void {
		mediatorMap.map(SmallSampleMain, SmallSampleMediator);
		mediatorMap.map(Background, MackgroundMediator);
	}

}
}