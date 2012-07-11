package suites.featureProxyHost {
import org.flexunit.Assert;
import org.mvcexpress.mvc.Proxy;
import suites.featureProxyHost.testObjects.HostTestModuleSprite;
import suites.featureProxyHost.testObjects.localObjects.HostProxy;
import suites.featureProxyHost.testObjects.localObjects.HostProxySubclass;
import suites.featureProxyHost.testObjects.localObjects.LocalProxyWithGlobalInjection;
import suites.featureProxyHost.testObjects.localObjects.LocalProxyWithLocalInjection;
import suites.featureProxyHost.testObjects.remoteModule.RemoteModule;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class FeatureProxyHostTests {
	private var moduleSprite:HostTestModuleSprite;
	private var remoteModule:RemoteModule;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		moduleSprite = new HostTestModuleSprite();
		remoteModule = new RemoteModule();
		HostProxy.instances = Vector.<Proxy>([]);
		LocalProxyWithLocalInjection.injectedProxy = null;
		LocalProxyWithGlobalInjection.injectedProxy = null;
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		moduleSprite.unhostTestProxy(HostProxy);
		moduleSprite.disposeModule();
		moduleSprite = null;
		remoteModule.disposeModule();
		remoteModule = null;
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
		
		remoteModule.createProxyWithHostedDependency();
		remoteModule.mapProxyWithHostedDependency();
		
		Assert.assertStrictlyEquals("Host proxy must be injected in remote modules, then mapping is done before hasting.", hostProxy, remoteModule.getProxyHostDependency());
	}
	
	[Test(description="hosting with single dependency created in future, first host, then map")]
	
	public function featureHostProxy_host_then_map_then_dependency_in_future():void {
		
		var hostProxy:HostProxy = new HostProxy()
		
		moduleSprite.hostTestProxy(HostProxy);
		moduleSprite.mapProxy(hostProxy);
		
		remoteModule.createProxyWithHostedDependency();
		remoteModule.mapProxyWithHostedDependency();
		
		Assert.assertStrictlyEquals("Host proxy must be injected in remote modules, then hosting is done before mapping.", hostProxy, remoteModule.getProxyHostDependency());
	}
	
	[Test(expects="Error",description="hosting with single dependency, but hosted dependency is not injectde properly, should fail")]
	
	public function featureHostProxy_host_then_map_then_wrong_dependency_inject_fails():void {
		
		var hostProxy:HostProxy = new HostProxy()
		
		moduleSprite.hostTestProxy(HostProxy);
		moduleSprite.mapProxy(hostProxy);
		
		remoteModule.createProxyWithNormalInject();
		remoteModule.mapProxyWithNormalInject();
	
	}
	
	[Test(expects="Error",description="hosting same class twice shloud throw error.")]
	
	public function featureHostProxy_host_same_class_twice_fails():void {
		
		var hostProxy:HostProxy = new HostProxy()
		
		moduleSprite.hostTestProxy(HostProxy);
		moduleSprite.hostTestProxy(HostProxy);
	}
	
	[Test(expects="Error",description="hosting same object with diferent class shloud throm error.")]
	
	public function featureHostProxy_host_then_map_two_same_objects_fails():void {
		
		var hostProxy:HostProxy = new HostProxy();
		
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
	
	[Test(expects="Error",description="2 diferent proxies shold not host and map hosted proxy")]
	
	public function featureHostProxy_host_two_diferent_modules_host_and_map_fails():void {
		
		var hostProxy:HostProxy = new HostProxy();
		
		moduleSprite.hostTestProxy(HostProxy);
		remoteModule.mapProxy(hostProxy);
	
	}
	
	[Test(expects="Error",description="2 diferent proxies shold not host and map hosted proxy")]
	
	//[Ignore]
	
	public function featureHostProxy_host_two_diferent_modules_map_and_host_fails():void {
		
		var hostProxy:HostProxy = new HostProxy();
		
		remoteModule.mapProxy(hostProxy);
		moduleSprite.hostTestProxy(HostProxy);
	}
	
	[Test(description="hosted proxy communication test.")]
	
	public function featureHostProxy_all_modules_get_proxy_event():void {
		
		var hostProxy:HostProxy = new HostProxy()
		
		moduleSprite.hostTestProxy(HostProxy);
		moduleSprite.mapProxy(hostProxy);
		
		remoteModule.createProxyWithHostedDependency();
		remoteModule.mapProxyWithHostedDependency();
		
		hostProxy.dataChange();
		
		Assert.assertTrue("Host module hosted proxy message must be handled", moduleSprite.messageHandled());
		Assert.assertTrue("Remote module hosted proxy message must be handled", remoteModule.messageHandled());
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