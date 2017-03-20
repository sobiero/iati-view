<?php
namespace Iati\Main\Models;

use Phalcon\Mvc\Model;

class Activities extends Model
{
	
	public $id;
	public $iatifiles_id;
	public $activity_iati_ref;
	public $start_date;
	public $end_date;
	public $currency;
	//public $sector;
	public $title;
	public $description;


	public function getSource()
    {
        return 'activities';
    }

    
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

	public static function saveActivities($data, $db, $dataFileName)
	{
		
		$orgId  = self::_getOrganization($data );
		$fileId = self::_getIatiFile( $data, $orgId, $dataFileName);

		$insertActivities = self::_insertActivities( $data, $fileId, $db );		
	
	}
		
	private static function _getOrganization($data)
	{
		$record = \Iati\Main\Models\Organizations::findFirst("org_name = '". $data['org']['name'] ."'");

		if (!is_object($record) )
		{
			$record = new \Iati\Main\Models\Organizations();
			$record->org_name = $data['org']['name'] ;
			$record->save();
			$id = $record->id;
		}
		else
		{
			$id = $record->id;
		}
		return $id;
	
	}


	private static function _getSectorId($sectorTitle)
	{
		$record = \Iati\Main\Models\Sectors::findFirst("title = '". $sectorTitle ."'");

		if (!is_object($record) )
		{
			$record = new \Iati\Main\Models\Sectors();
			$record->title = $sectorTitle ;
			$record->save();
			$id = $record->id;
		}
		else
		{
			$id = $record->id;
		}
		return $id;
	
	}


	private static function _getIatiFile($data, $orgId, $dataFileName)
	{
		$record = \Iati\Main\Models\IatiFiles::findFirst("iati_file_url = '". $data['iati_url']."'");

		if (!is_object($record) )
		{
			$record = new \Iati\Main\Models\IatiFiles();
		}

		$record->organization_id = $orgId ;
		$record->iati_file_url   = $data['iati_url'] ;
		$record->iati_ref        = $data['org']['ref'] ;
		$record->data_file_name  = $dataFileName ;

		$record->save();

		return $record->id;
	
	}


	private static function _insertActivities( $data, $fileId, $db )
	{
		
		//Clear previous entries
		self::_cleanActivitiesTransactions($fileId, $db);
		self::_cleanActivitiesCountriesMap($fileId, $db);
		self::_cleanActivitiesSectorsMap($fileId, $db);		
		self::_cleanActivitiesBudget($fileId, $db);			
		self::_cleanActivities($fileId, $db); //Cascadind should 		
		
		foreach($data['activities']['data'] as $key => $val )
		{
			
			$record = new \Iati\Main\Models\Activities();

			$record->iatifiles_id       = $fileId;
			$record->activity_iati_ref  = $key;
			$record->start_date         = $val['start-date'];
			$record->end_date           = $val['end-date'];
			$record->title              = $val['title'];
			$record->currency           = $val['currency'];
			$record->description        = $val['description'];

			
			$record->save();


			foreach($val['budget'] as $_val)
			{
				$_record                = new \Iati\Main\Models\ActivitiesBudget();
				$_record->activity_id   = $record->id;
				$_record->period_start  = $_val['period_start'];
				$_record->period_end    = $_val['period_end'];
				$_record->value_date    = $_val['value_date'];
				$_record->value         = $_val['value'];
				$_record->save();
			
			}

			
			foreach($val['transactions'] as $_val)
			{
				$_record                = new \Iati\Main\Models\ActivitiesTransactions();
				$_record->activity_id   = $record->id;
				$_record->trans_code    = $_val['code'];
				$_record->trans_value   = $_val['value'];
				$_record->trans_date    = $_val['date'];
				$_record->trans_desc    = $_val['description'];
				$_record->save();
			
			}


			foreach($val['countries'] as $_val)
			{
				
				$_record = \Iati\Main\Models\ActivitiesCountriesMap::
					findFirst('activity_id = '. $record->id. " AND country_iso2 = '". $_val['iso2'] ."'" );

				if(!is_object($_record))
				{

					$_record                        = new \Iati\Main\Models\ActivitiesCountriesMap();
					$_record->activity_id           = $record->id;
					$_record->country_iso2          = $_val['iso2'];
					$_record->percentage_to_country = $_val['percentage'];
					$_record->save();
				}
			
			}


			foreach($val['sectors'] as $_val)
			{

				$sectorId = self::_getSectorId($_val);

				$_record = \Iati\Main\Models\ActivitiesSectorsMap::
					findFirst('activity_id = '. $record->id. " AND sector_id = " . $sectorId );

				if(!is_object($_record))
				{

					$_record                    = new \Iati\Main\Models\ActivitiesSectorsMap();
					$_record->activity_id       = $record->id;
					$_record->sector_id         = $sectorId;
					$_record->save();
				}
			
			}
			
		}
	
	}

	private static function _cleanActivitiesCountriesMap($fileId, $db)
	{
		$qry = "DELETE
				FROM
					activities_countries_map 
				WHERE
					activities_countries_map.activity_id IN (
						SELECT
							a.id
						FROM
							activities a
						JOIN iatifiles i ON a.iatifiles_id = i.id
						AND i.id = ". $fileId ."
					)";

		$db->execute($qry);
                         
			
	}

	private static function _cleanActivitiesSectorsMap($fileId, $db)
	{
		$qry = "DELETE
				FROM
					activities_sectors_map 
				WHERE
					activities_sectors_map.activity_id IN (
						SELECT
							a.id
						FROM
							activities a
						JOIN iatifiles i ON a.iatifiles_id = i.id
						AND i.id = ". $fileId ."
					)";

		$db->execute($qry);
                         
			
	}

	private static function _cleanActivitiesTransactions($fileId, $db)
	{
		$qry = "DELETE
				FROM
					activities_transactions 
				WHERE
					activities_transactions.activity_id IN (
						SELECT
							a.id
						FROM
							activities a
						JOIN iatifiles i ON a.iatifiles_id = i.id
						AND i.id = ". $fileId ."
					)";

		$db->execute($qry);
	
	}	

	private static function _cleanActivitiesBudget($fileId, $db)
	{
		$qry = "DELETE
				FROM
					activities_budget 
				WHERE
					activities_budget.activity_id IN (
						SELECT
							a.id
						FROM
							activities a
						JOIN iatifiles i ON a.iatifiles_id = i.id
						AND i.id = ". $fileId ."
					)";

		$db->execute($qry);
	
	}	

	private static function _cleanActivities($fileId, $db)
	{
		$qry = "DELETE
				FROM
					activities
				WHERE
					iatifiles_id = ". $fileId ;

		$db->execute($qry);
	
	}

}