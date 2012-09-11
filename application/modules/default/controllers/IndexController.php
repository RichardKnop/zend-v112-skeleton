<?php

class IndexController extends Saffron_AbstractController
{

	public function indexAction()
	{
		$this->view->headTitle('Hello World');
	}

}