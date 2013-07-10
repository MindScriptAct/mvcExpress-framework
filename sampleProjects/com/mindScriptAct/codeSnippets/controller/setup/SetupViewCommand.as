package com.mindScriptAct.codeSnippets.controller.setup {
import com.mindScriptAct.codeSnippets.SpriteModuleTest;
import com.mindScriptAct.codeSnippets.view.MainAppMediator;
import com.mindScriptAct.codeSnippets.view.mediateWithTest.ChildSpriteTest;
import com.mindScriptAct.codeSnippets.view.mediateWithTest.ChildSpriteTestMediator;

import mvcexpress.mvc.Command;

/**
 * TODO:CLASS COMMENT
 * @author Deril
 */
public class SetupViewCommand extends Command {

	public function execute(blank:Object):void {
		////////////////////////////
		// View
		// - view classes are maped to mediator classes 1 to 1.
		////////////////////////////

		mediatorMap.map(SpriteModuleTest, MainAppMediator);
		mediatorMap.map(ChildSpriteTest, ChildSpriteTestMediator);

		// bad maping... (throws error.)
		//mediatorMap.map(Sprite, Sprite);

		// bad execute test...
		//var badCommand:SampleEmptyCommand = new SampleEmptyCommand();
		//badCommand.execute(null);
	}

}
}
