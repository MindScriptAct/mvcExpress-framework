// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core {
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedSuperclassName;

import mvcexpress.core.namespace.pureLegsCore;

/**
 * INTERNAL FRAMEWORK CLASS.
 * Manages mvcExpress extensions.
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 * @private
 *
 * @version 2.0.rc1
 */
public class ExtensionManager {

	CONFIG::debug
	private static var extensionIdRegistry:Dictionary = new Dictionary(); //* of int by Class */

	CONFIG::debug
	private static var extensionNameRegistry:Dictionary = new Dictionary(); //* of String by Class */

	CONFIG::debug
	private static const EXTENSION_NAMES:Dictionary = new Dictionary();

	CONFIG::debug
	private static var extensionCount:int;

	/**
	 * get extension id by extension name.
	 * @param extensionName
	 * @return
	 */
	CONFIG::debug
	public static function getExtensionIdByName(extensionName:String):int {
		if (ExtensionManager.EXTENSION_NAMES[extensionName] == null) {
			ExtensionManager.EXTENSION_NAMES[extensionName] = ++ExtensionManager.extensionCount;
		}
		return ExtensionManager.EXTENSION_NAMES[extensionName];
	}

	/**
	 * get extension name by extension id.
	 * @param extensionId
	 * @return
	 */
	CONFIG::debug
	public static function getExtensionNameById(extensionId:int):String {
		var retVal:String = "undefined";
		for (var extensionName:Object in EXTENSION_NAMES) {
			if (EXTENSION_NAMES[extensionName] == extensionId) {
				retVal = extensionName as String;
				break;
			}
		}
		return retVal;
	}

	/**
	 * get extension id for framework class.
	 * @param frameworkClass
	 * @return
	 */
	CONFIG::debug
	public static function getExtensionId(frameworkClass:Class):int {
		use namespace pureLegsCore;

		var retVal:int = 0;
		if (!extensionIdRegistry[frameworkClass]) {
			var currentClass:Class = frameworkClass;
			while (retVal == 0 && currentClass != Object) {
				retVal = currentClass["extension_id"];
				if (retVal == 0) {
					var className:String = getQualifiedSuperclassName(currentClass);
					currentClass = getDefinitionByName(className) as Class;
				} else {
					extensionNameRegistry[frameworkClass] = String(currentClass["extension_name"]);
				}
			}
			extensionIdRegistry[frameworkClass] = retVal;
		} else {
			retVal = extensionIdRegistry[frameworkClass];
		}
		return retVal;
	}

	/**
	 * get extension name for framework class.
	 * @param frameworkClass
	 * @return
	 */
	CONFIG::debug
	public static function getExtensionName(frameworkClass:Class):String {
		return extensionNameRegistry[frameworkClass];
	}


}
}
