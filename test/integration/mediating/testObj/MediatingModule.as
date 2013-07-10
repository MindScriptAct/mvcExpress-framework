package integration.mediating.testObj {
import mvcexpress.core.MediatorMap;
import mvcexpress.modules.ModuleCore;

public class MediatingModule extends ModuleCore {
	static public const NAME:String = "MediatingModule";

	public function MediatingModule() {
		super(MediatingModule.NAME);
	}

	public function getMediatorMap():MediatorMap {
		return mediatorMap;
	}

}
}