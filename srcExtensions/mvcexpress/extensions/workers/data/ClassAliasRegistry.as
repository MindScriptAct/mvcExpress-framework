package mvcexpress.extensions.workers.data {
import flash.utils.Dictionary;

/**
 * Stores class description names, by classes. Basic types are added by default.
 * @private
 */
public class ClassAliasRegistry {

	static private var classes:Dictionary;

	public function ClassAliasRegistry() {
		throw Error("Static class. Use getAliasRegistry().");
	}

	static public function getAliasRegistry():Dictionary {
		if (!classes) {
			classes = new Dictionary()

			classes[null] = "null";
			classes[Boolean] = "Boolean";
			classes[int] = "int";
			classes[uint] = "uint";
			classes[Number] = "Number";
			classes[String] = "String";

			classes[Object] = "Object";
			classes[Array] = "Array";
			classes[Date] = "Date";
			classes[Error] = "Error";
			classes[Function] = "Function";
			classes[RegExp] = "RegExp";
			classes[XML] = "XML";
			classes[XMLList] = "XMLList";
		}
		return classes;
	}

	// gives list of custom classes in alias registry.
	static public function getCustomClasses():String {
		var retVal:String = "";

		if (!classes) {
			getAliasRegistry();
		}

		for each (var className:String in classes) {
			switch (className) {
				case "null":
				case "Boolean":
				case "int":
				case "uint":
				case "Number":
				case "String":
				case "Object":
				case "Array":
				case "Date":
				case "Error":
				case "Function":
				case "RegExp":
				case "XML":
				case "XMLList":
					break;
				default :
					if (retVal != "") {
						retVal += ",";
					}
					retVal += className;
					break;

			}
		}
		return retVal;
	}

	public static function mapClassAlias(newClass:Class, classQualifiedName:String):void {
		if (!classes) {
			getAliasRegistry();
		}
		classes[newClass] = classQualifiedName;
	}
}
}
