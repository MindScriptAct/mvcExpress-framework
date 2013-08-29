package integration.aGenericExtension.live.mvc {
import flash.display.Sprite;

import mvcexpress.extensions.live.mvc.MediatorLive;

/**
 * TODO:CLASS COMMENT
 * @author Deril
 */
public class LiveExtensionTestMediator extends MediatorLive {

	[Inject]
	public var view:Sprite;

	override protected function onRegister():void {

	}

	override protected function onRemove():void {
		trace("Warning: LiveExtensionTestMediator onRemove() is not implemented!");
	}
}
}