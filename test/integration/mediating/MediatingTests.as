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
	//      mediating wrong class.
	//
	//--------------------------------------------------------------------------
	[Test(expects="Error")]

	public function mediating_mediatingAsWrongClass_fails():void {
		mediatorMap.map(MediatingWrongView, MediatingIViewMediator, IMediatingView);
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
	//      mediating view as another class
	//
	//--------------------------------------------------------------------------

	[Test]

	public function mediating_view_mediatingAsView_ok():void {
		mediatorMap.map(MediatingView, MediatingViewMediator, MediatingView);
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test(expects="Error")]

	public function mediating_view_mediatingAsChainView_ok():void {
		mediatorMap.map(MediatingView, MediatingChainViewMediator, MediatingView);
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediating_view_mediatingAsBase_ok():void {
		mediatorMap.map(MediatingView, MediatingBaseViewMediator, MediatingBaseView);
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediating_view_mediatingAsChainBase_ok():void {
		mediatorMap.map(MediatingView, MediatingChainBaseViewMediator, MediatingBaseView);
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}


	//--------------------------------------------------------------------------
	//
	//      mediating view as interface
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
	//      mediating view with multiple mediators.
	//
	//--------------------------------------------------------------------------

	[Test]

	public function mediating_view_baseAndViewMediator_ok():void {
		mediatorMap.map(MediatingView, MediatingViewMediator, MediatingView, MediatingBaseViewMediator, MediatingBaseView);
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered twice.", 2, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediating_view_baseAndViewAndInterfaceMediator_ok():void {
		mediatorMap.map(MediatingView, MediatingViewMediator, MediatingView, MediatingBaseViewMediator, MediatingBaseView, MediatingIViewMediator, IMediatingView);
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered three times.", 3, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	//--------------------------------------------------------------------------
	//
	//      mediating view with one mediator, but injecting as different classes.
	//
	//--------------------------------------------------------------------------


	[Test]

	public function mediating_view_asViewAndBase_inChainMediator_ok():void {
		mediatorMap.map(MediatingView, MediatingChainViewMediator, MediatingView, MediatingBaseView);
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediating_view_asBaseAndView_inChainMediator_ok():void {
		mediatorMap.map(MediatingView, MediatingChainViewMediator, MediatingBaseView, MediatingView);
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediating_view_asBaseAndView_inChainInterfaceMediator_ok():void {
		mediatorMap.map(MediatingView, MediatingChainIViewMediator, MediatingBaseView, MediatingView, IMediatingView);
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	//--------------------------------------------------------------------------
	//
	//      mediating view with many mediators and injecting as different classes
	//
	//--------------------------------------------------------------------------

	[Test]
	public function mediating_view_asBaseAndView_inChainInterfaceMediator_AND_baseAndViewAndInterfaceMediator_ok():void {
		mediatorMap.map(MediatingView,
				MediatingChainIViewMediator, MediatingBaseView, MediatingView, IMediatingView, //
				MediatingViewMediator, MediatingView, //
				MediatingBaseViewMediator, MediatingBaseView, //
				MediatingIViewMediator, IMediatingView); //

		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered four times.", 4, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]
	public function mediating_view_baseAndViewAndInterfaceMediator_AND_asBaseAndView_inChainInterfaceMediator_ok():void {
		mediatorMap.map(MediatingView, //
				MediatingViewMediator, MediatingView, //
				MediatingBaseViewMediator, MediatingBaseView, //
				MediatingIViewMediator, IMediatingView, //
				MediatingChainIViewMediator, MediatingBaseView, MediatingView, IMediatingView);
		var view:MediatingView = new MediatingView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered fore times.", 4, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}


}
}