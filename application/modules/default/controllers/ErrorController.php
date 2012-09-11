<?php

class ErrorController extends Saffron_AbstractController
{

	public function errorAction()
	{
		$errors = $this->_getParam('error_handler');

		if (!$errors || !$errors instanceof ArrayObject) {
			$this->view->message = 'You have reached the error page';
			return;
		}

		switch ($errors->type) {
			case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ROUTE:
			case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_CONTROLLER:
			case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ACTION:
				// 404 error -- controller or action not found
				$this->getResponse()->setHttpResponseCode(404);
				$priority = Zend_Log::NOTICE;
				$this->view->message = 'Page not found';
				$this->view->headTitle('Page not found');
				break;
			default:
				// application error
				$this->getResponse()->setHttpResponseCode(500);
				$priority = Zend_Log::CRIT;
				$this->view->message = 'Application error';
				$this->view->headTitle('Application error');
				break;
		}

		// Log exception, if logger available
		if ($log = $this->_getLog()) {
			$log->log($this->view->message, $priority);
			$log->log($errors->exception->getMessage(), $priority);
			$log->log($errors->exception->getTraceAsString(), $priority);
			$log->log(var_export($errors->request->getParams(), true), $priority);
		}

		// conditionally display exceptions
		if ($this->getInvokeArg('displayExceptions') == true) {
			$this->view->exception = $errors->exception;
		}

		$this->view->request = $errors->request;
	}

	private function _getLog()
	{
		$bootstrap = $this->getInvokeArg('bootstrap');
		if (!$bootstrap->hasResource('Log')) {
			return false;
		}
		$log = $bootstrap->getResource('Log');
		return $log;
	}

}