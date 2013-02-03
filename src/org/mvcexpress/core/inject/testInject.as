// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package org.mvcexpress.core.inject {
import flash.utils.describeType;

/**
 * Small class to test if framework can use Inject metadata tag.
 * (It might be not compiled in, in release mode if '-keep-as3-metadata+=Inject' compile argument is not used.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class testInject {
	
	[Inject]
	public var metadataTest:Boolean;
	
	public function testInjectMetaTag():Boolean {
		var retVal:Boolean = false;
		
		var classDescription:XML = describeType(testInject);
		var factoryNodes:XMLList = classDescription.factory.*;
		var nodeCount:int = factoryNodes.length();
		for (var i:int; i < nodeCount; i++) {
			var node:XML = factoryNodes[i];
			var nodeName:String = node.name();
			if (nodeName == "variable") {
				var metadataList:XMLList = node.metadata;
				var metadataCount:int = metadataList.length()
				for (var j:int = 0; j < metadataCount; j++) {
					nodeName = metadataList[j].@name;
					if (nodeName == "Inject") {
						retVal = true;
					}
				}
			}
		}
		return retVal;
	}

}
}