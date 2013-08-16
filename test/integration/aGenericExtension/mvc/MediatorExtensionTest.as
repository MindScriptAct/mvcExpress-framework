package integration.aGenericExtension.mvc {
import flash.display.Sprite;

import mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class MediatorExtensionTest extends Mediator {

	[Inject]
	public var view:Sprite;

	override protected function onRegister():void {

	}

	override protected function onRemove():void {

	}
}
}