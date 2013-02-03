// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.utils {
	import flash.utils.describeType;

/**
 * utility function to check class string constant values for accidental duplications.  																		</br>
 * Usage:																																						</br>
 *		add this code in every module class in onInit() function with all your classes holding string constants used for messaging.							    </br>
 * 		CONFIG::debug {																																			</br>
 *			checkClassStringConstants(ClassName1,ClassName2...ClassNameX);																												</br>
 *		}																																						</br>
 * @param	... args	array of Class objects, to be checked for constants.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public function checkClassStringConstants(... args:Array):void {
	var argCount:int = args.length;
	for (var i:int; i < argCount; i++) {
		var constantClass:Class = args[i] as Class;
		if (constantClass) {
			var needChecking:Boolean = true;
			// check if class is already analyzed.
			if (StringConstantRegistry.registeredClasses[constantClass] != true) {
				var description:XML = describeType(constantClass);
				var constantList:XMLList = description.constant;
				var constantCount:int = constantList.length();
				for (var j:int = 0; j < constantCount; j++) {
					if (constantList[j].@type == "String") {
						var constantValue:String = constantClass[constantList[j].@name];
						if (StringConstantRegistry.stringRegistry[constantValue]) {
							throw Error("Class " + constantClass + " and " + StringConstantRegistry.stringRegistry[constantValue] + " have same string constant value : " + constantValue);
						} else {
							StringConstantRegistry.stringRegistry[constantValue] = constantClass;
						}
					}
				}
				StringConstantRegistry.registeredClasses[constantClass] = true;
			}
		} else {
			throw Error("Please send Class names to checkClassStringConstants() only(not object or strings).");
		}
	}
}
}
import flash.utils.Dictionary;

class StringConstantRegistry {
	static public var registeredClasses:Dictionary = new Dictionary(); /* of Boolean by Class */
	static public var stringRegistry:Dictionary = new Dictionary(); /* of Class by String */
}