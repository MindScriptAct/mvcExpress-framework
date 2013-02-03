// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.utils {
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedSuperclassName;

/**
 * Checks if class is extended from another class provided by name.
 * Will return false if it is of same type as superClassName, or other type that has nothing to do with superClassName.
 * Used for debugging only.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */

public function checkClassSuperclass(classObject:Class, superClassName:String):Boolean {
	var retVal:Boolean; // = false;
	var classObjectSuperClassName:String = getQualifiedSuperclassName(classObject);
	if (classObjectSuperClassName != superClassName) {
		var className:String = classObjectSuperClassName;
		while (className != "Object" && className != null) {
			var superClass:Class = getDefinitionByName(className) as Class;
			className = getQualifiedSuperclassName(superClass);
			if (className == superClassName) {
				retVal = true;
				break;
			}
		}
	} else {
		retVal = true;
	}
	return retVal;
}

}
