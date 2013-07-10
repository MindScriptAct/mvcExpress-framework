package suites.testExamples {

import org.flexunit.Assert;

public class TestCase1 {
	private var count:int = 0;
	private var testObj1:TestingObject;
	private var testObj2:TestingObject;
	private var testObj3:TestingObject;
	private var testObj4:TestingObject;

	[Before]

	public function runBeforeEveryTest():void {
		count = 10;
		testObj1 = new TestingObject();
		testObj2 = new TestingObject();
		testObj3 = testObj1;
		testObj4 = null;

	}

	[After]

	public function runAfterEveryTest():void {
		count = 0;
		testObj1 = null;
		testObj2 = null;
		testObj3 = null;
		testObj4 = null;
	}

	//[Test(description="Test is supposed to Fail",issueID="0012443")]
	//
	//public function fails2():void {
	//Assert.assertEquals(true, false);
	//}

	[Test]

	public function assertEquals_vals():void {
		Assert.assertEquals(8, count - 2);
	}

	[Test]

	public function assertEquals_objects():void {
		Assert.assertEquals(1, true);
	}

	[Test]

	public function assertStrictlyEquals_vals():void {
		Assert.assertStrictlyEquals(8, count - 2);
	}

	[Ignore("will fail...")]
	[Test]

	public function assertStrictlyEquals_objects():void {
		Assert.assertStrictlyEquals(1, true);
	}

	[Test]

	public function assertFalse():void {
		Assert.assertFalse(false)
	}

	[Test]

	public function assertTrue():void {
		Assert.assertTrue(true)
	}

	[Test]

	public function assertNotNull():void {
		Assert.assertNotNull(testObj1)
	}

	[Test]

	public function assertNull():void {
		Assert.assertNull(testObj4)
	}

	//

	[Test]

	public function failNotTrue():void {
		Assert.failNotTrue("must be not true", (1 == 1))
	}

	[Test]

	public function failTrue():void {
		Assert.failTrue("must be  true", (1 == 2))
	}

	[Test]

	public function failNotNull():void {
		Assert.failNotNull("must be null", testObj4)
	}

	[Test]

	public function failNull():void {
		Assert.failNull("must be not null", testObj1)
	}

	[Ignore("will fail...")]
	[Test]

	public function fail():void {
		Assert.fail("will fail.");
	}
}
}