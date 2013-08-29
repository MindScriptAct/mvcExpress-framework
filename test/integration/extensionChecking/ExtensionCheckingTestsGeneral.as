package integration.extensionChecking {
import integration.aGenericExtension.fake.GenericFakeExtensionModule;
import integration.aGenericExtension.fake.core.FakeExtensionCommandMap;
import integration.aGenericExtension.fake.core.FakeExtensionMediatorMap;
import integration.aGenericExtension.fake.core.FakeExtensionMessenger;
import integration.aGenericExtension.fake.core.FakeExtensionProxyMap;
import integration.aGenericExtension.fake.mvc.FakeExtensionTestCommand;
import integration.aGenericExtension.fake.mvc.FakeExtensionTestMediator;
import integration.aGenericExtension.fake.mvc.FakeExtensionTestProxy;

/**
 * COMMENT
 * @author
 */
public class ExtensionCheckingTestsGeneral extends ExtensionCheckingTestsBase {


	public function ExtensionCheckingTestsGeneral() {


		extensionModuleClass = GenericFakeExtensionModule;

		extensionCommandMapClass = FakeExtensionCommandMap;
		extensionProxyMapClass = FakeExtensionProxyMap;
		extensionMediatorMapClass = FakeExtensionMediatorMap;

		extensionMessendegClass = FakeExtensionMessenger;

		extensionCommandClass = FakeExtensionTestCommand;
		extensionProxyClass = FakeExtensionTestProxy;
		extensionMediatorClass = FakeExtensionTestMediator;


	}

}
}