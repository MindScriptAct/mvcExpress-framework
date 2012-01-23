package suites.modelMap.namedModelTestObj {
import org.pureLegs.mvc.Model;
import suites.modelMap.modelTestObj.ITestModel;
import suites.modelMap.modelTestObj.TestModel;

/**
 * COMMENT
 * @author
 */
public class NamedModelTestingModel extends Model {
	
	[Inject]
	public var classModel:TestModel;
	
	[Inject(name="namedClassModel")]
	public var classModelNamed:TestModel;
	
	[Inject(name="namedClassModelNotNullClass")]
	public var classModelNamedNotNullClass:TestModel;
	
	[Inject]
	public var classModelInterface:ITestModel;
	
	[Inject(name="namedClassModelInterface")]
	public var classModelNamedInterface:ITestModel;
	
	[Inject(name="namedObjectModel")]
	public var objectModelNamed:TestModel;
	
	[Inject(name="namedObjectModelNotNullClass")]
	public var objectModelNamedNotNullClass:TestModel;
	
	[Inject(name="namedObjectModelInterface")]
	public var objectModelNamedInterface:ITestModel;

}
}