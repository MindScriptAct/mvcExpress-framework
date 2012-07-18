package suites.testObjects.testModule {
import org.mvcexpress.modules.ModuleSprite;

/**
 * COMMENT : todo
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */
public class TestModule extends ModuleSprite {
	
	static public const NAME:String = "TestModule";
	
	public function TestModule() {
		super(TestModule.NAME);
	}
	
	override protected function onInit():void {
	
	}
	
	override protected function onDispose():void {
	
	}
	
}
}