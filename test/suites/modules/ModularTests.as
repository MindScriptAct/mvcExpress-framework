package suites.modules {
import suites.modules.objects.CoreModuleTester;
import suites.modules.objects.MovieClipModuleTester;
import suites.modules.objects.SpriteModuleTester;

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
	
	[Test(description="just instantiating sprite module")]
	
	public function modules_construct_sprite_module():void {
		new SpriteModuleTester();
	}
	
	[Test(description="just instantiating movieclip module")]
	
	public function modules_construct_movieclip_module():void {
		new MovieClipModuleTester();
	}
}
}