package integration.aGenericExtension.live.mvc {
import mvcexpress.extensions.live.mvc.ProxyLive;

/**
 * TODO:CLASS COMMENT
 * @author Deril
 */
public class LiveExtensionTestProxy extends ProxyLive {

	public function LiveExtensionTestProxy() {
	}

	override protected function onRegister():void {

	}

	override protected function onRemove():void {
		trace("Warning: LiveExtensionTestProxy onRemove() not implemented!");
	}

}
}