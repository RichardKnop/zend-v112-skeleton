<?php

class ErrorControllerTest extends Zend_Test_PHPUnit_ControllerTestCase
{

	public function setUp()
	{
		$this->bootstrap = new Zend_Application(APPLICATION_ENV, APPLICATION_PATH . '/configs/application.ini');
		parent::setUp();
	}

	public function testErrorAction()
	{
		$this->dispatch('/bogus');
		$this->assertAction('error');
		$this->assertController('error');
	}

	public function testErrorAction404ResponseCode()
	{
		$this->dispatch('/bogus');
		$this->assertResponseCode(404);
	}

}