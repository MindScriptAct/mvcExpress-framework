package integration.mediating {
import flexunit.framework.Assert;

import integration.aframworkHelpers.ProxyMapCleaner;
import integration.mediating.testObj.*;
import integration.mediating.testObj.view.*;
import integration.mediating.testObj.view.chain.MediatingChainBaseViewMediator;
import integration.mediating.testObj.view.chain.MediatingChainIViewMediator;
import integration.mediating.testObj.view.chain.MediatingChainViewMediator;
import integration.mediating.testObj.view.viewObj.*;

import mvcexpress.core.*;

public class MediatingTests {
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

	//--------------------------------------------------------------------------
	//
	//      mediating without mapping - fails
	//
	//--------------------------------------------------------------------------

	[Test(expects="Error")]
	public function mediating_baseView_WithoutMapping_fails():void {
		var view:MediatingBaseView = new MediatingBaseView();
		mediatorMap.mediate(view);
	}


	[Test(expects="Error")]
	public function mediating_view_WithoutMapping_fails():void {
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
	}

	//--------------------------------------------------------------------------
	//
	//      simple mediating (1 view - 1 mediator)
	//
	//--------------------------------------------------------------------------

	[Test]

	public function mediating_baseView_baseViewMediator_ok():void {
		mediatorMap.map(MediatingBaseView, MediatingBaseViewMediator);
		var view:MediatingBaseView = new MediatingBaseView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediating_view_viewMediator_ok():void {
		mediatorMap.map(MediatingView, MediatingViewMediator);
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediating_baseView_chainBaseViewMediator_ok():void {
		mediatorMap.map(MediatingBaseView, MediatingChainBaseViewMediator);
		var view:MediatingBaseView = new MediatingBaseView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test(expects="Error")]

	public function mediating_view_chainViewMediator_fails():void {
		mediatorMap.map(MediatingView, MediatingChainViewMediator);
		var view:MediatingBaseView = new MediatingView();
		mediatorMap.mediate(view);
	}

	//--------------------------------------------------------------------------
	//
	//      mediating view as something else
	//
	//--------------------------------------------------------------------------

	[Test]

	public function mediating_baseView_asInterface_interfaceViewMediator_ok():void {
		mediatorMap.map(MediatingBaseView, MediatingIViewMediator, IMediatingView);
		var view:MediatingBaseView = new MediatingBaseView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediating_view_asInterface_interfaceViewMediator_ok():void {
		mediatorMap.map(MediatingView, MediatingIViewMediator, IMediatingView);
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test(expects="Error")]

	public function mediating_baseView_asInterface_interfaceChainViewMediator_ok():void {
		mediatorMap.map(MediatingBaseView, MediatingChainIViewMediator, IMediatingView);
		var view:MediatingBaseView = new MediatingBaseView();
		mediatorMap.mediate(view);
	}

	[Test(expects="Error")]

	public function mediating_view_asInterface_interfaceChainViewMediator_ok():void {
		mediatorMap.map(MediatingView, MediatingChainIViewMediator, IMediatingView);
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
	}

	//--------------------------------------------------------------------------
	//
	//      mediating without mapping - fails
	//
	//--------------------------------------------------------------------------


	[Test(expects="Error")]

	public function mediating_mediateWrongClass_fails():void {
		mediatorMap.map(MediatingWrongView, MediatingBaseViewMediator);
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
	}

	//--------------------------------------------------------------------------
	//
	//      Inject mediator as another class
	//
	//--------------------------------------------------------------------------


	[Test]

	public function mediating_mediatingAsInterface_ok():void {
		mediatorMap.map(MediatingView, MediatingBaseViewMediator, MediatingBaseView);
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediating_mediatingAsSuperClass_ok():void {
		mediatorMap.map(MediatingView, MediatingIViewMediator, IMediatingView);
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}


	[Test(expects="Error")]

	public function mediating_mediatingAsWrongClass_fails():void {
		mediatorMap.map(MediatingWrongView, MediatingIViewMediator, IMediatingView);
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
	}

}
}