package integration.extensionChecking {
import integration.aGenericExtension.GenericTestExtensionModule;
import integration.aGenericExtension.core.CommandMapExtensionTest;
import integration.aGenericExtension.core.MediatorMapExtensionTest;
import integration.aGenericExtension.core.MessengerExtensionTest;
import integration.aGenericExtension.core.ProxyMapExtensionTest;
import integration.aGenericExtension.mvc.CommnadExstensionTest;
import integration.aGenericExtension.mvc.MediatorExtensionTest;
import integration.aGenericExtension.mvc.ProxyExtensionTest;

/**
 * COMMENT
 * @author
 */
public class ExtensionCheckingTestsGeneral extends ExtensionCheckingTestsBase {


	public function ExtensionCheckingTestsGeneral() {


		extensionModuleClass = GenericTestExtensionModule;

		extensionCommandMapClass = CommandMapExtensionTest;
		extensionProxyMapClass = ProxyMapExtensionTest;
		extensionMediatorMapClass = MediatorMapExtensionTest;

		extensionMessendegClass = MessengerExtensionTest;

		extensionCommandClass = CommnadExstensionTest;
		extensionProxyClass = ProxyExtensionTest;
		extensionMediatorClass = MediatorExtensionTest;


	}

}
}