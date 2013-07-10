package integration.aGenericTestObjects.controller {
import integration.aGenericTestObjects.model.GenericTestProxy;
import mvcexpress.mvc.Command;

public class GenericCommand_withScopedInject extends Command {

	[Inject(scope="GenericScopeIds_testScope")]
	public var genericTestProxy:GenericTestProxy;

	public function execute(blank:Object):void {

	}

}
}