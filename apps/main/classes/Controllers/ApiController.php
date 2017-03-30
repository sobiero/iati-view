<?php

namespace Iati\Main\Controllers;

use Iati\Common\Controllers\BaseController as Controller;

use Iati\Main\Services\DataAggregator;

class ApiController extends Controller
{

	public $dataAgg;

	public function initialize()
	{
		$this->viewPath = APP_PATH . 'apps/main/views/';
		$this->dataAgg  = new DataAggregator($this->db);
		parent::initialize();
	}

	public function activities_summaryAction()
	{

		$data = [     'org_cnt'  => $this->dataAgg->getOrganizationsCount(),
					  'actv_cnt' => $this->dataAgg->getActivitiesCount(),
					  'ctry_cnt' => $this->dataAgg->getCountriesCount(),
				      'recent_iatifiles' => $this->dataAgg->getLatestActivityFiles(),
				      'expenses' => $this->dataAgg->getTotalExpenditure()
			        ];
		$resp = ['status' => 'success', 'code' => 1 ,  'data' => $data ] ;

		return $this->response->setJsonContent( $resp );	
	
	}

	public function transactionsAction()
	{
		
		$org    = $this->request->getQuery("org", null, null);
		$file   = $this->request->getQuery("file", null, null);
		$ctry   = $this->request->getQuery("ctry", null, null);
		$tcode  = $this->request->getQuery("tcode", null, null);



		$a = $this->dataAgg->getAggregatedTransactions($org,  $file, $ctry, $tcode);
		

		//print_r($a);
		//exit;

		$data = [];
		$data['trns_type'] = $a['trns'];

		foreach($a['data'] as $key => $value)
		{
			$data['trns'][$value['iso2']]['iso3']    = $value['iso3'];
			$data['trns'][$value['iso2']]['name']    = $value['name'];
			$data['trns'][$value['iso2']]['orgs'][$value['org_id']]['id']    = $value['org_id'];
			$data['trns'][$value['iso2']]['orgs'][$value['org_id']]['name']  = $value['org_name'];
			$data['trns'][$value['iso2']]['orgs'][$value['org_id']]['files'][ $value['iatifiles_id'] ]['name'] = $value['data_file_name'];
			$data['trns'][$value['iso2']]['orgs'][$value['org_id']]['files'][ $value['iatifiles_id'] ]['exp']  = $value['expenditure'];
			$data['trns'][$value['iso2']]['orgs'][$value['org_id']]['files'][ $value['iatifiles_id'] ]['id']   = $value['iatifiles_id'];
			$data['trns'][$value['iso2']]['orgs'][$value['org_id']]['files'][ $value['iatifiles_id'] ]['cur']  = $value['currency'];

		}

		$resp = ['status' => 'success', 'code' => 1 ,  'data' => $data ] ;

		return $this->response->setJsonContent( $resp );	
	
	}

	public function organizationsAction()
	{
		
		

		$data = $this->dataAgg->getOrganizations($org,  $file, $ctry);
		
		$resp = ['status' => 'success', 'code' => 1 ,  'data' => $data ] ;

		return $this->response->setJsonContent( $resp );	
	
	}

	public function iatifilesAction()
	{
		$org  = $this->request->getQuery("org", null, null);
		
		$org  = $this->request->getQuery("org", null, null);
		
		$data = $this->dataAgg->getIatiFiles($org);
		
		$resp = ['status' => 'success', 'code' => 1 ,  'data' => $data ] ;

		return $this->response->setJsonContent( $resp );	
	
	}

	public function countriesAction()
	{
		$org  = $this->request->getQuery("org", null, null);
		$file = $this->request->getQuery("file", null, null);
		
		$data = $this->dataAgg->getCountries($org, $file);
		
		$resp = ['status' => 'success', 'code' => 1 ,  'data' => $data ] ;

		return $this->response->setJsonContent( $resp );	
	
	}

	public function transaction_codesAction()
	{
		$org  = $this->request->getQuery("org", null, null);
		$file = $this->request->getQuery("file", null, null);
		
		$data = $this->dataAgg->getTransactionCodes($org, $file);
		
		$resp = ['status' => 'success', 'code' => 1 ,  'data' => $data ] ;

		return $this->response->setJsonContent( $resp );	
	
	}

	public function readexternalAction()
	{
		$url  = $this->request->getQuery("url", null, null);
		return file_get_contents($url);
	}


}





