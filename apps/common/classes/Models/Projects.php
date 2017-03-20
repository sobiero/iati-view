<?php

namespace Pims\Common\Models;

use Phalcon\Mvc\Model;

class Projects extends Model
{
	
    public function initialize()
    {
        $this->setSource("project_gen_info");
    }

	public function getSource()
    {
        return "project_gen_info";
    }
    /*
    public function getId()
    {
        return $this->id;
    }

    public function getProjectID()
    {
        return $this->projectID;
    }

    public function getProjectTitle()
    {
        return $this->projectTitle;
    }

    public function getProjectStatus()
    {
        return $this->ProjectStatus;
    }
    */	

}