package mvcexpress.extensions.unpuremvc.core {
import flash.utils.getQualifiedClassName;

import mvcexpress.MvcExpress;
import mvcexpress.core.CommandMap;
import mvcexpress.core.MediatorMap;
import mvcexpress.core.ProxyMap;
import mvcexpress.core.messenger.Messenger;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.core.traceObjects.commandMap.TraceCommandMap_handleCommandExecute;
import mvcexpress.extensions.unpuremvc.patterns.observer.UnpureNotification;
import mvcexpress.mvc.Command;
import mvcexpress.mvc.PooledCommand;
import mvcexpress.utils.checkClassSuperclass;

use namespace pureLegsCore;

/**
 * @version unpuremvc.1.0.beta2
 */
public class UnpureCommandMap extends CommandMap {

	public function UnpureCommandMap($moduleName:String, $messenger:Messenger, $proxyMap:ProxyMap, $mediatorMap:MediatorMap) {
		super($moduleName, $messenger, $proxyMap, $mediatorMap);
	}


	/** function to be called by messenger on needed message type sent
	 * @private */
	override pureLegsCore function handleCommandExecute(messageType:String, params:Object):void {
		use namespace pureLegsCore;

		var command:Command;
		var commandClass:Class = classRegistry[messageType];
		if (commandClass) {

			// debug this action
			CONFIG::debug {
				MvcExpress.debug(new TraceCommandMap_handleCommandExecute(moduleName, command, commandClass, messageType, params));
			}

			//////////////////////////////////////////////
			////// INLINE FUNCTION runCommand() START

			// check if command is pooled.
			var pooledCommands:Vector.<PooledCommand> = commandPools[commandClass];
			if (pooledCommands && pooledCommands.length > 0) {
				command = pooledCommands.shift();
			} else {
				// check if command has execute function, parameter, and store type of parameter object for future checks on execute.

				////////////////////
				// UNPURE STUFF
				if (checkClassSuperclass(commandClass, "mvcexpress.extensions.unpuremvc.patterns.command::UnpureSimpleCommand")
						||
						checkClassSuperclass(commandClass, "mvcexpress.extensions.unpuremvc.patterns.command::UnpureMacroCommand")
						||
						getQualifiedClassName(commandClass) == "mvcexpress.extensions.unpuremvc.patterns.observer.observerCommand::UnpureObserverCommand"
						) {
					params = new UnpureNotification(messageType, params);
				} else {
					// UNPURE STUFF
					////////////////////
					CONFIG::debug {
						validateCommandParams(commandClass, params);
					}
					////////////////////
					// UNPURE STUFF
				}
				// UNPURE STUFF
				////////////////////

				// construct command
				CONFIG::debug {
					Command.canConstruct = true;
				}
				command = new commandClass();
				CONFIG::debug {
					Command.canConstruct = false;
				}

				prepareCommand(command, commandClass);
			}

			command.messageType = messageType;

			if (command is PooledCommand) {
				// init pool if needed.
				if (!pooledCommands) {
					pooledCommands = new Vector.<PooledCommand>();
					commandPools[commandClass] = pooledCommands;
				}
				command.isExecuting = true;
				command.execute(params);
				command.isExecuting = false;

				// if not locked - pool it.
				if (!(command as PooledCommand).isLocked) {
					if (pooledCommands) {
						pooledCommands[pooledCommands.length] = command as PooledCommand;
					}
				}
			} else {
				command.isExecuting = true;
				command.execute(params);
				command.isExecuting = false;
			}

			////// INLINE FUNCTION runCommand() END
			//////////////////////////////////////////////

		}

	}


}
}
