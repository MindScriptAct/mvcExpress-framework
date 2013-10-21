// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.core.inject {
import flash.utils.describeType;

/**
 * Small class to test if framework can use Inject metadata tag.
 * (Inject metadata might be not compiled in, then in release mode '-keep-as3-metadata+=Inject' compile argument is not used.)
 * @private
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 *
 * @version 2.0.rc1
 */
public class InjectTester {

	[Inject]
	public var metadataTest:Boolean;

	/**
	 * Function to test if inject metadata tag information is preserved after compile.
	 * @private
	 * @return
	 */
	public function testInjectMetaTag():Boolean {
		var retVal:Boolean = false;

		var classDescription:XML = describeType(InjectTester);
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