package integration.mediating {
import flexunit.framework.Assert;
import integration.mediating.testObj.*;
import integration.mediating.testObj.view.*;
import integration.mediating.testObj.view.viewObj.*;

import org.mvcexpress.core.*;

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
		MediatingBaseView.timesRegistered = 0;
	}
	
	
	
	[Test(expects="Error")]
	
	public function mediating_mediateWrongClass_fails():void {
		mediatorMap.map(MediatingWrongView, MediatingSuperClassMediator);
		var view:MediatingSubView = new MediatingSubView();
		mediatorMap.mediate(view);
	}
	
	[Test(expects="Error")]
	
	public function mediating_mediateWithWrongClass_fails():void {
		var view:MediatingWrongView = new MediatingWrongView();
		mediatorMap.mediateWith(view, MediatingSuperClassMediator);
	}	
	
	
	//--------------------------------------------------------------------------
	//
	//      Inject mediator as another class
	//
	//--------------------------------------------------------------------------
	
	
	[Test]
	
	public function mediating_mediatingAsInterface_ok():void {
		mediatorMap.map(MediatingSubView, MediatingSuperClassMediator, MediatingBaseView);
		var view:MediatingSubView = new MediatingSubView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingBaseView.timesRegistered);
	}
	
	[Test]
	
	public function mediating_mediatingAsSuperClass_ok():void {
		mediatorMap.map(MediatingSubView, MediatingInterfaceMediator, IMediatingIntefrace);
		var view:MediatingSubView = new MediatingSubView();
		mediatorMap.mediate(view);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingBaseView.timesRegistered);
	}
	
	[Test]
	
	public function mediating_mediatingWithAsInterface_ok():void {
		var view:MediatingSubView = new MediatingSubView();
		mediatorMap.mediateWith(view, MediatingSuperClassMediator, MediatingBaseView);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingBaseView.timesRegistered);
	}
	
	[Test]
	
	public function mediating_mediatingWithAsSuperClass_ok():void {
		var view:MediatingSubView = new MediatingSubView();
		mediatorMap.mediateWith(view, MediatingInterfaceMediator, IMediatingIntefrace);
		Assert.assertEquals("Mediator should be mediated and registered once.", 1, MediatingBaseView.timesRegistered);
	}
	
	
	
	[Test(expects="Error")]
	
	public function mediating_mediatingAsWrongClass_fails():void {
		mediatorMap.map(MediatingWrongView, MediatingInterfaceMediator, IMediatingIntefrace);
		var view:MediatingSubView = new MediatingSubView();
		mediatorMap.mediate(view);
	}
	
	[Test(expects="Error")]
	
	public function mediating_mediatingWithAsWrongClass_fails():void {
		var view:MediatingWrongView = new MediatingWrongView();
		mediatorMap.mediateWith(view, MediatingInterfaceMediator, IMediatingIntefrace);
	}

}
}