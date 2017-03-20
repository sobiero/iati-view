<?php

namespace Iati\Main\Models;

use Phalcon\Mvc\Model;

class ActivitiesCountriesMap extends Model
{
	
	public $id;
	public $country_iso2;
	public $activity_id;
	public $percentage_to_country;

	public function getSource()
    {
        return 'activities_countries_map';
    }

    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}