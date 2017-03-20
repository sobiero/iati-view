<?php

namespace Iati\Main\Models;

use Phalcon\Mvc\Model;

class ActivitiesTransactions extends Model
{
	
	public $id;
	public $activity_id;
	public $trans_code;
	public $trans_date;
	public $trans_value;
	public $trans_desc;


	public function getSource()
    {
        return 'activities_transactions';
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