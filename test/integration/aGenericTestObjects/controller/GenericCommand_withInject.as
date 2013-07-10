package integration.aGenericTestObjects.controller {
import integration.aGenericTestObjects.model.GenericTestProxy;
import mvcexpress.mvc.Command;

public class GenericCommand_withInject extends Command {

	[Inject]
	public var genericTestProxy:GenericTestProxy;

	public function execute(blank:Object):void {

	}

}
}