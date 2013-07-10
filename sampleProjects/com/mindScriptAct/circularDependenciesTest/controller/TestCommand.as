package com.mindScriptAct.circularDependenciesTest.controller {
import com.mindScriptAct.circularDependenciesTest.model.AProxy;
import com.mindScriptAct.circularDependenciesTest.model.BProxy;
import com.mindScriptAct.circularDependenciesTest.model.CProxy;
import mvcexpress.mvc.Command;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TestCommand extends Command {

	[Inject]
	public var aProxy:AProxy;

	[Inject]
	public var bProxy:BProxy;

	[Inject]
	public var cProxy:CProxy;

	public function execute(params:Object):void {
		trace("TestCommand.execute > params : " + params);

		trace("3 proxy data multyplication is: " + int(aProxy.data * bProxy.data * cProxy.data));

	}

}
}