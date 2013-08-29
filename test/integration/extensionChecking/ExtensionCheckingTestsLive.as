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

import mvcexpress.extensions.live.core.CommandMapLive;
import mvcexpress.extensions.live.core.MediatorMapLive;
import mvcexpress.extensions.live.core.ProxyMapLive;

import mvcexpress.extensions.live.mvc.CommandLive;
import mvcexpress.extensions.live.mvc.MediatorLive;
import mvcexpress.extensions.live.mvc.ProxyLive;

/**
 * COMMENT
 * @author
 */
public class ExtensionCheckingTestsLive extends ExtensionCheckingTestsBase {


	public function ExtensionCheckingTestsLive() {


		extensionModuleClass = GenericLiveExtensionModule;

		extensionCommandMapClass = CommandMapLive;
		extensionProxyMapClass = ProxyMapLive;
		extensionMediatorMapClass = MediatorMapLive;

		extensionMessendegClass = FakeExtensionMessenger;

		extensionCommandClass = LiveExtensionTestCommand;
		extensionProxyClass = LiveExtensionTestProxy;
		extensionMediatorClass = LiveExtensionTestMediator;


	}

}
}