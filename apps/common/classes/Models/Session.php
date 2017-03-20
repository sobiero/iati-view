<?php

namespace Pims\Common\Models;

use Phalcon\Mvc\Model;

class Session extends Model
{
	public function initialize()
    {
        $this->setSource("sessions");
    }

	public function getSource()
    {
        return "sessions";
    }



}