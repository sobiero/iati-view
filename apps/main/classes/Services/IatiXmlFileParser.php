<?php

namespace Iati\Main\Services;

class IatiXmlFileParser
{

	public static $db;

	public function __construct()
	{
		$di = \Phalcon\DI::getDefault();
		self::$db = $di->get('db');
	}

	public static function parse($iatiXMLFilePath)
	{

		$record = \Iati\Main\Models\ImportCache::findFirst("url = '". $iatiXMLFilePath ."'");

		if (is_object($record) )
		{
			return \json_decode($record->data, true) ;
		}

		$xml = simplexml_load_file($iatiXMLFilePath);

		//print_r($xml);
		//exit;

		$sectors      = [];
		$countries    = [];
		$activities   = [];

		$x = 0;

		foreach ( $xml->children() as $activity )
		{
			
			if ($x == 0)
			{
				$org_name = preg_replace('#\R+#', '', trim((string)$activity->{'reporting-org'})) ;

				$org_name = empty($org_name) ? 
						  //(string)@$activity->{'reporting-org'}[0]
						  preg_replace('#\R+#', '', trim((string)$activity->{'reporting-org'}[0]))
						  : $org_name ;

				$org_name = empty($org_name) ? 
						 // (string)@$activity->{'reporting-org'}->narrative
						  preg_replace('#\R+#', '', trim((string)@$activity->{'reporting-org'}->narrative))
						  : $org_name ;

				$org_ref  = (string)$activity->{'reporting-org'}['ref'];
			
			}

			$id = (string)$activity->{'iati-identifier'} ;
		
			$activities[ $id ]['title']    = preg_replace('#\R+#', '', trim((string) @$activity->title))  ;	

			$activities[ $id ]['title']    = empty($activities[ $id ]['title']) ?
							preg_replace('#\R+#', '', trim((string) @$activity->title->narrative))
							: $activities[ $id ]['title'] ;	

			$activities[ $id ]['description']    = preg_replace('#\R+#', '', trim((string) @$activity->description))  ;	

			$activities[ $id ]['description']    = empty($activities[ $id ]['description']) ?
							preg_replace('#\R+#', '', trim((string) @$activity->description->narrative))
							: $activities[ $id ]['description'] ;	

			//$activities[ $id ]['description'] = implode(' ', 
			//	array_slice(explode(' ', (string) @$activity->description), 0, 20)) ."..."; 	
			
			$activities[ $id ]['currency']    = (string) @$activity['default-currency']; 	


			$activities[ $id ]['status']   = (string) @$activity->{'activity-status'} ;	
			
			if (strtolower(trim( (string)$activity->{'activity-date'}[0]['type'] )) == 'start-planned')
			{
				$activities[ $id ]['start-date'] = (string) @$activity->{'activity-date'}[0]['iso-date'];
				$activities[ $id ]['end-date']   = (string) @$activity->{'activity-date'}[1]['iso-date'];
			}
			else
			{
				$activities[ $id ]['start-date'] = (string) @$activity->{'activity-date'}[1]['iso-date'];
				$activities[ $id ]['end-date']   = (string) @$activity->{'activity-date'}[0]['iso-date'];
			}

			if ($activities[ $id ]['start-date'] > $activities[ $id ]['end-date'])
			{
				$tmp = $activities[ $id ]['start-date'];
				$activities[ $id ]['start-date'] = $activities[ $id ]['end-date'];
				$activities[ $id ]['end-date']   = $tmp;
			
			}

			

			$j = 0;
			foreach ( $activity->budget as $budget )
			{			
	
				$activities[ $id ]['budget'][$j]['period_start'] = (string)$budget->{'period-start'}['iso-date'] ;
				$activities[ $id ]['budget'][$j]['period_end']   = (string)$budget->{'period-end'}['iso-date'] ;
				$activities[ $id ]['budget'][$j]['value_date']   = (string)$budget->value['value-date']  ;
				$activities[ $id ]['budget'][$j]['value']        =  (float)$budget->value ;
					
				$j++;
			}

			$j = 0;
			foreach ( $activity->transaction as $trans )
			{			
				if (!empty((string)$trans->{'transaction-type'}['code']) )
				{
					$activities[ $id ]['transactions'][$j]['code']  = (string)$trans->{'transaction-type'}['code'] ;
					$activities[ $id ]['transactions'][$j]['value'] = (float)$trans->value ;
					$activities[ $id ]['transactions'][$j]['description'] = (string)$trans->description ;
					$activities[ $id ]['transactions'][$j]['date']  = (string)$trans->value['value-date'] ;
				}

				$j++;
			}
			
			$j = 0;
			foreach ( $activity->{'recipient-country'} as $country )
			{			
				
				$countryVal = strtoupper(trim( (string)$country['code'])) ;
				
				if(strlen($countryVal) == 2 )
				{
					$activities[ $id ]['countries'][$j]['iso2']       = $countryVal ;
					$activities[ $id ]['countries'][$j]['percentage'] = empty((string)@$country['percentage']) ? null : 
						(double)@$country['percentage'] ;
					
					$countries[ $countryVal ] = null;

				}
				$j++;

			}

			$j = 0;
			foreach ( $activity->sector as $sector )
			{			
				$sectorVal  = trim((string)$sector);

				$sectorVal  = empty($sectorVal) ? trim((string)$sector->narrative) : $sectorVal ;
				
				if( !empty( $sectorVal ) )
				{
					$activities[ $id ]['sectors'][$j]   = $sectorVal;
					$sectors[ $sectorVal ]   = null; 

				}
				$j++;
			
			}
			
		}

		$x++;

		$data = ['activities' => ['data' =>$activities, 'cnt'=>count($activities)] , 
			     'sectors' => count($sectors), 'countries' => count($countries),
			     'iati_url' => $iatiXMLFilePath, 
			     'org' => ['name' => $org_name, 'ref' => $org_ref ] ];
		
		self::saveInCache($data);

		//$data['activities']['data'] = null; 
		
		return $data ; 
		
	}

	
	public static function importToDb($iatiXMLFilePath, $db, $dataFileName)
	{
		$data = self::parse($iatiXMLFilePath);
		$m = new \Iati\Main\Models\Activities();
		$j = $m->saveActivities($data, $db, $dataFileName);
		
	}

	public static function saveInCache($data)
	{
		$record = \Iati\Main\Models\ImportCache::findFirst("url = '". $data['iati_url'] ."'");

		if (!is_object($record) )
		{
			$record = new \Iati\Main\Models\ImportCache();
		}

		$record->url           = $data['iati_url'] ;
		$record->data          = \json_encode($data) ;
		$record->date_loaded   = date("Y-m-d H:i:s") ;
		$record->imported_flag = 0;

		$record->save();

	}

}