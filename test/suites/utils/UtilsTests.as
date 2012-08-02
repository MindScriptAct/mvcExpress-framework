package suites.utils {
import flash.utils.getQualifiedClassName;
import flexunit.framework.Assert;
import org.mvcexpress.utils.checkClassStringConstants;
import org.mvcexpress.utils.checkClassSuperclass;
import suites.utils.objects.ClassA;
import suites.utils.objects.ClassASubclass;
import suites.utils.objects.ClassASubclassSubclass;
import suites.utils.objects.ClassB;
import suites.utils.objects.ClassBSubclass;
import suites.utils.objects.ConstantsA;
import suites.utils.objects.ConstantsAB;
import suites.utils.objects.ConstantsB;

/**
 * COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class UtilsTests {
	
	//[Before]
	//
	//public function runBeforeEveryTest():void {
	//
	//}
	//
	//[After]
	//
	//public function runAfterEveryTest():void {
	//
	//}
	
	//----------------------------------
	//     checkClassStringConstants
	//----------------------------------
	
	[Test(order=1,description="single class check")]
	
	public function utils_one_class_check():void {
		checkClassStringConstants(ConstantsA);
	}
	
	[Test(order=2,description="2 class check")]
	
	public function utils_two_class_check():void {
		checkClassStringConstants(ConstantsA, ConstantsB);
	}
	
	[Test(order=3,expects="Error",description="2 class check with dublicate constants")]
	
	public function utils_two_class_with_dublicated_constants_fails():void {
		checkClassStringConstants(ConstantsA, ConstantsAB);
	}
	
	//----------------------------------
	//     checkClassSuperclass
	//----------------------------------
	
	[Test(description="single class check")]
	
	public function utils_checkClassSuperclass_tests():void {
		Assert.assertFalse("Same class is not a subclass to self", checkClassSuperclass(ClassA, getQualifiedClassName(ClassA)));
		Assert.assertTrue("Subclass of class should be true", checkClassSuperclass(ClassASubclass, getQualifiedClassName(ClassA)));
		Assert.assertTrue("Subclass of Subclass of class should be true", checkClassSuperclass(ClassASubclassSubclass, getQualifiedClassName(ClassA)));
		Assert.assertFalse("Two diferent classes sould return false", checkClassSuperclass(ClassB, getQualifiedClassName(ClassA)));
		Assert.assertFalse("superclass of another class sould return false", checkClassSuperclass(ClassBSubclass, getQualifiedClassName(ClassA)));
	}

}
}