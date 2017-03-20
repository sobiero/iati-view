<?php

namespace Pims\Common\Models;

use Phalcon\Mvc\Model;

class Profile extends Model
{
	
    public function initialize()
    {
        $this->setSource("pims_profiles");
    }  

	public function getSource()
    {
        return "pims_profiles";
    }

    

}