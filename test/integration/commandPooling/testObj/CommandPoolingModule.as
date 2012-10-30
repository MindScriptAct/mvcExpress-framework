package integration.commandPooling.testObj {
import org.mvcexpress.core.CommandMap;
import org.mvcexpress.core.ProxyMap;
import org.mvcexpress.modules.ModuleCore;

public class CommandPoolingModule extends ModuleCore {
	static public const NAME:String = "CommandPoolingModule";
	
	public function CommandPoolingModule() {
		super(CommandPoolingModule.NAME);
	}
	
	public function getCommandMap():CommandMap {
		return commandMap;
	}
	
	public function getProxyMap():ProxyMap {
		return proxyMap;
	}
	
	public function sendLocalMessage(type:String):void {
		sendMessage(type);
	}
}
}