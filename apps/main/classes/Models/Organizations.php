<?php

namespace Iati\Main\Models;

use Phalcon\Mvc\Model;

class Organizations extends Model
{
	
	public $id;
	public $org_name;

	public function getSource()
    {
        return 'organizations';
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