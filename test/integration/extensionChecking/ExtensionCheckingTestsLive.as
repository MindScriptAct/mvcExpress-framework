package integration.extensionChecking {
import integration.aGenericExtension.fake.module.FakeExtensionModule;
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

import mvcexpress.core.namespace.pureLegsCore;

import mvcexpress.extensions.live.core.CommandMapLive;
import mvcexpress.extensions.live.core.MediatorMapLive;
import mvcexpress.extensions.live.core.ProxyMapLive;
import mvcexpress.extensions.live.modules.ModuleLive;

import mvcexpress.extensions.live.mvc.CommandLive;
import mvcexpress.extensions.live.mvc.MediatorLive;
import mvcexpress.extensions.live.mvc.ProxyLive;

/**
 * COMMENT
 * @author
 */
public class ExtensionCheckingTestsLive extends ExtensionCheckingTestsBase {


	public function ExtensionCheckingTestsLive() {


		use namespace pureLegsCore;
		FakeExtensionModule.EXTENSION_TEST_ID = ModuleLive.EXTENSION_LIVE_ID;

		extensionModuleClass = GenericLiveExtensionModule;

		extensionCommandMapClass = CommandMapLive;
		extensionProxyMapClass = ProxyMapLive;
		extensionMediatorMapClass = MediatorMapLive;

		extensionMessendegClass = FakeExtensionMessenger; // FAKE

		extensionCommandClass = LiveExtensionTestCommand;
		extensionProxyClass = LiveExtensionTestProxy;
		extensionMediatorClass = LiveExtensionTestMediator;


	}

}
}