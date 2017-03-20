<?php
namespace Iati\Common\Controllers;

use Phalcon\Mvc\Controller;


class BaseController extends Controller
{
	private $javascript = array();

	public function addJavaScript($script)	
    {
    	array_push($this->javascript, $script);
    	$this->view->javascript = $this->javascript;
    }

    public function getJavaScript()
    {
    	return $this->javascript;
    }	

	public function initialize()
    {

		$this->tag->setTitle("IATI Viewer");
    	
		$this->view->setViewsDir( APP_PATH . "apps/common/views/");
		$this->view->setMainView('layout/base');

        $this->view->javascript = $this->javascript;


    }

	public function beforeExecuteRoute($dispatcher)
	{
		
	}

	public function afterExecuteRoute($dispatcher)
	{
	
	}

}