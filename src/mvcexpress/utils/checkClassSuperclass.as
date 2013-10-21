// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.utils {
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import flash.utils.getQualifiedSuperclassName;

/**
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version 2.0.rc1
 */

/**
 * Checks if class is extended from or is of class provided by name.
 * Used for debugging.
 *
 * @param classObject            Class to check
 * @param superClassName        superclass type name
 * @param allowSameClassType    allows classObject to be of provided superClassName type. (if false, only superclasses will be checked)
 * @return    true if clossObject is extended from provided super class, or is of that class if allowSameClassType set to true.
 */
public function checkClassSuperclass(classObject:Class, superClassName:String, allowSameClassType:Boolean = false):Boolean {
	var retVal:Boolean; // = false;
	if (allowSameClassType) {
		var classObjectClassName:String = getQualifiedClassName(classObject);
		if (classObjectClassName == superClassName) {
			retVal = true;
		}
	}
	if (!retVal) {
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
	}
	return retVal;
}
}
