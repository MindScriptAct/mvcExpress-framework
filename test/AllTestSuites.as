package  {
import integration.lazyProxy.LazyProxyTests;
import integration.scopedMessaging.ChannelingTests;
import integration.scopedProxy.ScopedProxyTests;
import suites.commandMap.CommandMapTests;
import suites.commands.CommandsTests;
import suites.fatureGetProxy.FeatureGetProxyTests;
import suites.general.GeneralTests;
import suites.mediatorMap.MediatorMapTests;
import suites.mediators.MediatorTests;
import suites.messenger.MessengerTests;
import suites.modules.ModularTests;
import suites.proxies.ProxyTests;
import suites.proxyMap.NamedInterfacedProxyMapTests;
import suites.proxyMap.ProxyMapTests;
import suites.utils.UtilsTests;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */

[Suite]
[RunWith("org.flexunit.runners.Suite")]

public class AllTestSuites {
	
	//*
	
	public var generalTests:GeneralTests;
	
	public var messengerTests:MessengerTests;
	
	public var proxyMapTests:ProxyMapTests;
	
	public var namedAndInterfacedProxyMapNameTests:NamedInterfacedProxyMapTests;
	
	public var mediatorMapTests:MediatorMapTests;
	
	public var controllerTests:CommandMapTests;
	
	//public var commandTests:CommandsTests;
	
	//public var proxyTests:ProxyTests;
	
	public var modularTests:ModularTests;
	
	public var utilsTests:UtilsTests;
	
	public var featureGetProxyTest:FeatureGetProxyTests;
	
	
	public var mediatorTests:MediatorTests;

	public var channelingTests:ChannelingTests;

	public var scopedProxyTests:ScopedProxyTests;
	
	
	//*/
	
	
	public var lazyProxyTests:LazyProxyTests;


}

}