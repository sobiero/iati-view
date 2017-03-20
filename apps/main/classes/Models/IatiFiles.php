<?php

namespace Iati\Main\Models;

use Phalcon\Mvc\Model;

class IatiFiles extends Model
{
	
	public $id;
	public $organization_id;
	public $iati_file_url;
	public $data_file_name;

	public function getSource()
    {
        return 'iatifiles';
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