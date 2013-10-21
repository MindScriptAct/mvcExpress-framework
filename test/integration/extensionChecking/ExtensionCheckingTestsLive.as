package integration.extensionChecking {
import integration.aGenericExtension.fake.core.FakeExtensionMessenger;
import integration.aGenericExtension.fake.module.FakeExtensionModule;
import integration.aGenericExtension.live.GenericLiveExtensionModule;
import integration.aGenericExtension.live.mvc.LiveExtensionTestCommand;
import integration.aGenericExtension.live.mvc.LiveExtensionTestMediator;
import integration.aGenericExtension.live.mvc.LiveExtensionTestProxy;

import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.live.core.CommandMapLive;
import mvcexpress.extensions.live.core.MediatorMapLive;
import mvcexpress.extensions.live.core.ProxyMapLive;
import mvcexpress.extensions.live.modules.ModuleLive;

/**
 * COMMENT
 * @author
 */
public class ExtensionCheckingTestsLive extends ExtensionCheckingTestsBase {


	public function ExtensionCheckingTestsLive() {


		CONFIG::debug {
			use namespace pureLegsCore;

			FakeExtensionModule.EXTENSION_TEST_ID = ModuleLive.EXTENSION_LIVE_ID;
		}

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