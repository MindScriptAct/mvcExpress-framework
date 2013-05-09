package integration.moduleInitTests {
	import flexunit.framework.Assert;
	import integration.moduleInitTests.testObj.InitTestModuleCore;
	import integration.moduleInitTests.testObj.InitTestModuleMovieClip;
	import integration.moduleInitTests.testObj.InitTestModuleSprite;
	import org.mvcexpress.modules.ModuleCore;
	
/**
 * COMMENT
 * @author mindscriptact
 */
public class ModuleInitTests {
	
	private var module:Object;
	
	[Before]
	
	public function runBeforeEveryTest():void {
		
	}
	
	[After]
	
	public function runAfterEveryTest():void {
		if (module) {
			module["disposeModule"]();
		}
	}
	
	//----------------------------------
	//	moduleCore    
	//----------------------------------
	
	[Test]
	
	public function moduleInit_coreAutoInit_notNull():void {
		var testModule:InitTestModuleCore = new InitTestModuleCore(true);
		module = testModule;
		
		Assert.assertNotNull("ModuleCore proxyMap should be not null after autoInit", testModule.getProxyMap());
		Assert.assertNotNull("ModuleCore commandMap should be not null after autoInit", testModule.getCommandMap());
		Assert.assertNotNull("ModuleCore mediatorMap should be not null after autoInit", testModule.getMediatorMap());
	}
	
	[Test]
	
	public function moduleInit_coreNoAutoInit_null():void {
		var testModule:InitTestModuleCore = new InitTestModuleCore(false);
		module = testModule;
		
		Assert.assertNull("ModuleCore proxyMap should be null after no autoInit", testModule.getProxyMap());
		Assert.assertNull("ModuleCore commandMap should be null after no autoInit", testModule.getCommandMap());
		Assert.assertNull("ModuleCore mediatorMap should be null after no autoInit", testModule.getMediatorMap());
	}	
	
	[Test]
	
	public function moduleInit_corePostAutoInit_notNull():void {
		var testModule:InitTestModuleCore = new InitTestModuleCore(false);
		module = testModule;
		
		testModule.start();
		
		Assert.assertNotNull("ModuleCore proxyMap should be not null after later init", testModule.getProxyMap());
		Assert.assertNotNull("ModuleCore commandMap should be not null after later init", testModule.getCommandMap());
		Assert.assertNotNull("ModuleCore mediatorMap should be not null after later init", testModule.getMediatorMap());
	}	
	
	
	//----------------------------------
	//	moduleMovieClip   
	//----------------------------------
	
	[Test]
	
	public function moduleInit_movieClipAutoInit_notNull():void {
		var testModule:InitTestModuleMovieClip = new InitTestModuleMovieClip(true);
		module = testModule;
		
		Assert.assertNotNull("ModuleMovieClip proxyMap should be not null after autoInit", testModule.getProxyMap());
		Assert.assertNotNull("ModuleMovieClip commandMap should be not null after autoInit", testModule.getCommandMap());
		Assert.assertNotNull("ModuleMovieClip mediatorMap should be not null after autoInit", testModule.getMediatorMap());
	}
	
	[Test]
	
	public function moduleInit_movieClipNoAutoInit_null():void {
		var testModule:InitTestModuleMovieClip = new InitTestModuleMovieClip(false);
		module = testModule;
		
		Assert.assertNull("ModuleMovieClip proxyMap should be null after no autoInit", testModule.getProxyMap());
		Assert.assertNull("ModuleMovieClip commandMap should be null after no autoInit", testModule.getCommandMap());
		Assert.assertNull("ModuleMovieClip mediatorMap should be null after no autoInit", testModule.getMediatorMap());
	}	
	
	[Test]
	
	public function moduleInit_movieClipPostAutoInit_notNull():void {
		var testModule:InitTestModuleMovieClip = new InitTestModuleMovieClip(false);
		module = testModule;
		
		testModule.start();
		
		Assert.assertNotNull("ModuleMovieClip proxyMap should be not null after later init", testModule.getProxyMap());
		Assert.assertNotNull("ModuleMovieClip commandMap should be not null after later init", testModule.getCommandMap());
		Assert.assertNotNull("ModuleMovieClip mediatorMap should be not null after later init", testModule.getMediatorMap());
	}	
	
	//----------------------------------
	//	moduleSprite   
	//----------------------------------
	
	[Test]
	
	public function moduleInit_spriteAutoInit_notNull():void {
		var testModule:InitTestModuleSprite = new InitTestModuleSprite(true);
		module = testModule;
		
		Assert.assertNotNull("ModuleSprite proxyMap should be not null after autoInit", testModule.getProxyMap());
		Assert.assertNotNull("ModuleSprite commandMap should be not null after autoInit", testModule.getCommandMap());
		Assert.assertNotNull("ModuleSprite mediatorMap should be not null after autoInit", testModule.getMediatorMap());
	}
	
	[Test]
	
	public function moduleInit_spriteNoAutoInit_null():void {
		var testModule:InitTestModuleSprite = new InitTestModuleSprite(false);
		module = testModule;
		
		Assert.assertNull("ModuleSprite proxyMap should be null after no autoInit", testModule.getProxyMap());
		Assert.assertNull("ModuleSprite commandMap should be null after no autoInit", testModule.getCommandMap());
		Assert.assertNull("ModuleSprite mediatorMap should be null after no autoInit", testModule.getMediatorMap());
	}	
	
	[Test]
	
	public function moduleInit_spritePostAutoInit_notNull():void {
		var testModule:InitTestModuleSprite = new InitTestModuleSprite(false);
		module = testModule;
		
		testModule.start();
		
		Assert.assertNotNull("ModuleSprite proxyMap should be not null after later init", testModule.getProxyMap());
		Assert.assertNotNull("ModuleSprite commandMap should be not null after later init", testModule.getCommandMap());
		Assert.assertNotNull("ModuleSprite mediatorMap should be not null after later init", testModule.getMediatorMap());
	}	
	
}
}