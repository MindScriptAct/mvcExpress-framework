package integration.commandPooling.testObj.controller {
import mvcexpress.mvc.Command;

public class CommPoolingDependencyRemove extends Command{

	public function execute(proxyClass:Class):void{
		proxyMap.unmap(proxyClass);
	}

}
}