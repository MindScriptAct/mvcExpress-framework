package integration.extensionChecking {
import integration.aGenericExtension.fake.GenericFakeExtensionModule;
import integration.aGenericExtension.fake.core.FakeExtensionCommandMap;
import integration.aGenericExtension.fake.core.FakeExtensionMediatorMap;
import integration.aGenericExtension.fake.core.FakeExtensionMessenger;
import integration.aGenericExtension.fake.core.FakeExtensionProxyMap;
import integration.aGenericExtension.fake.module.FakeExtensionModule;
import integration.aGenericExtension.fake.mvc.FakeExtensionTestCommand;
import integration.aGenericExtension.fake.mvc.FakeExtensionTestMediator;
import integration.aGenericExtension.fake.mvc.FakeExtensionTestProxy;

import mvcexpress.core.ExtensionManager;

import mvcexpress.core.namespace.pureLegsCore;

/**
 * COMMENT
 * @author
 */
public class ExtensionCheckingTestsGeneral extends ExtensionCheckingTestsBase {


	public function ExtensionCheckingTestsGeneral() {


		use namespace pureLegsCore;
		CONFIG::debug {
			FakeExtensionModule.EXTENSION_TEST_ID = ExtensionManager.getExtensionIdByName(FakeExtensionModule.EXTENSION_TEST_NAME);
		}		
		

		extensionModuleClass = GenericFakeExtensionModule; 		// FAKE

		extensionCommandMapClass = FakeExtensionCommandMap; 	// FAKE
		extensionProxyMapClass = FakeExtensionProxyMap; 		// FAKE
		extensionMediatorMapClass = FakeExtensionMediatorMap; 	// FAKE

		extensionMessendegClass = FakeExtensionMessenger; 		// FAKE

		extensionCommandClass = FakeExtensionTestCommand; 		// FAKE
		extensionProxyClass = FakeExtensionTestProxy; 			// FAKE
		extensionMediatorClass = FakeExtensionTestMediator;		 // FAKE


	}

}
}