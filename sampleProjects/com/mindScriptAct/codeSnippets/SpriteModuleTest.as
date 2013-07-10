package com.mindScriptAct.codeSnippets {
import com.mindScriptAct.codeSnippets.controller.ManyInjectsCommand;
import com.mindScriptAct.codeSnippets.controller.SampleCommand;
import com.mindScriptAct.codeSnippets.controller.StartModuleTestCommand;
import com.mindScriptAct.codeSnippets.controller.params.ComplexParams;
import com.mindScriptAct.codeSnippets.controller.setup.SetupControllerCommand;
import com.mindScriptAct.codeSnippets.controller.setup.SetupModelCommand;
import com.mindScriptAct.codeSnippets.controller.setup.SetupViewCommand;
import com.mindScriptAct.codeSnippets.messages.DataMsg;
import com.mindScriptAct.codeSnippets.messages.Msg;
import com.mindScriptAct.codeSnippets.messages.ViewMsg;
import com.mindscriptact.mvcExpressLogger.MvcExpressLogger;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

import mvcexpress.MvcExpress;
import mvcexpress.modules.ModuleCore;
import mvcexpress.utils.checkClassStringConstants;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class SpriteModuleTest extends Sprite {

	private var moduleCore:ModuleCore;

	public function SpriteModuleTest() {

		moduleCore = new ModuleCore("SpriteModuleTest");


		MvcExpressLogger.init(this.stage, 0, 0, 900, 500, 0.9, true, MvcExpressLogger.VISUALIZER_TAB);

		super();

		trace("SpriteModuleTest.SpriteModuleTest");

		//
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		//


		CONFIG::debug {

			MvcExpress.debugFunction = trace;

			checkClassStringConstants(Msg, DataMsg, ViewMsg);
		}


		// setup model
		moduleCore.executeCommand(SetupModelCommand);

		// setup view
		moduleCore.executeCommand(SetupViewCommand);


		// setup controller
		moduleCore.executeCommand(SetupControllerCommand);

		moduleCore.executeCommand(SampleCommand);
		moduleCore.executeCommand(SampleCommand, "single execute parameter");
		moduleCore.executeCommand(SampleCommand, new ComplexParams("complex execute parameters"));

		// command with many injects
		moduleCore.executeCommand(ManyInjectsCommand);


		////////////////////////////
		// comunication
		////////////////////////////
		moduleCore.sendMessage(Msg.TEST);
		moduleCore.sendMessage(Msg.TEST, "single message parameter");
		moduleCore.sendMessage(Msg.TEST, new ComplexParams("complex message parameters"));

		// start app
		moduleCore.executeCommand(StartModuleTestCommand, this);


	}

}
}