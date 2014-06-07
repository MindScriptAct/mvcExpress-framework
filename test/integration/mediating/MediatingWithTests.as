package integration.mediating {
import flash.display.Sprite;

import flexunit.framework.Assert;

import integration.aframworkHelpers.ProxyMapCleaner;
import integration.mediating.testObj.*;
import integration.mediating.testObj.view.*;
import integration.mediating.testObj.view.chain.MediatingChainBaseViewMediator;
import integration.mediating.testObj.view.chain.MediatingChainIViewMediator;
import integration.mediating.testObj.view.chain.MediatingChainViewMediator;
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

	//--------------------------------------------------------------------------
	//
	//      mediating without mapping - fails
	//
	//--------------------------------------------------------------------------

	[Test(expects="Error")]
	public function mediatingWith_baseView_WithoutMapping_fails():void {
		var view:MediatingBaseView = new MediatingBaseView();
		mediatorMap.mediateWith(view, Sprite);
	}


	[Test(expects="Error")]
	public function mediatingWith_view_WithoutMapping_fails():void {
		var view:MediatingView = new MediatingView();
		mediatorMap.mediateWith(view, Sprite);
	}

	//--------------------------------------------------------------------------
	//
	//      mediating wrong class.
	//
	//--------------------------------------------------------------------------
	[Test(expects="Error")]

	public function mediatingWith_mediatingAsWrongClass_fails():void {
		var view:MediatingWrongView = new MediatingWrongView();
		mediatorMap.mediateWith(view, MediatingIViewMediator);
	}

	//--------------------------------------------------------------------------
	//
	//      simple mediating (1 view - 1 mediator)
	//
	//--------------------------------------------------------------------------

	[Test]

	public function mediatingWith_baseView_baseViewMediator_ok():void {
		var view:MediatingBaseView = new MediatingBaseView();
		mediatorMap.mediateWith(view, MediatingBaseViewMediator);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediatingWith_view_viewMediator_ok():void {
		var view:MediatingView = new MediatingView();
		mediatorMap.mediateWith(view, MediatingViewMediator);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediatingWith_baseView_chainBaseViewMediator_ok():void {
		var view:MediatingBaseView = new MediatingBaseView();
		mediatorMap.mediateWith(view, MediatingChainBaseViewMediator);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test(expects="Error")]

	public function mediatingWith_view_chainViewMediator_fails():void {
		var view:MediatingBaseView = new MediatingView();
		mediatorMap.mediateWith(view, MediatingChainViewMediator);
	}

	//--------------------------------------------------------------------------
	//
	//      mediating view as another class
	//
	//--------------------------------------------------------------------------

	[Test]

	public function mediatingWith_view_mediatingAsView_ok():void {
		var view:MediatingView = new MediatingView();
		mediatorMap.mediateWith(view, MediatingViewMediator, MediatingView);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test(expects="Error")]

	public function mediatingWith_view_mediatingAsChainView_ok():void {
		var view:MediatingView = new MediatingView();
		mediatorMap.mediateWith(view, MediatingChainViewMediator, MediatingView);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediatingWith_view_mediatingAsBase_ok():void {
		var view:MediatingView = new MediatingView();
		mediatorMap.mediateWith(view, MediatingBaseViewMediator, MediatingBaseView);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediatingWith_view_mediatingAsChainBase_ok():void {
		var view:MediatingView = new MediatingView();
		mediatorMap.mediateWith(view, MediatingChainBaseViewMediator, MediatingBaseView);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}


	//--------------------------------------------------------------------------
	//
	//      mediating view as interface
	//
	//--------------------------------------------------------------------------

	[Test]

	public function mediatingWith_baseView_asInterface_interfaceViewMediator_ok():void {
		var view:MediatingBaseView = new MediatingBaseView();
		mediatorMap.mediateWith(view, MediatingIViewMediator, IMediatingView);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediatingWith_view_asInterface_interfaceViewMediator_ok():void {
		var view:MediatingView = new MediatingView();
		mediatorMap.mediateWith(view, MediatingIViewMediator, IMediatingView);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test(expects="Error")]

	public function mediatingWith_baseView_asInterface_interfaceChainViewMediator_ok():void {
		var view:MediatingBaseView = new MediatingBaseView();
		mediatorMap.mediateWith(view, MediatingChainIViewMediator, IMediatingView);
	}

	[Test(expects="Error")]

	public function mediatingWith_view_asInterface_interfaceChainViewMediator_ok():void {
		var view:MediatingView = new MediatingView();
		mediatorMap.mediateWith(view, MediatingChainIViewMediator, IMediatingView);
	}

	//--------------------------------------------------------------------------
	//
	//      mediating view with multiple mediators.
	//
	//--------------------------------------------------------------------------

	[Test]

	public function mediatingWith_view_baseAndViewMediator_ok():void {
		var view:MediatingView = new MediatingView();
		mediatorMap.mediateWith(view, MediatingViewMediator, MediatingView, MediatingBaseViewMediator, MediatingBaseView);
		Assert.assertEquals("Mediator should be mediated and registered twice.", 2, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediatingWith_view_baseAndViewAndInterfaceMediator_ok():void {
		var view:MediatingView = new MediatingView();
		mediatorMap.mediateWith(view, MediatingViewMediator, MediatingView, MediatingBaseViewMediator, MediatingBaseView, MediatingIViewMediator, IMediatingView);
		Assert.assertEquals("Mediator should be mediated and registered three times.", 3, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	//--------------------------------------------------------------------------
	//
	//      mediating view with one mediator, but injecting as different classes.
	//
	//--------------------------------------------------------------------------


	[Test]

	public function mediatingWith_view_asViewAndBase_inChainMediator_ok():void {
		var view:MediatingView = new MediatingView();
		mediatorMap.mediateWith(view, MediatingChainViewMediator, MediatingView, MediatingBaseView);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediatingWith_view_asBaseAndView_inChainMediator_ok():void {
		var view:MediatingView = new MediatingView();
		mediatorMap.mediateWith(view, MediatingChainViewMediator, MediatingBaseView, MediatingView);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]

	public function mediatingWith_view_asBaseAndView_inChainInterfaceMediator_ok():void {
		var view:MediatingView = new MediatingView();
		mediatorMap.mediateWith(view, MediatingChainIViewMediator, MediatingBaseView, MediatingView, IMediatingView);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	//--------------------------------------------------------------------------
	//
	//      mediating view with many mediators and injecting as different classes
	//
	//--------------------------------------------------------------------------

	[Test]
	public function mediatingWith_view_asBaseAndView_inChainInterfaceMediator_AND_baseAndViewAndInterfaceMediator_ok():void {
		var view:MediatingView = new MediatingView();
		mediatorMap.mediateWith(view,
				MediatingChainIViewMediator, MediatingBaseView, MediatingView, IMediatingView, //
				MediatingViewMediator, MediatingView, //
				MediatingBaseViewMediator, MediatingBaseView, //
				MediatingIViewMediator, IMediatingView); //
		Assert.assertEquals("Mediator should be mediated and registered four times.", 4, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}

	[Test]
	public function mediatingWith_view_baseAndViewAndInterfaceMediator_AND_asBaseAndView_inChainInterfaceMediator_ok():void {
		mediatorMap.mediateWith(view, //
				MediatingViewMediator, MediatingView, //
				MediatingBaseViewMediator, MediatingBaseView, //
				MediatingIViewMediator, IMediatingView, //
				MediatingChainIViewMediator, MediatingBaseView, MediatingView, IMediatingView);
		var view:MediatingView = new MediatingView();
		Assert.assertEquals("Mediator should be mediated and registered fore times.", 4, MediatingTestingVars.timesRegistered);
		Assert.assertEquals("Mediator view should be injected.", view, MediatingTestingVars.viewObject);
	}


}
}