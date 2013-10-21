// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.traceObjects {
import mvcexpress.core.namespace.pureLegsCore;

/**
 * Trace action id's.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
public class MvcTraceActions {

	static public const ERROR_MESSAGE:String = "ERROR!";

	static public const MODULEMANAGER_CREATEMODULE:String = "ModuleManager.createModule";
	static public const MODULEMANAGER_DISPOSEMODULE:String = "ModuleManager.disposeModule";
	static public const MODULEMANAGER_REGISTERSCOPE:String = "ModuleManager.registerScope";
	static public const MODULEMANAGER_UNREGISTERSCOPE:String = "ModuleManager.unregisterScope";

	static public const COMMANDMAP_MAP:String = "CommandMap.map";
	static public const COMMANDMAP_UNMAP:String = "CommandMap.unmap";
	static public const COMMANDMAP_EXECUTE:String = "CommandMap.execute";
	static public const COMMANDMAP_HANDLECOMMANDEXECUTE:String = "CommandMap.handleCommandExecute";

	static public const MEDIATORMAP_MAP:String = "MediatorMap.map";
	static public const MEDIATORMAP_UNMAP:String = "MediatorMap.unmap";
	static public const MEDIATORMAP_MEDIATE:String = "MediatorMap.mediate";
	static public const MEDIATORMAP_UNMEDIATE:String = "MediatorMap.unmediate";

	static public const PROXYMAP_MAP:String = "ProxyMap.map";
	static public const PROXYMAP_UNMAP:String = "ProxyMap.unmap";
	static public const PROXYMAP_LAZYMAP:String = "ProxyMap.lazyMap";
	static public const PROXYMAP_SCOPEMAP:String = "ProxyMap.scopeMap";
	static public const PROXYMAP_SCOPEUNMAP:String = "ProxyMap.scopeUnmap";
	static public const PROXYMAP_INJECTPENDING:String = "ProxyMap.injectPending";

	static public const MESSENGER_ADDHANDLER:String = "Messenger.addHandler";
	static public const MESSENGER_REMOVEHANDLER:String = "Messenger.removeHandler";
	static public const MESSENGER_SEND:String = "Messenger.send";


	//----------------------------------
	//     For internal use
	//----------------------------------

	static pureLegsCore const PROXYMAP_INJECTSTUFF:String = "ProxyMap.injectStuff";

	static pureLegsCore const MESSENGER_SEND_HANDLER:String = "Messenger.send.HANDLER";

	static pureLegsCore const MODULEBASE_SENDMESSAGE:String = "ModuleBase.sendMessage";
	static pureLegsCore const MODULEBASE_SENDMESSAGE_CLEAN:String = "ModuleBase.sendMessage.CLEAN";
	static pureLegsCore const MODULEBASE_SENDSCOPEMESSAGE:String = "ModuleBase.sendScopeMessage";
	static pureLegsCore const MODULEBASE_SENDSCOPEMESSAGE_CLEAN:String = "ModuleBase.sendScopeMessage.CLEAN";

	static pureLegsCore const COMMAND_SENDMESSAGE:String = "Command.sendMessage";
	static pureLegsCore const COMMAND_SENDMESSAGE_CLEAN:String = "Command.sendMessage.CLEAN";
	static pureLegsCore const COMMAND_SENDSCOPEMESSAGE:String = "Command.sendScopeMessage";
	static pureLegsCore const COMMAND_SENDSCOPEMESSAGE_CLEAN:String = "Command.sendScopeMessage.CLEAN";

	static pureLegsCore const MEDIATOR_SENDMESSAGE:String = "Mediator.sendMessage";
	static pureLegsCore const MEDIATOR_SENDMESSAGE_CLEAN:String = "Mediator.sendMessage.CLEAN";
	static pureLegsCore const MEDIATOR_SENDSCOPEMESSAGE:String = "Mediator.sendScopeMessage";
	static pureLegsCore const MEDIATOR_SENDSCOPEMESSAGE_CLEAN:String = "Mediator.sendScopeMessage.CLEAN";
	static pureLegsCore const MEDIATOR_ADDHANDLER:String = "Mediator.addHandler";

	static pureLegsCore const PROXY_SENDMESSAGE:String = "Proxy.sendMessage";
	static pureLegsCore const PROXY_SENDMESSAGE_CLEAN:String = "Proxy.sendMessage.CLEAN";
	static pureLegsCore const PROXY_SENDSCOPEMESSAGE:String = "Proxy.sendScopeMessage";
	static pureLegsCore const PROXY_SENDSCOPEMESSAGE_CLEAN:String = "Proxy.sendScopeMessage.CLEAN";

}
}