package suites {
import suites.commandMap.CommandMapTests;
import suites.mediatorMap.MediatorMapTests;
import suites.mediators.MediatorTests;
import suites.messenger.MessengerTests;
import suites.modelMap.ModelMapTests;
import suites.modelMap.NamedInterfacedModelMapTests;
import suites.models.ModelTests;

/**
 * COMMENT
 * @author rbanevicius
 */

[Suite]
[RunWith("org.flexunit.runners.Suite")]

public class AllTestSuites {
	
	public var messengerTests:MessengerTests;
	
	public var modelMapTests:ModelMapTests;
	
	public var namedAndInterfacedModelMapNameTests:NamedInterfacedModelMapTests;
	
	public var mediatorMapTests:MediatorMapTests;

	public var controllerTests:CommandMapTests;

	// TODO: public var commandTests:CommandsTests;

	// TODO: public var modelTests:ModelTests;

	public var mediatorTests:MediatorTests;
	
	
	// TODO : public var modularTests:ModularTests;

}

}