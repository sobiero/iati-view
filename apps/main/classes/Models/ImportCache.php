<?php

namespace Iati\Main\Models;

use Phalcon\Mvc\Model;

class ImportCache extends Model
{
	
	public $id;
	public $url;
	public $data;
	public $date_loaded;
	public $imported_flag;

	public function getSource()
    {
        return 'import_cache';
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