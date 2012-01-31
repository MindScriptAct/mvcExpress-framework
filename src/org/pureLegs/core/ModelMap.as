package org.pureLegs.core {
import flash.utils.describeType;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import org.pureLegs.core.inject.InjectRuleVO;
import org.pureLegs.messenger.Messenger;
import org.pureLegs.mvc.Model;
import org.pureLegs.namespace.pureLegsCore;

/**
 * ModelMap is responsible for storing model objects and handling injection.
 * @author rbanevicius
 */
public class ModelMap {
	
	/** */
	private var injectClassRegistry:Dictionary = new Dictionary();
	
	/** */
	private var classInjectRules:Dictionary = new Dictionary();
	
	/** Communication object for sending messages*/
	private var messenger:Messenger;
	
	public function ModelMap(messenger:Messenger) {
		this.messenger = messenger;
	}
	
	/**
	 * Maps model object to Class and name.
	 * @param	modelObject	Model instance to use for injection.
	 * @param	injectClass	Optional class to use for injection, if null modelObject class is used. It is helpfull if you want to map model interface or subclass.
	 * @param	name		Optional name if you need more then one model instance of same class.
	 */
	public function mapObject(modelObject:Model, injectClass:Class = null, name:String = ""):void {
		var modelClass:Class = Object(modelObject).constructor;
		if (!injectClass) {
			injectClass = modelClass;
		}
		var className:String = getQualifiedClassName(injectClass);
		if (!injectClassRegistry[className + name]) {
			use namespace pureLegsCore;
			modelObject.messanger = messenger;
			injectStuff(modelObject, modelClass);
			injectClassRegistry[className + name] = modelObject;
			modelObject.onRegister();
		} else {
			throw Error("Model object class is already mapped.[" + className + name + "]");
		}
	}
	
	/**
	 * Maps model object created from class provided to specific class and name.
	 * @param	modelClass	Model class to use for injection. Model object is created then it is mapped.
	 * @param	injectClass	Optional class to use for injection, if null modelObject class is used. It is helpfull if you want to map model interface or subclass.
	 * @param	name		Optional name if you need more then one model instance of same class.
	 */
	public function mapClass(modelClass:Class, injectClass:Class = null, name:String = ""):void {
		var className:String = getQualifiedClassName(injectClass);
		if (!injectClassRegistry[className + name]) {
			var modelObject:Model = new modelClass();
			mapObject(modelObject, injectClass, name);
		} else {
			throw Error("Model class is already mapped.[" + className + name + "]");
		}
	}
	
	/**
	 * Removes model maped for injection by class and name.
	 *  If mapping does not exists - it will fail silently.
	 *  This function will not destroy models that are already injected. It only will remove mapping for future injection usses.
	 * @param	modelClass	class previously mapped for injection
	 * @param	name		name added to class, that was previously mapped for injection
	 */
	public function unmapClass(modelClass:Class, name:String = ""):void {
		var className:String = getQualifiedClassName(modelClass);
		(injectClassRegistry[className + name] as Model).onRemove();
		delete injectClassRegistry[className + name];
	}
	
	/* Dispose modelMap on module shutDown */
	pureLegsCore function dispose():void {
		for each (var modelObject:Model in injectClassRegistry) {
			modelObject.onRemove();
		}
		injectClassRegistry = null;
		classInjectRules = null;
		messenger = null;
	}
	
	// TODO : consider making this function public...
	/**
	 * Finds inject points and injects dependiencies.
	 * tempValue and tempPclass defines injection that will be done for current object only.
	 */
	pureLegsCore function injectStuff(object:Object, signatureClass:Class, tempValue:Object = null, tempClass:Class = null):void {
		
		// deal with temporal injection. (it is used only for this injection)
		var tempClassName:String;
		if (tempValue) {
			if (tempClass) {
				tempClassName = getQualifiedClassName(tempClass);
				if (!injectClassRegistry[tempClassName]) {
					injectClassRegistry[tempClassName] = tempValue;
				} else {
					throw Error("Temp config sholud not be maped...");
				}
			}
		}
		
		// get class injection rules. (cashing is used.)
		var rules:Vector.<InjectRuleVO> = classInjectRules[signatureClass];
		if (!rules) {
			////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////
			// TODO : TEST inline function .. ( Putting inline function here ... makes commands slower.. WHY!!!)
			rules = getInjectRules(signatureClass);
				///////////////////////////////////////////////////////////
				//////////////////////////////////////////////////////////
		}
		
		// injects all dependencies using rules.
		for (var i:int = 0; i < rules.length; i++) {
			var injectObject:Object = injectClassRegistry[rules[i].injectClassName];
			if (injectObject) {
				object[rules[i].varName] = injectObject
			} else {
				throw Error("Inject object is not found for class:" + rules[i].injectClassName);
			}
		}
		
		// dispose temporal injection if it was used.
		if (tempClassName) {
			delete injectClassRegistry[tempClassName];
		}
	}
	
	/**
	 * finds and cashes class injection point rules.
	 */
	private function getInjectRules(signatureClass:Class):Vector.<InjectRuleVO> {
		var retVal:Vector.<InjectRuleVO> = new Vector.<InjectRuleVO>();
		
		var classDescription:XML = describeType(signatureClass);
		var node:XML;
		
		// TODO : optimize
		for each (node in classDescription.factory.*.(name() == "variable" || name() == "accessor").metadata.(@name == "Inject")) {
			//trace( "node : " + node );
			
			// TODO : optimize
			var name:String = "";
			var args:XMLList = node.arg;
			if (args[0]) {
				if (args[0].@key == "name") {
					name = args[0].@value;
				}
			}
			
			var mapRule:InjectRuleVO = new InjectRuleVO();
			
			mapRule.varName = node.parent().@name.toString();
			mapRule.injectClassName = node.parent().@type.toString() + name;
			
			retVal.push(mapRule);
		}
		
		classInjectRules[signatureClass] = retVal;
		
		return retVal;
	}

}
}