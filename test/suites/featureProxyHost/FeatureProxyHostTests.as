package suites.featureProxyHost {
import flash.display.Bitmap;
import flash.display.Sprite;
import org.flexunit.Assert;
import org.mvcexpress.base.MediatorMap;
import org.mvcexpress.base.ProxyMap;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.messenger.MessengerManager;
import org.mvcexpress.mvc.Mediator;
import org.mvcexpress.mvc.Proxy;
import org.mvcexpress.namespace.pureLegsCore;
import suites.featureProxyHost.testObjects.HostTestModuleSprite;
import suites.featureProxyHost.testObjects.localObjects.HostProxy;
import suites.featureProxyHost.testObjects.localObjects.HostProxySubclass;
import suites.featureProxyHost.testObjects.localObjects.LocalProxyWithGlobalInjection;
import suites.featureProxyHost.testObjects.localObjects.LocalProxyWithLocalInjection;
import suites.featureProxyHost.testObjects.remoteModule.OneDependencyRemoteModule;
import suites.mediatorMap.medatorMaptestObj.MediatorMapTestSprite;
import suites.mediatorMap.medatorMaptestObj.MediatorMapTestSpriteMediator;
import suites.mediators.mediatorObj.MediatorSprite;
import suites.mediators.mediatorObj.MediatorSpriteMediator;
import utils.AsyncUtil;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class FeatureProxyHostTests {
	private var moduleSprite:HostTestModuleSprite;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		moduleSprite = new HostTestModuleSprite();
		HostProxy.instances = Vector.<Proxy>([]);
		LocalProxyWithLocalInjection.injectedProxy = null;
		LocalProxyWithGlobalInjection.injectedProxy = null;
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		moduleSprite.unhostTestProxy(HostProxy);
		moduleSprite = null;
	}
	
	[Test(description="just hosting")]
	
	public function featureHostProxy_just_hosting_no_proxy_created():void {
		
		moduleSprite.hostTestProxy(HostProxy);
		Assert.assertEquals("Hosting a proxy should not create any new proxies.", HostProxy.instances.length, 0);
	}
	
	// local injection should work
	
	[Test(description="hosting local injection, inject localy without hosting")]
	
	public function featureHostProxy_hosting_local_dependency_normaly():void {
		
		var hostProxy:HostProxy = new HostProxy()
		
		moduleSprite.hostTestProxy(HostProxy);
		moduleSprite.mapProxy(hostProxy);
		
		moduleSprite.mapProxy(new LocalProxyWithLocalInjection());
		
		Assert.assertStrictlyEquals("Host proxy must be injected in local modules WITHOUT isHosted set to true.", LocalProxyWithLocalInjection.injectedProxy, hostProxy);
		Assert.assertEquals("Hosting a proxy should create one new proxy.", HostProxy.instances.length, 1);
	}
	
	[Test(description="hosting local injection, inject with hosting ")]
	
	public function featureHostProxy_hosting_local_dependency_globaly():void {
		
		var hostProxy:HostProxy = new HostProxy()
		
		moduleSprite.hostTestProxy(HostProxy);
		moduleSprite.mapProxy(hostProxy);
		
		moduleSprite.mapProxy(new LocalProxyWithGlobalInjection());
		
		Assert.assertStrictlyEquals("Host proxy must be injected in local modules WITH isHosted set to true.", LocalProxyWithGlobalInjection.injectedProxy, hostProxy);
		Assert.assertEquals("Hosting a proxy should create one new proxy.", HostProxy.instances.length, 1);
	}
	
	[Test(description="hosting with single dependency created in future, first map, then host")]
	
	public function featureHostProxy_map_then_host_then_dependency_in_future():void {
		
		var hostProxy:HostProxy = new HostProxy();
		
		moduleSprite.mapProxy(hostProxy);
		moduleSprite.hostTestProxy(HostProxy);
		
		var oneDependencyModule:OneDependencyRemoteModule = new OneDependencyRemoteModule();
		oneDependencyModule.createFirstProxy();
		oneDependencyModule.mapFirstProxy();
		
		Assert.assertStrictlyEquals("Host proxy must be injected in remote modules, then mapping is done before hasting.", hostProxy, oneDependencyModule.getProxyHostDependency());
	}
	
	[Test(description="hosting with single dependency created in future, first host, then map")]
	
	public function featureHostProxy_host_then_map_then_dependency_in_future():void {
		
		var hostProxy:HostProxy = new HostProxy()
		
		moduleSprite.hostTestProxy(HostProxy);
		moduleSprite.mapProxy(hostProxy);
		
		var oneDependencyModule:OneDependencyRemoteModule = new OneDependencyRemoteModule();
		oneDependencyModule.createFirstProxy();
		oneDependencyModule.mapFirstProxy();
		
		Assert.assertStrictlyEquals("Host proxy must be injected in remote modules, then hosting is done before mapping.", hostProxy, oneDependencyModule.getProxyHostDependency());
	}
	
	[Test(expects="Error",description="hosting same class twice shloud throw error.")]
	
	public function featureHostProxy_host_same_class_twice_fails():void {
		
		var hostProxy:HostProxy = new HostProxy()
		
		moduleSprite.hostTestProxy(HostProxy);
		moduleSprite.hostTestProxy(HostProxy);
	}
	
	[Test(expects="Error",description="hosting same object with diferent class shloud throm error.")]
	
	public function featureHostProxy_host_then_map_two_same_objects_fails():void {
		
		var hostProxy:HostProxy = new HostProxy()
		
		moduleSprite.hostTestProxy(HostProxy);
		
		moduleSprite.mapProxy(hostProxy);
		moduleSprite.mapProxy(hostProxy);
	}
	
	
	[Test(expects="Error",description="hosting same object with diferent class subclasses shloud throm error.")]
	
	public function featureHostProxy_host_two_same_class_diferent_subclasses_fails():void {
		
		var hostProxy:HostProxySubclass = new HostProxySubclass()
		
		moduleSprite.hostTestProxy(HostProxy);
		moduleSprite.hostTestProxy(HostProxySubclass);
		
		moduleSprite.mapProxy(hostProxy as HostProxy);
		moduleSprite.mapProxy(hostProxy as HostProxySubclass);
	}
	
	
	
	
	

/*
   [Test(async,description="Mediator onRemove test")]

   public function mediatorMap_onRegister_and_onRemove():void {
   MediatorMapTestSpriteMediator.REGISTER_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 300, callBackFail);
   MediatorMapTestSpriteMediator.REMOVE_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 300, callBackFail);
   mediatorMap.map(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
   var view:MediatorMapTestSprite = new MediatorMapTestSprite();
   mediatorMap.mediate(view);
   mediatorMap.unmediate(view);
   }

   [Test(async,description="Mediator onRemove test")]

   public function mediatorMap_messag_callBack_test():void {
   MediatorMapTestSpriteMediator.CALLBACK_TEST_FUNCTION = AsyncUtil.asyncHandler(this, callBackSuccess, null, 300, callBackFail);
   mediatorMap.map(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
   var view:MediatorMapTestSprite = new MediatorMapTestSprite();
   mediatorMap.mediate(view);

   messenger.send(MediatorMapTestSpriteMediator.TEST_MESSAGE_TYPE);
   }

   //----------------------------------
   //     isMapped()
   //----------------------------------

   [Test]

   public function debug_test_isMapped_false_wrong_view():void {
   mediatorMap.map(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
   Assert.assertFalse("isMapped() should retturn false with NOT mapped view class.", mediatorMap.isMapped(MediatorSprite, MediatorMapTestSpriteMediator));
   }

   [Test]

   public function debug_test_isMapped_false_wrong_mediator():void {
   mediatorMap.map(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
   Assert.assertFalse("isMapped() should retturn false with NOT mapped mediator class to view.", mediatorMap.isMapped(MediatorMapTestSprite, MediatorSpriteMediator));
   }

   [Test]

   public function debug_test_isMapped_true():void {
   mediatorMap.map(MediatorMapTestSprite, MediatorMapTestSpriteMediator);
   Assert.assertTrue("isMapped() should retturn true with mapped view class to mediator class.", mediatorMap.isMapped(MediatorMapTestSprite, MediatorMapTestSpriteMediator));
   }

   [Test(expects="Error")]

   public function debug_map_not_mediator_fails():void {
   var errorChecked:Boolean = false;
   CONFIG::debug {
   errorChecked = true;
   mediatorMap.map(Sprite, Bitmap);
   }
   if (!errorChecked) {
   Assert.fail("fake error")
   }
   }

   //----------------------------------
   //
   //----------------------------------
   private function callBackFail(obj:* = null):void {
   Assert.fail("CallBack should not be called...");
   }

   public function callBackSuccess(obj:* = null):void {
   }

   //----------------------------------
   //
   //----------------------------------
   private function callBackCheck(obj:* = null):void {
   //trace( "ControllerTests.callBackCheck > obj : " + obj );
   if (callCaunter != callsExpected) {
   Assert.fail("Expected " + callsExpected + " calls, but " + callCaunter + " was received...");
   }
   }

   public function callBackIncrease(obj:* = null):void {
   //trace( "ControllerTests.callBackIncrease > obj : " + obj );
   callCaunter++;
   }
 */
}
}