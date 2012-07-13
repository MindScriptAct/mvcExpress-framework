package suites.featureRemoteHandlerTests.testObjects {
import org.mvcexpress.modules.ModuleSprite;

/**
 * COMMENT
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class MainModule extends ModuleSprite {
	
	static public const NAME:String = "MainModule";
	
	public function MainModule() {
		super(MainModule.NAME);
	}
	
	override protected function onInit():void {
	
	}
	
	override protected function onDispose():void {
	
	}

}
}