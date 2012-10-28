package integration.commandPooling.testObj {
import org.mvcexpress.core.CommandMap;
import org.mvcexpress.modules.ModuleCore;

public class CommandPoolingModule extends ModuleCore {
	static public const NAME:String = "CommandPoolingModule";
	
	public function CommandPoolingModule() {
		super(CommandPoolingModule.NAME);
	}
	
	public function getCommandMap():CommandMap {
		return commandMap;
	}

}
}