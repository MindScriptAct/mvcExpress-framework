package suites.modelMap {
import flexunit.framework.Assert;
import org.mvcexpress.base.ModelMap;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.namespace.pureLegsCore;
import suites.modelMap.modelTestObj.ModelTestObj;
import suites.modelMap.modelTestObj.TestModel;

/**
 * COMMENT
 * @author rbanevicius
 */
public class ModelMapTests {
	
	private var messenger:Messenger;
	private var modelMap:ModelMap;
	private var callCaunter:int;
	private var callsExpected:int;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		use namespace pureLegsCore;
		messenger = Messenger.getInstance();
		modelMap = new ModelMap(messenger);
		callCaunter = 0;
		callsExpected = 0;
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		use namespace pureLegsCore;
		messenger.clear();
		modelMap = null;
		callCaunter = 0;
		callsExpected = 0;
	}
	
	//----------------------------------
	//     
	//----------------------------------	
	
	[Test]
	
	public function using_class_model():void {
		use namespace pureLegsCore;
		modelMap.mapClass(TestModel);
		var obj1:ModelTestObj = new ModelTestObj();
		modelMap.injectStuff(obj1, ModelTestObj);
		Assert.assertNotNull("Injected object must be not null", obj1.testModel);
	}
	
	//----------------------------------
	//     
	//----------------------------------
	
	[Test]
	
	public function using_class_model_twice_both_should_be_equal():void {
		use namespace pureLegsCore;
		modelMap.mapClass(TestModel);
		var obj1:ModelTestObj = new ModelTestObj();
		var obj2:ModelTestObj = new ModelTestObj();
		modelMap.injectStuff(obj1, ModelTestObj);
		modelMap.injectStuff(obj2, ModelTestObj);
		Assert.assertEquals("Injected class object must be equel everythere.", obj1.testModel, obj2.testModel);
	}
	//----------------------------------
	//     
	//----------------------------------	
	
	[Test(expects="Error")]
	
	public function mapping_class_model_twice_throws_error():void {
		modelMap.mapClass(TestModel);
		modelMap.mapClass(TestModel);
	}
	
	//----------------------------------
	//     
	//----------------------------------	
	[Test]
	
	public function using_object_test():void {
		use namespace pureLegsCore;
		var testModel:TestModel = new TestModel();
		modelMap.mapObject(testModel, TestModel);
		var obj1:ModelTestObj = new ModelTestObj();
		modelMap.injectStuff(obj1, ModelTestObj);
		Assert.assertEquals("Maped value object must be used for iject object.", obj1.testModel, testModel);
	}
	
	//----------------------------------
	//     
	//----------------------------------
	
	[Test]
	
	public function using_object_model_twice_both_should_be_equal():void {
		use namespace pureLegsCore;
		var testModel:TestModel = new TestModel();
		modelMap.mapObject(testModel);
		var obj1:ModelTestObj = new ModelTestObj();
		var obj2:ModelTestObj = new ModelTestObj();
		modelMap.injectStuff(obj1, ModelTestObj);
		modelMap.injectStuff(obj2, ModelTestObj);
		Assert.assertEquals("Injected value object must be equel everythere.", obj1.testModel, obj2.testModel);
	}
	
	//----------------------------------
	//     
	//----------------------------------	
	
	[Test(expects="Error")]
	
	public function mapping_object_model_twice_throws_error():void {
		var testModel:TestModel = new TestModel();
		modelMap.mapObject(testModel);
		modelMap.mapObject(testModel);
	}
	
	//----------------------------------
	//     
	//----------------------------------	
	[Test(expects="Error")]
	
	public function mappings_does_not_exists_throws_error():void {
		use namespace pureLegsCore;
		var obj1:ModelTestObj = new ModelTestObj();
		modelMap.injectStuff(obj1, ModelTestObj);
	}
	//----------------------------------
	//     
	//----------------------------------	
	[Test(expects="Error")]
	
	public function removing_class_model():void {
		use namespace pureLegsCore;
		modelMap.mapClass(TestModel);
		modelMap.unmapClass(TestModel);
		var obj1:ModelTestObj = new ModelTestObj();
		modelMap.injectStuff(obj1, ModelTestObj);
	}
	//----------------------------------
	//     
	//----------------------------------	
	[Test(expects="Error")]
	
	public function removing_object_model():void {
		use namespace pureLegsCore;
		var testModel:TestModel = new TestModel();
		modelMap.mapObject(testModel);
		modelMap.unmapClass(TestModel);
		var obj1:ModelTestObj = new ModelTestObj();
		modelMap.injectStuff(obj1, ModelTestObj);
	}
	
	//----------------------------------
	//     
	//----------------------------------			
	private function callBackFail(obj:* = null):void {
		Assert.fail("CallBack should not be called...");
	}
	
	public function callBackSuccess(obj:* = null):void {
	}
	
	//----------------------------------
	//     
	//----------------------------------			
	private function callBackCheck(obj:* = null):void {
		//trace( "ControllerTests.callBackCheck > obj : " + obj );
		if (callCaunter != callsExpected) {
			Assert.fail("Expected " + callsExpected + " calls, but " + callCaunter + " was received...");
		}
	}
	
	public function callBackIncrease(obj:* = null):void {
		//trace( "ControllerTests.callBackIncrease > obj : " + obj );
		callCaunter++;
	}

}
}