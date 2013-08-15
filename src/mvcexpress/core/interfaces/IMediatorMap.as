// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.interfaces {

/**
 * Interface for Mediator. MediatorsMap use mediators with this interface.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 *
 * @version 2.0.beta2
 */
public interface IMediatorMap {

	/**
	 * Mediates provided viewObject with mapped mediator.
	 * Automatically instantiates mediator class(if mapped), handles all injections(including viewObject), and calls onRegister function.
	 * Throws error if mediator class is not mapped to viewObject class.
	 * @param    viewObject    view object to mediate.
	 */
	function mediate(viewObject:Object):void;

	/**
	 * Mediates viewObject with specified mediator class.
	 * It is usually better practice to use 2 step mediation(map(), mediate()) instead of this function. But sometimes it is not possible.
	 * @param    viewObject        view object to mediate.
	 * @param    mediatorClass    mediator class that will be instantiated and used to mediate view object
	 * @param    injectClass        inject mediator as this class.
	 */
	function mediateWith(viewObject:Object, mediatorClass:Class, injectClass:Class = null):void;

	/**
	 * Unmediated view object
	 * If any mediator is mediating viewObject - it calls onRemove on that mediator, automatically removes all message handlers, all event listeners and disposes it.
	 * @param    viewObject    view object witch mediator will be destroyed.
 	 * @param    mediatorClass    optional parameter to unmediate specific class. If this not set - all mediators will be removed.
	 */
	function unmediate(viewObject:Object, mediatorClass:Class = null):void;

	/**
	 * Checks if mediator class is mapped to view class.
	 * @param    viewClass        view class that has to be mediated by mediator class then mediate(viewObject) is called.
	 * @param    mediatorClass    Optional Mediator class, if provided will check if viewClass is mapped to this particular mediator class.
	 * @return                    true if view class is already mapped to mediator class.
	 */
	function isMapped(viewClass:Class, mediatorClass:Class = null):Boolean;

	/**
	 * Checks if view object is mediated.
	 * @param    viewObject        View object to check if it is mediated.
	 * @param    mediatorClass        Optional parameter to check if view object is mediated with specific mediator.
	 * @return     true if view object is mediated.
	 */
	function isMediated(viewObject:Object, mediatorClass:Class = null):Boolean;
}
}