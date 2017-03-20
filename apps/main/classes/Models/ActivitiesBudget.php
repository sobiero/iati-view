<?php

namespace Iati\Main\Models;

use Phalcon\Mvc\Model;

class ActivitiesBudget extends Model
{
	
	public $id;
	public $activity_id;
	public $period_start;
	public $period_end;
	public $value_date;
	public $value;

	public function getSource()
    {
        return 'activities_budget';
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