<?php

class Saffron_Model_FooTest extends PHPUnit_Framework_TestCase
{

	protected $object;

	protected function setUp()
	{
		$this->object = new Saffron_Model_Foo;
	}

	function testFooBar()
	{
		$this->assertTrue(true);
	}

}
