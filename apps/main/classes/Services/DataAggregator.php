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
		$data		= $this->db->query('SELECT count(*) as cnt from organizations');
		$results    = $data->fetchAll();
		return (int)$results[0]['cnt'];
	
	}

	public function getActivitiesCount()
	{
		$data		= $this->db->query('SELECT count(*) as cnt from activities');
		$results    = $data->fetchAll();
		return (int)$results[0]['cnt'];	
	}

	public function getCountriesCount()
	{
		$data		= $this->db->query('SELECT COUNT(DISTINCT  country_iso2)
									as cnt from activities_countries_map');
		$results    = $data->fetchAll();
		return (int)$results[0]['cnt'];	
	}

}