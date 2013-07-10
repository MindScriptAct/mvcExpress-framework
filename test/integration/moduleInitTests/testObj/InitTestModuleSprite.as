package integration.moduleInitTests.testObj {
import mvcexpress.core.CommandMap;
import mvcexpress.core.MediatorMap;
import mvcexpress.core.ProxyMap;
import mvcexpress.modules.ModuleSprite;

/**
 * COMMENT : todo
 * @author mindscriptact
 */
public class InitTestModuleSprite extends ModuleSprite {

	static public const NAME:String = "InitTestModuleSprite";

	public function InitTestModuleSprite(autoInit:Boolean) {
		super(InitTestModuleSprite.NAME, autoInit);
	}

	override protected function onInit():void {

	}

	public function start():void {
		initModule();
	}

	override protected function onDispose():void {

	}

	public function getProxyMap():ProxyMap {
		return proxyMap;
	}

	public function getCommandMap():CommandMap {
		return commandMap;
	}

	public function getMediatorMap():MediatorMap {
		return mediatorMap;
	}

}
}