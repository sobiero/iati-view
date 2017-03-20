<?php

namespace Iati\Main\Controllers;

use Iati\Common\Controllers\BaseController as Controller;

class IndexController extends Controller
{

	var $viewPath = APP_PATH . 'apps/main/views/';

	public function indexAction()
	{
		
		$this->view->sidebar = $this->view
								//->setParamToView('annex_groups', '')
			                    ->getPartial($this->viewPath . 'sections/sidebar_tps'); 



	}
}