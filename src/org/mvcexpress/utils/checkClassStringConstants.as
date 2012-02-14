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
		} else {
			throw Error("Please provide trackStringConstants() only with Class names, not object.");
		}
	}
}
}

import flash.utils.Dictionary;

class StringConstantRegistry {
	static public var stringRegistry:Dictionary = new Dictionary();
}