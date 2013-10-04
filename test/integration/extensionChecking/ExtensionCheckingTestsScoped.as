package integration.extensionChecking {
import integration.aGenericExtension.fake.core.FakeExtensionMediatorMap;
import integration.aGenericExtension.fake.core.FakeExtensionMessenger;
import integration.aGenericExtension.fake.module.FakeExtensionModule;
import integration.aGenericExtension.scoped.GenericScopedExtensionModule;
import integration.aGenericExtension.scoped.mvc.ScopedExtensionTestCommand;
import integration.aGenericExtension.scoped.mvc.ScopedExtensionTestMediator;
import integration.aGenericExtension.scoped.mvc.ScopedExtensionTestProxy;

import mvcexpress.core.namespace.pureLegsCore;

import mvcexpress.extensions.scoped.core.CommandMapScoped;
import mvcexpress.extensions.scoped.core.ProxyMapScoped;
import mvcexpress.extensions.scoped.modules.ModuleScoped;

/**
 * COMMENT
 * @author
 */
public class ExtensionCheckingTestsScoped extends ExtensionCheckingTestsBase {


	public function ExtensionCheckingTestsScoped() {

		CONFIG::debug {
			use namespace pureLegsCore;
			FakeExtensionModule.EXTENSION_TEST_ID = ModuleScoped.EXTENSION_SCOPED_ID;
		}

		extensionModuleClass = GenericScopedExtensionModule;

		extensionCommandMapClass = CommandMapScoped;
		extensionProxyMapClass = ProxyMapScoped;
		extensionMediatorMapClass = FakeExtensionMediatorMap; // FAKE

		extensionMessendegClass = FakeExtensionMessenger; // FAKE

		extensionCommandClass = ScopedExtensionTestCommand;
		extensionProxyClass = ScopedExtensionTestProxy;
		extensionMediatorClass = ScopedExtensionTestMediator;


	}

}
}