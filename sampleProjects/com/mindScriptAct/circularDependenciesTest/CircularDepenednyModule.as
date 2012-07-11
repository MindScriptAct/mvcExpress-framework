package com.mindScriptAct.circularDependenciesTest {
import com.mindScriptAct.circularDependenciesTest.controller.TestCommand;
import com.mindScriptAct.circularDependenciesTest.model.AProxy;
import com.mindScriptAct.circularDependenciesTest.model.BProxy;
import com.mindScriptAct.circularDependenciesTest.model.CProxy;
import com.mindScriptAct.circularDependenciesTest.model.DProxy;
import com.mindScriptAct.circularDependenciesTest.view.TestView;
import com.mindScriptAct.circularDependenciesTest.view.TestViewMediator;
import org.mvcexpress.modules.ModuleSprite;
import org.mvcexpress.MvcExpress;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class CircularDepenednyModule extends ModuleSprite {
	
	public function CircularDepenednyModule() {
	
	}
	
	override protected function onInit():void {
		trace("CircularDepenednyModule.onInit");
		
		// enable pending injection feature. (by default it is disabled.)
		MvcExpress.pendingInjectsTimeOut = 1100;
		
		// debug function
		MvcExpress.debugFunction = trace;
		
		// create proxies for testing
		var aProxy:AProxy = new AProxy();
		var bProxy:BProxy = new BProxy();
		var cProxy:CProxy = new CProxy();
		var dProxy:DProxy = new DProxy();
		
		//----------------------------------
		//     Circular/pending proxy dependency test
		//----------------------------------
		
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
		
		//*
		
		mediatorMap.map(TestView, TestViewMediator);
		
		var testView:TestView = new TestView();
		mediatorMap.mediate(testView);
		
		// map proxies.
		proxyMap.map(aProxy);
		proxyMap.map(bProxy);
		proxyMap.map(cProxy);
		
		// unmap proxies.
		proxyMap.unmap(AProxy);
		proxyMap.unmap(BProxy);
		proxyMap.unmap(CProxy);
	
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