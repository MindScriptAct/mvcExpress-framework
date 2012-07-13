package suites.featureRemoteHandlerTests {

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class FeatureRemoteHandlerTests {

	
	[Before]
	
	public function runBeforeEveryTest():void {
	}
	
	[After]
	
	public function runAfterEveryTest():void {
	}
	
	[Test(description="just hosting")]
	
	public function featureHostProxy_just_hosting_no_proxy_created():void {
	
		//moduleSprite.hostTestProxy(new HostProxy());
		//Assert.assertEquals("Hosting a proxy should not create any new proxies.", HostProxy.instances.length, 0);
	}
/*
   // local injection should work

   [Test(description="hosting local injection, inject localy without hosting")]

   public function featureHostProxy_hosting_local_dependency_normaly():void {

   var hostProxy:HostProxy = new HostProxy()

   moduleSprite.hostTestProxy(hostProxy);
   moduleSprite.mapProxy(hostProxy);

   moduleSprite.mapProxy(new LocalProxyWithLocalInjection());

   Assert.assertStrictlyEquals("Host proxy must be injected in local modules WITHOUT isHosted set to true.", LocalProxyWithLocalInjection.injectedProxy, hostProxy);
   Assert.assertEquals("Hosting a proxy should create one new proxy.", HostProxy.instances.length, 1);
   }

   [Test(description="hosting local injection, inject with hosting ")]

   public function featureHostProxy_hosting_local_dependency_globaly():void {

   var hostProxy:HostProxy = new HostProxy()

   moduleSprite.hostTestProxy(hostProxy);
   moduleSprite.mapProxy(hostProxy);

   moduleSprite.mapProxy(new LocalProxyWithGlobalInjection());

   Assert.assertStrictlyEquals("Host proxy must be injected in local modules WITH isHosted set to true.", LocalProxyWithGlobalInjection.injectedProxy, hostProxy);
   Assert.assertEquals("Hosting a proxy should create one new proxy.", HostProxy.instances.length, 1);
   }

   [Test(description="hosting with single dependency created in future, first map, then host")]

   public function featureHostProxy_map_then_host_then_dependency_in_future():void {

   var hostProxy:HostProxy = new HostProxy();

   moduleSprite.mapProxy(hostProxy);
   moduleSprite.hostTestProxy(hostProxy);

   remoteModule.createProxyWithHostedDependency();
   remoteModule.mapProxyWithHostedDependency();

   Assert.assertStrictlyEquals("Host proxy must be injected in remote modules, then mapping is done before hasting.", hostProxy, remoteModule.getProxyHostDependency());
   }

   [Test(description="hosting with single dependency created in future, first host, then map")]

   public function featureHostProxy_host_then_map_then_dependency_in_future():void {

   var hostProxy:HostProxy = new HostProxy()

   moduleSprite.hostTestProxy(hostProxy);
   moduleSprite.mapProxy(hostProxy);

   remoteModule.createProxyWithHostedDependency();
   remoteModule.mapProxyWithHostedDependency();

   Assert.assertStrictlyEquals("Host proxy must be injected in remote modules, then hosting is done before mapping.", hostProxy, remoteModule.getProxyHostDependency());
   }

   [Test(expects="Error",description="hosting with single dependency, but hosted dependency is not injectde properly, should fail")]

   public function featureHostProxy_host_then_map_then_wrong_dependency_inject_fails():void {

   var hostProxy:HostProxy = new HostProxy()

   moduleSprite.hostTestProxy(hostProxy);
   moduleSprite.mapProxy(hostProxy);

   remoteModule.createProxyWithNormalInject();
   remoteModule.mapProxyWithNormalInject();

   }

   [Test(expects="Error",description="hosting same class twice shloud throw error.")]

   public function featureHostProxy_host_same_class_twice_fails():void {

   var hostProxy:HostProxy = new HostProxy()

   moduleSprite.hostTestProxy(hostProxy);
   moduleSprite.hostTestProxy(hostProxy);
   }

   [Test(expects="Error",description="hosting same object with diferent class shloud throm error.")]

   public function featureHostProxy_host_then_map_two_same_objects_fails():void {

   var hostProxy:HostProxy = new HostProxy();

   moduleSprite.hostTestProxy(hostProxy);

   moduleSprite.mapProxy(hostProxy);
   moduleSprite.mapProxy(hostProxy);
   }

   [Test(expects="Error",description="hosting same object with diferent class subclasses shloud throm error.")]

   public function featureHostProxy_host_two_same_class_diferent_subclasses_fails():void {

   var hostProxy:HostProxySubclass = new HostProxySubclass()

   moduleSprite.hostTestProxy(hostProxy);
   moduleSprite.hostTestProxy(hostProxy, HostProxySubclass);

   moduleSprite.mapProxy(hostProxy as HostProxy);

   throw Error("TODO");
   }

   [Test(expects="Error",description="2 diferent proxies shold not host and map hosted proxy")]

   public function featureHostProxy_host_two_diferent_modules_host_and_map_fails():void {

   var hostProxy:HostProxy = new HostProxy();

   moduleSprite.hostTestProxy(hostProxy);
   remoteModule.mapProxy(hostProxy);

   }

   [Test(expects="Error",description="2 diferent proxies shold not host and map hosted proxy")]

   public function featureHostProxy_two_diferent_modules_map_and_host_same_proxy_fails():void {

   var hostProxy:HostProxy = new HostProxy();

   remoteModule.mapProxy(hostProxy);
   moduleSprite.hostTestProxy(hostProxy);
   }

   [Test(expects="Error",description="2 diferent proxies shold not map and host hosted proxy")]

   public function featureHostProxy_two_diferent_modules_host_and_map_same_proxy_fails():void {

   var hostProxy:HostProxy = new HostProxy();

   moduleSprite.hostTestProxy(hostProxy);
   remoteModule.mapProxy(hostProxy);
   }


   [Test(description="hosted proxy communication test.")]

   public function featureHostProxy_all_modules_get_proxy_event():void {

   var hostProxy:HostProxy = new HostProxy()

   moduleSprite.hostTestProxy(hostProxy);
   moduleSprite.mapProxy(hostProxy);

   remoteModule.createProxyWithHostedDependency();
   remoteModule.mapProxyWithHostedDependency();

   hostProxy.dataChange();

   Assert.assertTrue("Host module hosted proxy message must be handled", moduleSprite.messageHandled());
   Assert.assertTrue("Remote module hosted proxy message must be handled", remoteModule.messageHandled());
   }

 */
}
}