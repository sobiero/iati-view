<?php

namespace Pims\Library;

//use Phalcon\Mvc\View;
use Phalcon\Events\Event;
use Phalcon\Mvc\User\Plugin;
use Phalcon\Mvc\Dispatcher;
use Pims\Common\Models\Session;
use Pims\Common\Models\Profile;

/**
 * SecurityPlugin
 *
 * This is the security plugin which controls that users only have access to the modules they're assigned to
 */
class SecurityPlugin extends Plugin
{

	/**
	 * This action is executed before execute any action in the application
	 *
	 * @param Event $event
	 * @param Dispatcher $dispatcher
	 * @return bool
	 */
	public function beforeDispatchLoop(Event $event, Dispatcher $dispatcher)
	{
		//$token = $this->session->get('id');
	        				
	    session_start();
		$token = $_SESSION["token"];   
		$this->session->set('id', $token); 				
		

	    if($token == "")
	    {
	    	
	    	$this->session->set('auth', "");
	    	$this->session->destroy();
	        return $this->response->redirect("http://pimsdev.unep.org/pims2", true)->send();
	    }
	    else
	    {	    	
	    	$session = Session::findFirst([
				    "session_id = :sessionId: AND expired = :expired:",
				    "bind" => [
				       	"sessionId" => $token,
				       	"expired" => "0"
				    ]
				]
			);
	    	
	    	
	    	if($session)
	    	{
	    		$expired = (int)$session->expired;

	    		if($expired){
	    			return $this->response->redirect("http://pimsdev.unep.org/pims2", true)->send();
	    		}
	    		else
	    		{
	    			// get profile
		    		$profile = Profile::findFirst([
						    "username = :username:",
						    "bind" => [
						       	"username" => $session->userid
						    ]
						]
					);

					$role = "Administrators";

					if($profile->admin)
						$role = "Administrators";
					else if($profile->qas)
						$role = "Qas";
					else if($profile->member)
						$role = "Members";
					else if($profile->smt)
						$role = "Management";
					else if($profile->evaluation)
						$role = "Evaluation";
					
					
					$this->session->set(
			            'auth',
			            [
			                'id'       => $profile->uid,
			                'fullname' => $profile->fullname,
			                'email'    => $profile->email,
			                'role'     => $role
			            ]
			        );
	    		}
	    		
	    	}
	    	else
	    	{
	    		$this->session->set('auth', "");
	    		$this->session->destroy();
	    		return $this->response->redirect("http://pimsdev.unep.org/pims2", true)->send();
	    	}
	    	
	    }	    
				
	}
}
