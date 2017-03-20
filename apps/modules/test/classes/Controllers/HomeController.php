<?php

namespace Pims\Test\Controllers;

use Phalcon\Mvc\View;
use Phalcon\Mvc\Controller;

class HomeController extends Controller
{
	private $_view ;

	public function indexAction()
	{
		
	    $this->_view = new View();		

		$this->_view->setPartialsDir('../apps/modules/test/views/');

		$inner = $this->_view->getPartial('test/inner-test/inner');
		
		$this->view->content = $this->_view->getPartial('test/index', ['content' => $inner ]); //->setParams;


		
	}

	public function helloAction()
	{
		
		//$this->view->disable();
		echo ' Hello world from Test Module Controller Home Action Hello ';
		echo '<br>', __METHOD__;
		
	}

}
