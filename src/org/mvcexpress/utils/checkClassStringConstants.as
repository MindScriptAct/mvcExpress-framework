// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.utils {
import flash.utils.describeType;

/**
 * utility function to check class string constant values for acidental dublications.
 * Usage:
 *		add this code in every coreModule class in onStartUp() function with all your classes holding string constants used for messanging.
 * 		CONFIG::debug {
 *			trackClassStringConstants(ClassName);
 *		}
 * @param	... args
 */
public function checkClassStringConstants(... args:Array):void {
	//trace("void.trackStringConstants > ... args : " + args);
	
	for (var i:int = 0; i < args.length; i++) {
		var constantClass:Class = args[i] as Class;
		if (constantClass) {
			var needChecking:Boolean = true;
			for (var k:int = 0; k < StringConstantRegistry.registeredClasses.length; k++) {
				if (StringConstantRegistry.registeredClasses[k] == constantClass) {
					needChecking = false;
					break;
				}
			}
			if (needChecking) {
				StringConstantRegistry.registeredClasses.push(constantClass);
				var description:XML = describeType(constantClass);
				var constantList:XMLList = description.constant;
				for (var j:int = 0; j < constantList.length(); j++) {
					if (constantList[j].@type == "String") {
						var constantValue:String = constantClass[constantList[j].@name];
						if (StringConstantRegistry.stringRegistry[constantValue]) {
							throw Error("Class " + constantClass + " and " + StringConstantRegistry.stringRegistry[constantValue] + " have same string constant value : " + constantValue);
						} else {
							StringConstantRegistry.stringRegistry[constantValue] = constantClass;
						}
					}
				}
			}
		} else {
			throw Error("Please send Class names to trackStringConstants() only(not object).");
		}
	}
}
}

import flash.utils.Dictionary;

class StringConstantRegistry {
	static public var registeredClasses:Vector.<Class> = new Vector.<Class>();
	static public var stringRegistry:Dictionary = new Dictionary();
}