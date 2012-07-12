package org.mvcexpress.utils {
import flash.utils.getQualifiedSuperclassName;
import flash.utils.getDefinitionByName;

/**
 * Checks if provided class is extended from provided class name
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */

public function checkClassSuperclass(classObject:Class, superClassName:String):Boolean {
	var retVal:Boolean = false;
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
