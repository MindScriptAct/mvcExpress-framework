package com.mindScriptAct.circularDependenciesTest {
import com.mindScriptAct.circularDependenciesTest.controller.TestCommand;
import com.mindScriptAct.circularDependenciesTest.model.AProxy;
import com.mindScriptAct.circularDependenciesTest.model.BProxy;
import com.mindScriptAct.circularDependenciesTest.model.CProxy;
import com.mindScriptAct.circularDependenciesTest.model.DProxy;
import com.mindScriptAct.circularDependenciesTest.view.TestView;
import com.mindScriptAct.circularDependenciesTest.view.TestViewMediator;
import com.mindscriptact.mvcExpressLogger.MvcExpressLogger;
import mvcexpress.modules.ModuleSprite;
import mvcexpress.MvcExpress;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class CircularDepenednyModule extends ModuleSprite {

	public function CircularDepenednyModule() {
		MvcExpressLogger.init(this.stage, 0, 0, 900, 500, 0.9, true, MvcExpressLogger.VISUALIZER_TAB);
		super();
	}

	override protected function onInit():void {
		var aProxy:AProxy;
		var bProxy:BProxy;
		var cProxy:CProxy;
		var dProxy:DProxy;

		// enable pending injection feature. (by default it is disabled.)
		MvcExpress.pendingInjectsTimeOut = 1100;

		// debug function
		MvcExpress.debugFunction = trace;

		//----------------------------------
		//     Circular/pending proxy dependency test
		//----------------------------------

		// create proxies for testing
		aProxy = new AProxy();
		bProxy = new BProxy();
		cProxy = new CProxy();
		dProxy = new DProxy();

		//*
		// map proxies.
		proxyMap.map(aProxy);
		proxyMap.map(bProxy);
		proxyMap.map(cProxy);

		// get data.
		trace(aProxy.getdata());
		trace(bProxy.getdata());
		trace(cProxy.getdata());

		// unmap proxies.
		proxyMap.unmap(AProxy);
		proxyMap.unmap(BProxy);
		proxyMap.unmap(CProxy);

		// dProxy has unresolved pending injection. It will throw error after 1.111 sec.
		//proxyMap.map(dProxy);

		//*/

		//----------------------------------
		//     Pending mediator dependency test
		//----------------------------------

		// create proxies for testing
		aProxy = new AProxy();
		bProxy = new BProxy();
		cProxy = new CProxy();
		dProxy = new DProxy();

		//*

		mediatorMap.map(TestView, TestViewMediator);

		var testView:TestView = new TestView();
		mediatorMap.mediate(testView);

		// map proxies.
		proxyMap.map(aProxy);
		proxyMap.map(bProxy);
		proxyMap.map(cProxy);

		// unmap proxies.
		//proxyMap.unmap(AProxy);
		//proxyMap.unmap(BProxy);
		//proxyMap.unmap(CProxy);

		//*/

		//----------------------------------
		//     Pending command dependency test
		//----------------------------------

		// to preven sinchronization problems - cammands cant have pending injections.
		// purpose of commands in framework to instantly do a job. (here and now...)

		// this will throw instant error.
		//commandMap.execute(TestCommand, "Test params..");

	}

}
}