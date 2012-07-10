package suites {
import suites.commandMap.CommandMapTests;
import suites.featureProxyHost.FeatureProxyHostTests;
import suites.mediatorMap.MediatorMapTests;
import suites.mediators.MediatorTests;
import suites.messenger.MessengerTests;
import suites.proxyMap.ProxyMapTests;
import suites.proxyMap.NamedInterfacedProxyMapTests;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */

[Suite]
[RunWith("org.flexunit.runners.Suite")]

public class AllTestSuites {
	
	/*
	public var messengerTests:MessengerTests;
	
	public var proxyMapTests:ProxyMapTests;
	
	public var namedAndInterfacedProxyMapNameTests:NamedInterfacedProxyMapTests;
	
	public var mediatorMapTests:MediatorMapTests;

	public var controllerTests:CommandMapTests;

	// TODO: public var commandTests:CommandsTests;

	// TODO: public var proxyTests:ProxyTests;

	public var mediatorTests:MediatorTests;
	
	
	// TODO : public var modularTests:ModularTests;
	
	//*/
	
	
	public var mediatorTests:FeatureProxyHostTests;

}

}