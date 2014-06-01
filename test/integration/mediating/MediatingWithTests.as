package integration.mediating {
import flexunit.framework.Assert;

import integration.aframworkHelpers.ProxyMapCleaner;
import integration.mediating.testObj.*;
import integration.mediating.testObj.view.*;
import integration.mediating.testObj.view.viewObj.*;

import mvcexpress.core.*;

public class MediatingWithTests {
	private var mediatingModule:MediatingModule;
	private var mediatorMap:MediatorMap;

	[Before]

	public function runBeforeEveryTest():void {
		mediatingModule = new MediatingModule();
		mediatorMap = mediatingModule.getMediatorMap();
	}

	[After]

	public function runAfterEveryTest():void {
		mediatorMap = null;
		mediatingModule.disposeModule();
		mediatingModule = null;
		MediatingTestingVars.timesRegistered = 0;
		MediatingTestingVars.viewObject = null;

		ProxyMapCleaner.clear();
	}


	[Test(expects="Error")]

	public function mediatingWith_mediateWrongClass_fails():void {
		var view:MediatingWrongView = new MediatingWrongView();
		mediatorMap.mediateWith(view, MediatingBaseViewMediator);
	}


	//--------------------------------------------------------------------------
	//
	//      Inject mediator as another class
	//
	//--------------------------------------------------------------------------

	[Test]

	public function mediating_mediatingWithAsInterface_ok():void {
		var view:MediatingView = new MediatingView();
		mediatorMap.mediateWith(view, MediatingBaseViewMediator, MediatingBaseView);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediating_mediatingWithAsSuperClass_ok():void {
		var view:MediatingView = new MediatingView();
		mediatorMap.mediateWith(view, MediatingIViewMediator, IMediatingView);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test(expects="Error")]

	public function mediating_mediatingWithAsWrongClass_fails():void {
		var view:MediatingWrongView = new MediatingWrongView();
		mediatorMap.mediateWith(view, MediatingIViewMediator, IMediatingView);
	}

}
}