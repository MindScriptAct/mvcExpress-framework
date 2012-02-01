package suites.modelMap {
import flexunit.framework.Assert;
import org.mvcexpress.base.ModelMap;
import org.mvcexpress.messenger.Messenger;
import org.mvcexpress.namespace.pureLegsCore;
import suites.modelMap.modelTestObj.ITestModel;
import suites.modelMap.modelTestObj.TestModel;
import suites.modelMap.namedModelTestObj.NamedModelTestingModel;

/**
 * COMMENT
 * @author
 */
public class NamedInterfacedModelMapTests {
	private var messenger:Messenger;
	private var modelMap:ModelMap;
	private var namedTestingModel:NamedModelTestingModel;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		use namespace pureLegsCore;
		messenger = Messenger.getInstance();
		modelMap = new ModelMap(messenger);
	
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		use namespace pureLegsCore;
		messenger.clear();
		modelMap = null;
	
	}
	
	[Test]	
	public function class_model_not_null():void {
		use namespace pureLegsCore;
		modelMap.mapClass(TestModel);
		modelMap.mapClass(TestModel, null, "namedClassModel");
		modelMap.mapClass(TestModel, TestModel, "namedClassModelNotNullClass");
		modelMap.mapClass(TestModel, ITestModel);
		modelMap.mapClass(TestModel, ITestModel, "namedClassModelInterface");
		
		modelMap.mapObject(new TestModel(), null, "namedObjectModel");
		modelMap.mapObject(new TestModel(), TestModel, "namedObjectModelNotNullClass");
		modelMap.mapObject(new TestModel(), ITestModel, "namedObjectModelInterface");
		
		namedTestingModel = new NamedModelTestingModel();
		modelMap.injectStuff(namedTestingModel, NamedModelTestingModel);
		
		Assert.assertNotNull(namedTestingModel.classModel);
		
		Assert.assertNotNull(namedTestingModel.classModel);
		
		Assert.assertNotNull(namedTestingModel.classModelNamed);
		
		Assert.assertNotNull(namedTestingModel.classModelNamedNotNullClass);
		
		Assert.assertNotNull(namedTestingModel.classModelInterface);
		
		Assert.assertNotNull(namedTestingModel.classModelNamedInterface);
		
		Assert.assertNotNull(namedTestingModel.objectModelNamed);
		
		Assert.assertNotNull(namedTestingModel.objectModelNamedNotNullClass);
		
		Assert.assertNotNull(namedTestingModel.objectModelNamedInterface);
	}

}
}