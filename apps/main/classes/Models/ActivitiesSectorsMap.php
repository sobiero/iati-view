<?php

namespace Iati\Main\Models;

use Phalcon\Mvc\Model;

class ActivitiesSectorsMap extends Model
{
	
	public $id;
	public $activity_id;
	public $sector_id;

	public function getSource()
    {
        return 'activities_sectors_map';
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