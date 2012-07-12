package suites.utils {
import flash.utils.getQualifiedClassName;
import flexunit.framework.Assert;
import org.mvcexpress.core.utils.checkClassStringConstants;
import org.mvcexpress.core.utils.checkClassSuperclass;
import suites.utils.objects.ClassA;
import suites.utils.objects.ClassASubclass;
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
	
	public function utils_same_class_is_false():void {
		Assert.assertFalse("Same class is not a subclass to self", checkClassSuperclass(ClassA, getQualifiedClassName(ClassA)));
	}
	
	[Test(description="single class check")]
	
	public function utils_sub_class_is_true():void {
		Assert.assertTrue("Subclass of class should be true", checkClassSuperclass(ClassASubclass, getQualifiedClassName(ClassA)));
	}
	
	[Test(description="2 diferent class")]
	
	public function utils_2_diferent_class_is_false():void {
		Assert.assertFalse("Two diferent classes sould return false", checkClassSuperclass(ClassB, getQualifiedClassName(ClassA)));
	}
	
	[Test(description="2_diferent_class")]
	
	public function utils_diferent_superclass_and_class_is_false():void {
		Assert.assertFalse("superclass of another class sould return false", checkClassSuperclass(ClassBSubclass, getQualifiedClassName(ClassA)));
	}	

}
}