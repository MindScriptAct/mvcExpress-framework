package integration.extensionChecking {
import integration.aGenericExtension.live.GenericLiveExtensionModule;
import integration.aGenericExtension.fake.GenericFakeExtensionModule;
import integration.aGenericExtension.fake.core.FakeExtensionCommandMap;
import integration.aGenericExtension.fake.core.FakeExtensionMediatorMap;
import integration.aGenericExtension.fake.core.FakeExtensionMessenger;
import integration.aGenericExtension.fake.core.FakeExtensionProxyMap;
import integration.aGenericExtension.fake.mvc.FakeExtensionTestCommand;
import integration.aGenericExtension.fake.mvc.FakeExtensionTestMediator;
import integration.aGenericExtension.fake.mvc.FakeExtensionTestProxy;
import integration.aGenericExtension.live.mvc.LiveExtensionTestCommand;
import integration.aGenericExtension.live.mvc.LiveExtensionTestMediator;
import integration.aGenericExtension.live.mvc.LiveExtensionTestProxy;
import integration.aGenericExtension.scoped.GenericScopedExtensionModule;
import integration.aGenericExtension.scoped.mvc.ScopedExtensionTestCommand;
import integration.aGenericExtension.scoped.mvc.ScopedExtensionTestMediator;
import integration.aGenericExtension.scoped.mvc.ScopedExtensionTestProxy;

import mvcexpress.core.messenger.Messenger;

import mvcexpress.extensions.live.core.CommandMapLive;
import mvcexpress.extensions.live.core.MediatorMapLive;
import mvcexpress.extensions.live.core.ProxyMapLive;

import mvcexpress.extensions.live.mvc.CommandLive;
import mvcexpress.extensions.live.mvc.MediatorLive;
import mvcexpress.extensions.live.mvc.ProxyLive;
import mvcexpress.extensions.scoped.core.CommandMapScoped;
import mvcexpress.extensions.scoped.core.ProxyMapScoped;

/**
 * COMMENT
 * @author
 */
public class ExtensionCheckingTestsScoped extends ExtensionCheckingTestsBase {


	public function ExtensionCheckingTestsScoped() {


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