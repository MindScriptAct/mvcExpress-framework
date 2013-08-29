package integration.aGenericExtension.scoped.mvc {
import mvcexpress.extensions.live.mvc.ProxyLive;
import mvcexpress.extensions.scoped.mvc.ProxyScoped;

/**
 * TODO:CLASS COMMENT
 * @author Deril
 */
public class ScopedExtensionTestProxy extends ProxyScoped {

	public function ScopedExtensionTestProxy() {
	}

	override protected function onRegister():void {

	}

	override protected function onRemove():void {
		trace("Warning: LiveExtensionTestProxy onRemove() not implemented!");
	}

}
}