package test {
import flash.display.Sprite;

/**
 * COMMENT
 * @author rbanevicius
 */
public class TestingElm {
	
	public var obj1:Object;
	private var _obj2:Object;
	
	public var handleCallBack:Function;
	
	public function TestingElm(handleCallBack:Function){
		this.handleCallBack = handleCallBack;
		
		obj1 = new Sprite();
		_obj2 = new Sprite();
	}
	
	public function get obj2():Object {
		return _obj2;
	}

}
}