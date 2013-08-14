package {
import integration.commandPooling.CommandPoolingTests;
import integration.extensionChecking.ExtensionCheckingTests;
import integration.lazyProxy.LazyProxyTests;
import integration.mediating.MediatingTests;
import integration.moduleInitTests.ModuleInitTests;
import integration.proxyMap.ProxyMapTests;
import integration.scopeControl.ScopeControlTests;
import integration.scopedMessaging.ChannelingTests;
import integration.scopedProxy.ScopedProxyTests;

import suites.commandMap.CommandMapTests;
import suites.fatureGetProxy.FeatureGetProxyTests;
import suites.general.GeneralTests;
import suites.mediatorMap.MediatorMapTests;
import suites.mediators.MediatorTests;
import suites.messenger.MessengerTests;
import suites.modules.ModularTests;
import suites.proxyMap.NamedInterfacedProxyMapTests;
import suites.proxyMap.OldProxyMapTests;
import suites.utils.UtilsTests;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */

[Suite]
[RunWith("org.flexunit.runners.Suite")]

public class AllTestSuites {

	/*

	public var generalTests:GeneralTests;

	public var moduleInitTests:ModuleInitTests;

	public var messengerTests:MessengerTests;

	public var oldProxyMapTests:OldProxyMapTests;

	public var namedAndInterfacedProxyMapNameTests:NamedInterfacedProxyMapTests;

	public var mediatorMapTests:MediatorMapTests;

	public var modularTests:ModularTests;

	public var utilsTests:UtilsTests;

	public var featureGetProxyTest:FeatureGetProxyTests;

	public var mediatorTests:MediatorTests;


	public var lazyProxyTests:LazyProxyTests;

	public var mediatingTests:MediatingTests;

	public var controllerTests:CommandMapTests;

	public var commandPoolingTests:CommandPoolingTests;

	public var proxyMapTests:ProxyMapTests;


	//*/

	/*

	public var scopeControllTest:ScopeControlTests;

	public var channelingTests:ChannelingTests;

	public var scopedProxyTests:ScopedProxyTests;

	//*/

	public var extensionCheckingTests:ExtensionCheckingTests;

}

}