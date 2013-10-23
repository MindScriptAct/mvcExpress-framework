// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.live.mvc {
import flash.utils.Dictionary;

import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.live.core.ProcessMapLive;
import mvcexpress.extensions.live.modules.ModuleLive;
import mvcexpress.mvc.Mediator;

use namespace pureLegsCore;

/**
 * Mediates single view object.
 *  Main responsibility of mediator is to send messages from framework to view, and receive events from view and send them to framework as messages.       <p>
 *  Can get proxies injected.
 *  Can send message strings. (then user interacts with the view, or to inform about view state changes, like animation end)
 *  Can handle message strings. (handles data change or other framework constants)
 *  Can handle view events.                                                                                                                               </p>
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version live.1.0.beta2
 */
public class MediatorLive extends Mediator {

	/** Handle application processes
	 * @private */
	pureLegsCore var processMap:ProcessMapLive;

	/**    all objects provided by this mediator storeb by name */
	private var provideRegistry:Dictionary = new Dictionary(); //* of Object by String*/


	//----------------------------------
	//     mvcExpressLive functions
	//----------------------------------

	/**
	 * Provides any complex object under given name. Provided object can be Injected into Tasks.            <br>
	 * Providing primitive data typse will throw error in debug mode.
	 * @param    object    any complex object
	 * @param    name    name for complex object. (bust be unique, or error will be thrown.)
	 */
	public function provide(object:Object, name:String):void {
		use namespace pureLegsCore;

		processMap.provide(object, name);
		provideRegistry[name] = object;
	}

	/**
	 * Remove pasibility for provided object with given name to be Injected into Tasks.            <br>
	 * If object never been provided with this name - action will fail silently
	 * @param    name    name for provided object.
	 */
	public function unprovide(name:String):void {
		use namespace pureLegsCore;

		processMap.unprovide(name);
		delete provideRegistry[name];
	}

	/**
	 * Remove all from this mediator provided object.
	 */
	public function unprovideAll():void {
		for (var name:String in provideRegistry) {
			unprovide(name);
		}
	}


	/**
	 * framework function to dispose this mediator.                                                                            <br>
	 * Executed automatically AFTER mediator is removed(unmediated). (after mediatorMap.unmediate(...), or module dispose.)                    <br>
	 * It:                                                                                                                        <br>
	 * - remove all handle functions created by this mediator                                                                    <br>
	 * - remove all event listeners created by internal addListener() function                                                    <br>
	 * - sets internals to null                                                                                                    <br>
	 * @private
	 */
	override pureLegsCore function remove():void {
		use namespace pureLegsCore;

		unprovideAll();
		processMap = null;
		provideRegistry = null;
		super.remove();
	}


	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_id:int = ModuleLive.EXTENSION_LIVE_ID;

	/** @private */
	CONFIG::debug
	static pureLegsCore var extension_name:String = ModuleLive.EXTENSION_LIVE_NAME
}
}