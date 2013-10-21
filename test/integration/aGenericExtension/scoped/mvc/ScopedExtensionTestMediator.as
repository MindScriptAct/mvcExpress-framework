package integration.aGenericExtension.scoped.mvc {
import flash.display.Sprite;

import mvcexpress.extensions.scoped.mvc.MediatorScoped;

/**
 * TODO:CLASS COMMENT
 * @author Deril
 */
public class ScopedExtensionTestMediator extends MediatorScoped {

	[Inject]
	public var view:Sprite;

	override protected function onRegister():void {

	}

	override protected function onRemove():void {
		trace("Warning: LiveExtensionTestMediator onRemove() is not implemented!");
	}
}
}