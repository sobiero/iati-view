<?php

namespace Iati\Main\Controllers;

use Iati\Common\Controllers\BaseController as Controller;

use Iati\Main\Services\DataAggregator;

class IatiFilesController extends Controller
{

	public $viewPath;
	public $dataAgg;

	public function initialize()
	{
		$this->viewPath = APP_PATH . 'apps/main/views/';
		$this->dataAgg  = new DataAggregator($this->db);
		parent::initialize();
	}

	
	public function readAction()
	{
		if ($this->request->isPost() )
		{
			
			$iatiFileUrl = $this->request->getPost("iati_url");
			//print_r($iatiFileUrl);
			
			$data = \Iati\Main\Services\IatiXmlFileParser::parse($iatiFileUrl);
			$resp = ['status' => 'success', 'code' => 1 ,  'data' => $data ] ;
			return $this->response->setJsonContent( $resp );	
		}
		else
		{
			$this->view->sidebar = $this->view
								->setParamToView('data', @$data)
			                    ->getPartial($this->viewPath . 'sections/sidebar_tps'); 

			$js[] = $this->view->getPartial($this->viewPath . 'iati-files/js_main'); 
			
			$this->view->javascript = $js;

			$this->view->content = $this->view								
			                    ->getPartial($this->viewPath . 'iati-files/form_import');
		}

	}


	public function importAction()
	{
		if ($this->request->isPost() )
		{
			
			$iatiFileUrl  = $this->request->getPost("iati_url");
			$dataFileName = $this->request->getPost("data_file_name");

			

			$this->db->begin();
			try 
			{

				$data = \Iati\Main\Services\IatiXmlFileParser::importToDb($iatiFileUrl, $this->db, $dataFileName );
				$this->db->commit();
				$resp = ['status' => 'success', 'code' => 1 ,  'data' => null, 'msg' => 'Successfully imported' ] ;

			} catch (\Exception $e)
			{
			
				$this->db->rollback();
				$resp = ['status' => 'error', 'code' => 0 ,  'data' => null , 'msg' => $e->getMessage()  ] ;

			}
			
			
			return $this->response->setJsonContent( $resp );	
		}

	}


	public function tps_dashboardAction()
	{
		$this->view->sidebar = $this->view
								->setParamToView('data', @$data)
			                    ->getPartial($this->viewPath . 'sections/sidebar_tps'); 

			$js[] = $this->view->getPartial($this->viewPath . 'iati-files/js_tps'); 
			$js[] = $this->view->getPartial($this->viewPath . 'iati-files/js_calcs'); 
			
			$this->view->javascript = $js;

					
			$data = [
				      'recent_iatifiles' => $this->dataAgg->getLatestActivityFiles(),
				     
			        ];

			
			$this->view->content = $this->view	
								->setParamToView('data', @$data)
			                    ->getPartial($this->viewPath . 'iati-files/tps_dashboard');
	}

	public function eds_dashboardAction()
	{
		$this->view->sidebar = $this->view
								->setParamToView('data', @$data)
			                    ->getPartial($this->viewPath . 'sections/sidebar_tps'); 

			$js[] = $this->view->getPartial($this->viewPath . 'iati-files/js_tps'); 
			$js[] = $this->view->getPartial($this->viewPath . 'iati-files/js_map'); 
			
			$this->view->javascript = $js;

					
			$data = [];

			
			$this->view->content = $this->view	
								->setParamToView('data', @$data)
			                    ->getPartial($this->viewPath . 'iati-files/eds_dashboard');
	}



	public function testxmlAction()
	{
	
		$xml = simplexml_load_file('http://web.local.net/sites/text.xml');


		//print_r($xml);

		foreach ( $xml->children() as $activity )
		{
			
			
			foreach( $activity->{'creator-d'} as $c)
			{
				$dt[(string)$activity['name']][] = (string)$c ;
			}

		}

		print_r($dt);


		exit;

	}



}