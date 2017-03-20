<?php

namespace Iati\Main\Models;

use Phalcon\Mvc\Model;

class Sectors extends Model
{
	
	public $id;
	public $title;

	public function getSource()
    {
        return 'sectors';
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