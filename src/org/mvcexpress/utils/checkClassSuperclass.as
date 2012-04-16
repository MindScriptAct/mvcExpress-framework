package org.mvcexpress.utils {
import flash.utils.getQualifiedSuperclassName;
import flash.utils.getDefinitionByName;

/**
 * Checks if provided class is extended from provided class name
 * @author Raimundas Banevicius (raima156@yahoo.com)
 */

public function checkClassSuperclass(classObject:Class, superClassName:String):Boolean {
	var retVal:Boolean = false;
	var mediatorClassSuperClassName:String = getQualifiedSuperclassName(classObject);
	if (mediatorClassSuperClassName != superClassName) {
		var mediatorFound:Boolean = false;
		var mediatorClassName:String = mediatorClassSuperClassName;
		while (mediatorClassName != "Object" && mediatorClassName != null) {
			var superClass:Class = getDefinitionByName(mediatorClassName) as Class;
			mediatorClassName = getQualifiedSuperclassName(superClass);
			if (mediatorClassName == superClassName) {
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