package suites.modules {
import suites.modules.objects.CoreModuleTester;

/**
 * COMMENT
 * @author
 */
public class ModularTests {

	[Before]

	public function runBeforeEveryTest():void {
	}

	[After]

	public function runAfterEveryTest():void {
	}

	[Test(description="just instantiating core module")]

	public function modules_construct_core_module():void {
		new CoreModuleTester();
	}

}
}