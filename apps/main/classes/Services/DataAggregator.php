<?php

namespace Iati\Main\Services;

class DataAggregator
{

	public $db;

	public function __construct($db)
	{
		$this->db = $db;
	}

	public function getOrganizationsCount()
	{
		$data		= $this->db->query('SELECT count(*) 
							as cnt from organizations');
					$data->setFetchMode(\Phalcon\Db::FETCH_ASSOC);
		$results    = $data->fetchAll();
		return (int)$results[0]['cnt'];
	
	}

	public function getActivitiesCount()
	{
		$data		= $this->db->query('SELECT count(*) as
								cnt from activities');
					$data->setFetchMode(\Phalcon\Db::FETCH_ASSOC);
		$results    = $data->fetchAll();
		return (int)$results[0]['cnt'];	
	}

	public function getCountriesCount()
	{
		$data		= $this->db->query('SELECT COUNT(DISTINCT  country_iso2)
									as cnt from activities_countries_map');
					$data->setFetchMode(\Phalcon\Db::FETCH_ASSOC);
		$results    = $data->fetchAll();
		return (int)$results[0]['cnt'];	
	}

	public  function getActivityFiles() : string
	{
		$data		= $this->db->query('SELECT
											i.id,
											org_name,
											data_file_name
										FROM
											iatifiles i,
											organizations o
										WHERE
											i.organization_id = o.id');
					$data->setFetchMode(\Phalcon\Db::FETCH_ASSOC);
		$results    = $data->fetchAll();
		return (int)$results[0]['cnt'];	
	}

	public function getLatestActivityFiles()
	{
		$data = $this->db->query("SELECT
							o.org_name,
							i.data_file_name,
							count(a.title) AS nbr_of_activities
						FROM
							iatifiles i,
							organizations o,
							activities a
						WHERE
							i.organization_id = o.id
						AND a.iatifiles_id = i.id
						GROUP BY
							i.data_file_name
						ORDER BY
							i.id DESC
						LIMIT 5
							");
			   $data->setFetchMode(\Phalcon\Db::FETCH_ASSOC);
		return $data->fetchAll();
	}

	public function getTotalExpenditure()
	{
		$data = $this->db->query("SELECT
									a.currency,
								    sum(ats.trans_value) as value
								FROM
									activities_transactions ats,
									activities a
								WHERE
								ats.activity_id = a.id
									and ats.trans_code IN ('E', '4')
								GROUP BY a.currency
							");
			   $data->setFetchMode(\Phalcon\Db::FETCH_ASSOC);
		return $data->fetchAll();
	}

	public function getAggregatedTransactions($orgIDs = null, $fileIDs =null,
		$ctryISO2s=null, $transCode = 'E')
	{
		$filter = '';
		

		if (!empty($orgIDs))
		{
			$t = explode(",", $orgIDs);
			
			if ( count($t) > 0 )
			{
				$tmp = implode(",", $t );
			}
			else
			{
				$tmp = $orgIDs;
			}

			$filter .= ' AND org.id IN ('.$tmp.') ';
		
		}

		if (!empty($fileIDs))
		{
			$t = explode(",", $fileIDs);
			
			if ( count($t) > 0 )
			{
				$tmp = implode(",", $t );
			}
			else
			{
				$tmp = $fileIDs;
			}

			$filter .= ' AND ifs.id IN ('.$tmp.') ';
		
		}

		if (!empty($ctryISO2s))
		{
			$t = explode(",", $ctryISO2s);
			
			if ( count($t) > 0 )
			{
				$tmp = "'".implode("','", $t )."'";
			}
			else
			{
				$tmp = $ctryISO2s;
			}

			$filter .= ' AND c.iso2 IN ('.$tmp.') ';
		
		}


		$t = $this->_getTransactionCode($transCode);

		
		if (is_array($t['code']))
		{
			$trans_type = $t['name'];
			
			if ( count($t) > 0 )
			{
				$tmp = "'".implode("','", $t['code'] )."'";
			}

			$filter .= ' AND ats.trans_code IN ('.$tmp.') ';

		
		} else {
			$tmp = "'E','4'";
			$trans_type = "Expenditure";
		
			$filter .= " AND ats.trans_code IN (". $tmp .")";
		}


		$sql = "SELECT
					ifs.id AS iatifiles_id,
					ifs.data_file_name,
					org.id AS org_id,
					org.org_name,
					a.currency,
					c.iso2,
					c.iso3,
					c.`name`,
					(
						CASE
						WHEN (
							ISNULL(acm.percentage_to_country)
						) THEN
							sum(ats.trans_value)
						ELSE
							sum(
								ats.trans_value * acm.percentage_to_country
							)
						END
					) AS expenditure
				FROM
					activities_transactions ats,
					activities a,
					activities_countries_map acm,
					iatifiles ifs,
					countries c,
					organizations org
				WHERE
					ats.activity_id = a.id
				AND acm.country_iso2 = c.iso2
				AND acm.activity_id = a.id
				AND ifs.id = a.iatifiles_id
				AND ifs.organization_id = org.id
				". $filter ."
				GROUP BY
					ifs.id,
					c.iso2,
					a.currency
					";
		
		
		$data = $this->db->query($sql);
						
			   $data->setFetchMode(\Phalcon\Db::FETCH_ASSOC);

			   $tmp = str_ireplace("'", "", $tmp);

		return ['data' => $data->fetchAll(), 'trns' => [ 'type'=>$trans_type, 'code'=> $tmp ] ];

		

	}

	public function getOrganizations()
	{

		$sql = "SELECT
					id,
					org_name
				FROM
				  organizations o
				  ORDER BY org_name
				";

		
		$data = $this->db->query($sql);
						
			   $data->setFetchMode(\Phalcon\Db::FETCH_ASSOC);

		return $data->fetchAll();
		

	}

	public function getIatiFiles($orgIDs)
	{
		$filter = '';
		
		if (!empty($orgIDs))
		{
			$t = explode(",", $orgIDs);
			
			if ( count($t) > 0 )
			{
				$tmp = implode(",", $t );
			}
			else
			{
				$tmp = $orgIDs;
			}

			$filter .= ' AND o.id IN ('.$tmp.') ';
		
		}



		$sql = "SELECT
					ifs.*
				FROM
					iatifiles ifs,
				    organizations o
				WHERE
					 o.id = ifs.organization_id
				". $filter . " ORDER BY ifs.data_file_name " ;

		
		$data = $this->db->query($sql);
						
			   $data->setFetchMode(\Phalcon\Db::FETCH_ASSOC);

		return $data->fetchAll();
		

	}

	public function getCountries($orgIDs = null, $fileIDs =null)
	{
		$filter = '';
		
		if (!empty($orgIDs))
		{
			$t = explode(",", $orgIDs);
			
			if ( count($t) > 0 )
			{
				$tmp = implode(",", $t );
			}
			else
			{
				$tmp = $orgIDs;
			}

			$filter .= ' AND o.id IN ('.$tmp.') ';
		
		}

		if (!empty($fileIDs))
		{
			$t = explode(",", $fileIDs);
			
			if ( count($t) > 0 )
			{
				$tmp = implode(",", $t );
			}
			else
			{
				$tmp = $fileIDs;
			}

			$filter .= ' AND ifs.id IN ('.$tmp.') ';
		
		}

		$sql = "SELECT DISTINCT
					acm.country_iso2 AS iso2,
					c.iso3,
					c.`name`
				FROM
					activities_countries_map acm,
					activities a,
					iatifiles ifs,
				    organizations o,
					countries c
				WHERE
					acm.country_iso2 = c.iso2
				AND a.id = acm.activity_id
				AND a.iatifiles_id = ifs.id
				AND o.id = ifs.organization_id
				". $filter . " ORDER BY c.`name`" ;

		
		$data = $this->db->query($sql);
						
			   $data->setFetchMode(\Phalcon\Db::FETCH_ASSOC);

		return $data->fetchAll();

	}

	public function getTransactionCodes($orgIDs = null, $fileIDs =null)
	{
		$filter = '';
		
		if (!empty($orgIDs))
		{
			$t = explode(",", $orgIDs);
			
			if ( count($t) > 0 )
			{
				$tmp = implode(",", $t );
			}
			else
			{
				$tmp = $orgIDs;
			}

			$filter .= ' AND o.id IN ('.$tmp.') ';
		
		}

		if (!empty($fileIDs))
		{
			$t = explode(",", $fileIDs);
			
			if ( count($t) > 0 )
			{
				$tmp = implode(",", $t );
			}
			else
			{
				$tmp = $fileIDs;
			}

			$filter .= ' AND ifs.id IN ('.$tmp.') ';
		
		}

		$sql = "SELECT DISTINCT
					tc.id,
					tc.`code`,
					tc.numeric_value,
					tc.`name`
				FROM
					transaction_codes tc,
					activities_transactions ats,
					activities a,
					iatifiles ifs,
					organizations o
				WHERE
					(
						ats.trans_code = tc.`code`
						OR ats.trans_code = tc.numeric_value
					)
				AND a.id = ats.activity_id
				AND a.iatifiles_id = ifs.id
				AND o.id = ifs.organization_id
				". $filter . " ORDER BY tc.`name`" ;
		
		$data = $this->db->query($sql);
						
			   $data->setFetchMode(\Phalcon\Db::FETCH_ASSOC);

		return $data->fetchAll();

	}

	private function _getTransactionCode($transCode)
	{
		$m = [];
		$sql = is_numeric($transCode) ? ' WHERE numeric_value = ' . $transCode
			    : " WHERE code = '". $transCode ."'" ;
		
		$sql = "SELECT code, numeric_value, name FROM transaction_codes " . $sql ;

		

		$data = $this->db->query($sql);
						
			   $data->setFetchMode(\Phalcon\Db::FETCH_ASSOC);

		$d = $data->fetchAll();

		

		if (count($d) > 0 )
		{
			$m = [ $d[0]['code'], $d[0]['numeric_value'] ];

			return ['code'=>$m, 'name' => $d[0]['name'] ];

		}
		else
		{
			return null;
		}
		
	
	}

}